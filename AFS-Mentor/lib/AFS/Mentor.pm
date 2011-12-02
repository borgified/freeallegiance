package AFS::Mentor;
use Dancer ':syntax';
use Dancer::Plugin::Database;

our $VERSION = '0.1';

get '/' => sub {  
    template 'index';
};

post '/' => sub {
    
    my $callsigns=params->{callsigns};
    $callsigns =~ s/[^A-Za-z0-9 \-\_\,]*//go;
    my $data=database->prepare('select timestamp,players from currentplayers where timestamp > date_sub(now(),interval 1 month)');
    $data->execute();
    my %db;
    while(my $a=$data->fetchrow_hashref){ 
        $db{$$a{timestamp}}=$$a{players};
    }
    
    my $output;
    my $i=0;

    my $x=0;
    my %results;
    my %freqq;

    foreach my $hour (0..23){
        if($hour=~/\b\d\b/){
            $hour="0".$hour;
        }
        $freqq{$hour}=$hour;
    }
   
    $results{$x++} = {
            callsign => "hour (UTC)",
            freq     => \%freqq,
        };
    
    foreach my $callsign (split/\s+\,|\,\s+|\,|\s+/,$callsigns){
        my %freq;
        
        #initialize %freq
            
        foreach my $hour (0..23){
            if($hour=~/\b\d\b/){
                $hour="0".$hour;
            }
            $freq{$hour}=0;
        }
     
        foreach my $timestamp (keys %db) {
            if($db{$timestamp} =~ /\b$callsign\b/i){
                $timestamp=~/\d (\d\d):/;
                $freq{$1}=$freq{$1} + 1;
            }
        }

        $results{$x++} = {
            callsign => $callsign,
            freq     => \%freq,
        };
    }
    template 'results', { results => \%results };
};

true;
