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
   
    }
    print "</table>";
   
};

true;
