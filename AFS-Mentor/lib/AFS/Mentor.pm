package AFS::Mentor;
use Dancer ':syntax';
use Dancer::Plugin::Database;
use Data::Dumper;

our $VERSION = '0.1';

get '/' => sub {  
    template 'index';
};

post '/' => sub {
    
    my $callsigns=params->{callsigns};
    my $ok_chars = 'a-zA-Z0-9 ,-';   
    $callsigns =~ s/[^$ok_chars]//go;
    my $data=database->prepare('select timestamp,players from currentplayers where timestamp > date_sub(now(),interval 1 month)');
    $data->execute();
    my %result;
    while(my $a=$data->fetchrow_hashref){ 
        $result{$$a{timestamp}}=$$a{players};
    }
    
    my $output;
    my $i=0;

    print "<table border='1'>";
    print "<td><table border='1'>";
    print "<tr><td>hour (UTC)</td></tr>";
    foreach my $hour (0..23){
        if($hour=~/\b\d\b/){
            $hour="0".$hour;
        }
        print "<tr><td>$hour</td></tr>";            
    }
    print "</table></td>";

    foreach my $callsign (split/ /,$callsigns){
        my %freq;
        
        #initialize %freq
            
        foreach my $hour (0..23){
            if($hour=~/\b\d\b/){
                $hour="0".$hour;
            }
            $freq{$hour}=0;
        }

        
        print "<td>";
        print "<table border='1'>";
        print "<tr><th>$callsign</th></tr>";
        
        foreach my $timestamp (keys %result) {
            if($result{$timestamp} =~ /$callsign\@?\w*/i){
                $timestamp=~/\d (\d\d):/;
                $freq{$1}=$freq{$1} + 1;
            }
        }
        foreach my $hour (sort keys %freq){
            print "<tr><td>$freq{$hour}</td></tr>";
        }
        print "</table></td>";
    
#        $output->{$i++} = {
#            callsign => $callsign,
#            freq     => \%freq,
#        }
    }
    print "</table>";
    #template 'output', { output => $output };
    #print Dumper($output);   
};

get '/seek_master/:callsign' => sub {
    my $data=database->prepare('select timestamp,players from currentplayers where timestamp > date_sub(now(),interval 1 month)');
    $data->execute();
    #print Dumper($data->fetchrow_hashref);
    my %result;
    my $callsign=params->{callsign};
    my $ok_chars = 'a-zA-Z0-9 ,-';   
    $callsign =~ s/[^$ok_chars]//go;
    
    while(my $a=$data->fetchrow_hashref){ 
        $result{$$a{timestamp}}=$$a{players};
    }
    
    my %freq;
    
    foreach my $timestamp (keys %result) {
#        if($result{$timestamp} =~ /$callsign\@?\w*\((\d+)\)/i){
         if($result{$timestamp} =~ /$callsign\@?\w*/i){
             $timestamp=~/\d (\d\d):/;
             if(!exists($freq{$1})){
                 $freq{$1}=1;
             }else{
                 $freq{$1}=$freq{$1} + 1;
             }
            #print "found $1 $timestamp $result{$timestamp}\n";
        }
    }
    foreach my $hour (sort keys %freq){
        print "hour: $hour freq: $freq{$hour}\n";
    }
    undef(%result);
    template 'master', {callsign => params->{callsign}, data=>\%result};
};

get '/seek_apprentice/:callsign' => sub {   
    template 'apprentice', {callsign => params->{callsign}};
};

true;
