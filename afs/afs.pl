#!/usr/bin/perl -wT

use strict;
use CGI;      # or any other CGI:: form handler/decoder
use CGI::Ajax;
use LWP::Simple;


my $cgi = new CGI;
my $pjx = new CGI::Ajax( 'exported_func' => \&perl_func );
print $pjx->build_html( $cgi, \&Show_HTML);

sub perl_func {

	my $input = shift;
	my $ok_chars = 'a-zA-Z0-9';
	$input =~ s/[^$ok_chars]//go; #sanitize input

	my $rank = get("http://asgs.alleg.net/asgs/services.asmx/GetPlayerRank?Callsign=$input");
	$rank =~ />(.*)</;
	$rank = $1;

	my $forumcheck = get("http://www.freeallegiance.org/forums/index.php?act=xmlout&do=check-display-name&name=$input");
	my $output;

	if($rank =~ /Newbie|Novice|Inter|Veteran|Expert/ && $forumcheck eq 'found'){
		$output="<a href='http://thegamersoffice.com/alleg/cadet/afsform.html'>enter here</a>";
	}elsif($rank !~ /Newbie|Novice|Inter|Veteran|Expert/ && $forumcheck eq 'found'){
		$output="<a class=info href='#'>callsign not found<span>You must have an active game account created in the Allegiance Security system (ASGS). Create an ASGS account if you haven't already and activate it</span></a>";
	}elsif($rank =~ /Newbie|Novice|Inter|Veteran|Expert/ && $forumcheck eq 'notfound'){
		$output="could not find matching <a class=info href='#'>forum display name<span>You must have an active forum account on the Free Allegiance.org forums. Create a forum account if you haven't already and activate it. (N.B. The Forum Display Name must match the in-game callsign, not just the login name)</span></a>";
	}else{
		$output="<a class=info href='#'>callsign not found<span>You must have an active game account created in the Allegiance Security system (ASGS). Create an ASGS account if you haven't already and activate it</span></a>  and could not find matching <a class=info href='#'>forum display name<span>You must have an active forum account on the Free Allegiance.org forums. Create a forum account if you haven't already and activate it. (N.B. The Forum Display Name must match the in-game callsign, not just the login name)</span></a>";
	}

	return( $output );
}

sub Show_HTML {
my $html = <<EOHTML;
<HTML>
<head>
<style>
a.info{
    position:relative; /*this is the key*/
    z-index:24; background-color:#ccc;
    color:#000;
    text-decoration:none}

a.info:hover{z-index:25; background-color:#ff0}

a.info span{display: none}

a.info:hover span{ /*the span will display just on :hover state*/
    display:block;
    position:absolute;
    top:2em; left:2em; width:15em;
    border:1px solid #0cf;
    background-color:#cff; color:#000;
    text-align: center}
</style>
</head>
<BODY>
Enter your ASGS Primary callsign
<input type="text" name="val1" id="val1" onkeyup="exported_func( ['val1'], ['resultdiv'] );"><div id="resultdiv"></div>
</BODY>
</HTML>
EOHTML
return $html;
}
