#! /usr/bin/perl

# The purpose of igc2mysql is to extract faction information from an
# Allegiance IGC file, and place it into a mySQL database.
# It uses pICE to unpack the IGC files.
# This program was created on 
# By David Webb

# DBI is the database connector
use DBI;

# set the $DSN to the database type "mysql" the database name "fculint"
# and the host name "localhost"

my $dsn ='DBI:mysql:alleg:localhost';

# set the username
my $db_user_name = 'Your Database user name here';

# set the password to use
my $db_password = 'Your Database password here';


my $USAGE = "Usage: $0 my_core.igc";

use Alleg::Core;


my $igc = shift
    or die $USAGE;

open IGC, $igc
    or die "open($igc): $!";

binmode IGC;

my $core = Alleg::Core->new_from_fh(\*IGC);

close IGC
    or die "close($igc): $!";

%FactionParams = (	
			"uid" => "F_uid",
			"name" => "F_name", 
			"ukf1" => "F_payday_mod",
			"ukf2" => "F_start_money_mod", 
			"factor_01" => "F_ship_speed",
			"factor_02" => "F_ship_accel", 
			"factor_03" => "F_turn_rate", 
			"factor_04" => "F_turn_torque",
			"factor_05" => "F_station_hull",
			"factor_06" => "F_station_shield",
			"factor_07" => "F_station_shield_repair",
			"factor_08" => "F_ship_hull",
			"factor_09" => "F_ship_shield",
			"factor_10" => "F_ship_shield_repair",
			"factor_11" => "F_ship_sensors",
			"factor_12" => "F_ship_signature",
			"factor_13" => "F_ship_energy",
			"factor_14" => "F_pw_range",
			"factor_15" => "F_ew_range",
			"factor_16" => "F_missile_track",
			"factor_20" => "F_ripcord",
			"factor_21" => "F_pw_damage",
			"factor_22" => "F_missile_damage",
			"factor_23" => "F_cost",
			"factor_24" => "F_research_time",
			"factor_19" => "F_miners_capacity",
			"factor_17" => "F_he3_speed",
			"factor_18" => "F_he3_yield",
			"gar_uid"     => "F_garrison_id",
			"obj"	    => "F_obj_type",
			); 

@FactionOrder = qw ( uid name ukf1 ukf2 factor_01  factor_02  factor_03        factor_04  factor_05 factor_06 factor_07 factor_08 factor_09 factor_10 factor_11 factor_12 factor_13 factor_14 factor_15 factor_16 factor_20 factor_21 factor_22 factor_23 factor_24 factor_19 factor_17 factor_18 gar_uid obj ); 

sub printFactionDetails { 
    $sql_fields = "";
    $sql_values = "";
    my $faction = shift; 
    foreach my $line ( @FactionOrder ) {
	$sql_fields = $sql_fields.", ".$FactionParams{$line};
	$sql_values = $sql_values.", '".$faction->param($line). "'";
       # print $FactionParams{$line} . " = " .
#$faction->param($line) . "\n"; 
    } 
} 


# Print the faction details 
my @factions = @{$core->{"Faction"}}; 
# create an array called factions containing the contents of $core->Faction. 

for my $faction ( @factions ) { 
    printFactionDetails( $faction ); 
    $sql_string = "Insert into factions ( F_ID, CORE". $sql_fields . ") Values ( 'NULL', '$igc'" . $sql_values .")";    
        print $sql_string. "\n";

# create the connection string, and connect to the database

 my $dbh = DBI->connect($dsn, $db_user_name, $db_password);



 my $sql_command  = $dbh->prepare(qq{ $sql_string
 });
 
# Execute the statement

 $sql_command->execute();

# close the SQL session
 $sql_command->finish();

# close the SQL connection

 $dbh->disconnect();



}
# $faction is the control variable in the Perl Foreach loop. Step through
# each possible value of the array factions, calling print FactionDeatils
# for each value.









print $ARGV[0];
