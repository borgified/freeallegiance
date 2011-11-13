package AFS::Mentor;
use Dancer ':syntax';
use Dancer::Plugin::Database;
use Data::Dumper;

our $VERSION = '0.1';

get '/' => sub {  
    template 'index';
};

post '/' => sub {
    my $choice=params->{choice};
    
    if($choice eq 'master'){
        redirect '/seek_master/'.params->{callsign};
    }else{
        redirect '/seek_apprentice/'.params->{callsign};
    }
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
