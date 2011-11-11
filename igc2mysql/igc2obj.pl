#!/usr/bin/perl -w
# $Id: igc2perl.pl,v 1.1 2002/11/18 22:57:03 Administrator Exp $
# $Name: RELEASE_1_1 $

my $USAGE = "Usage: $0 my_core.igc";

use Alleg::Core;

#use diagnostics;
my $igc = shift
    or die $USAGE;

open IGC, $igc
    or die "open($igc): $!";

binmode IGC;

my $core = Alleg::Core->new_from_fh(\*IGC);

close IGC
    or die "close($igc): $!";

# print "Version is: ", $core->version, "\n" ;
# print "Size is: ", $core->size, "\n" ;
# print "Free deffs: ", $core->get_free_def, "\n";

# print "Tech tree: ", $core->get_free_uid, "\n";


%FactionParams = (	
			"uid" => "UID",
			"name" => "Name", 
			"ukf1" => "Payday Modifier",
			"ukf2" => "Starting Money Modifier", 
			"factor_01" => "Ship speed",
			"factor_02" => "Ship accel", 
			"factor_03" => "Turn rate", 
			"factor_04" => "Turn Torque",
			"factor_05" => "Station Hull",
			"factor_06" => "StationShield",
			"factor_07" => "StationShield repair",
			"factor_08" => "ShipHull",
			"factor_09" => "ShipShield",
			"factor_10" => "ShipShield repair",
			"factor_11" => "ShipSensors",
			"factor_12" => "ShipSignature",
			"factor_13" => "ShipEnergy",
			"factor_14" => "PWRange",
			"factor_15" => "EWRange",
			"factor_16" => "MissileTrack",
			"factor_20" => "Ripcord",
			"factor_21" => "PWDamage",
			"factor_22" => "MissileDamage",
			"factor_23" => "Cost",
			"factor_24" => "ResearchTime",
			"factor_19" => "Miners capacity",
			"factor_17" => "He3 Speed",
			"factor_18" => "He3 Yield",
			"gar_uid"     => "Garrison ID",

			); 

@FactionOrder = qw ( uid name  ukf1   ukf2 factor_01  factor_02  factor_03        factor_04  factor_05 factor_06 factor_07 factor_08 factor_09 factor_10 factor_11 factor_12 factor_13 factor_14 factor_15 factor_16 factor_20 factor_21 factor_22 factor_23 factor_24 factor_19 factor_17 factor_18 gar_uid); 



sub printFactionDetails { 
    my $faction = shift; 
    foreach my $line ( @FactionOrder ) { 
        print $FactionParams{$line} . " = " .
$faction->param($line) . "\n"; 
    } 
} 


# Print the faction details 
my @factions = @{$core->{"Faction"}}; 
# create an array called factions containing the contents of $core->Faction. 


for my $faction ( @factions ) { 
    printFactionDetails( $faction ); 
}
# $faction is the control variable in the Perl Foreach loop. Step through
# each possible value of the array factions, calling print FactionDeatils
# for each value.






