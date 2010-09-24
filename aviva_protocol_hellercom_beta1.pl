# Copyright (c) 2010, Bjoern Heller <tec@hellercom.de>. All rights reserved
# This code is licensed under GNU/ GPL

#!/usr/bin/perl

use vars qw($OS_win);

#serielle settings fuer perl interpreter win/linux

BEGIN {
        $OS_win = ($^O eq "MSWin32") ? 1 : 0;

        print "Perl version: $]\n";
        print "OS   version: $^O\n";

            # muss BEGIN sein fuer "use" als normaler comm
        if ($OS_win) {
            print "Loading Windows modules\n";
            eval "use Win32::SerialPort";
	    die "$@\n" if ($@);

        }
        else {
            print "Loading Unix modules\n";
            eval "use Device::SerialPort";
	    die "$@\n" if ($@);
        }
}                               # End BEGIN

#comport als erstes command line argument
#die "\n\nnix port gewaehlt\n" wenn nicht ($ARGV[0]);
#my $port = $ARGV[0];
my $port = "/dev/ttyS1";

my $meterport; 

#mehr overhead kram
if ($OS_win) {
    $meterport = new Win32::SerialPort ($port,1);
}
else {
    $meterport = new Device::SerialPort ($port,1);
}
die "kann nicht den port oeffnen $port: $^E\n" unless ($meterport);

#Not necessary if you only want to sleep() for integer amounts of seconds.
use Time::HiRes qw ( sleep );

#mehr header kram
$meterport->user_msg(1);	# misc. warnings
$meterport->error_msg(1);	# hardware and data errors

#Set up the IR port.  9600 N,8,1  anpassbare SETTINGS
$meterport->devicetype('none');
$meterport->handshake('none');
$meterport->baudrate(9600);
$meterport->parity('none');
$meterport->databits(8);
$meterport->stopbits(1);
$meterport->write_settings;

#die "\n\nkein output angegeben\n" unless ($ARGV[0]);
#$fname = $ARGV[0];

#filecontent loeschen
#open LOGFILE, ">" . $fname or die "kann logfile nicht oeffnen ".$fname.": $!\n";
#close LOGFILE;

$two = chr(2);
$three = chr(3);
$four = chr(4);
$six = chr(6);

#Clear serial buffer - befehl aendert nichts, trasht aber alles was da kommt / schreiben von logwerten ins geraet
$out = pack(C,1);
$foo = $meterport->write($out);
sleep 0.1;
$bah = $meterport->input;
sleep 0.1;

$out = pack(C,hex(D));
$foo = $meterport->write($out);
sleep 0.1;

$out = pack(C,hex(B));
$foo = $meterport->write($out);
sleep 0.1;
$foo = $meterport->input;
$out = pack(C,hex(D));
$foo = $meterport->write($out);
sleep 0.2;
$bah = $meterport->input;
$bah =~ s/$six//g;
$bah =~ s/$four//g;
$bah =~ s/$two//g;
#print "0x0B\n" . $bah . "\n";


$out = "C";
$foo = $meterport->write($out);
sleep 0.1;
$out = "4";
$foo = $meterport->write($out);
sleep 0.1;
$foo = $meterport->input;
$out = pack("C",hex(D));
$foo = $meterport->write($out);
sleep 0.2;
$bah = $meterport->input;
$bah =~ s/$six//g;
$bah =~ s/$four//g;
$bah =~ s/$two//g;
#print "C4\n" . $bah . "\n";



$out = "C";
$foo = $meterport->write($out);
sleep 0.1;
$out = " ";
$foo = $meterport->write($out);
sleep 0.1;
$out = "3";
$foo = $meterport->write($out);
sleep 0.1;
$bah = $meterport->input;

$out = pack("C",hex(D));
$foo = $meterport->write($out);
sleep 0.5;
$bah = $meterport->input;
$bah =~ s/$six//g;
$bah =~ s/$four//g;
$bah =~ s/$two//g;
#print "C 3\n" . $bah . "\n";


$out = "S";
$foo = $meterport->write($out);
sleep 0.1;
$out = " ";
$foo = $meterport->write($out);
sleep 0.1;
$bah = $meterport->input;
$out = "1";
$foo = $meterport->write($out);
sleep 0.1;
$bah = $meterport->input;

$out = pack("C",hex(D));
$foo = $meterport->write($out);
sleep 0.2;
$bah = $meterport->input;
$bah =~ s/$six//g;
$bah =~ s/$four//g;
$bah =~ s/$two//g;
#print "S 1\n" . $bah . "\n";


$out = "S";
$foo = $meterport->write($out);
sleep 0.1;
$out = " ";
$foo = $meterport->write($out);
sleep 0.1;
$out = "2";
$foo = $meterport->write($out);
sleep 0.1;
$bah = $meterport->input;

$out = pack("C",hex(D));
$foo = $meterport->write($out);
sleep 0.2;
$bah = $meterport->input;
$bah =~ s/$six//g;
$bah =~ s/$four//g;
$bah =~ s/$two//g;
#print "S 2\n". $bah . "\n";

$out = "`";
$foo = $meterport->write($out);
sleep 0.1;
$bah = $meterport->input;

$out = pack("C",hex(D));
$foo = $meterport->write($out);
sleep 0.2;
$bah = $meterport->input;
$bah =~ s/$six//g;
$bah =~ s/$four//g;
$bah =~ s/$two//g;
$numreadings = substr($bah,3,3)*1;
#print "`\n" . $bah . "\n";


$out = "S";
$foo = $meterport->write($out);
sleep 0.1;
$out = " ";
$foo = $meterport->write($out);
sleep 0.1;
$out = "3";
$foo = $meterport->write($out);
sleep 0.1;
$bah = $meterport->input;

$out = pack("C",hex(D));
$foo = $meterport->write($out);
sleep 0.2;
$bah = $meterport->input;
$bah =~ s/$six//g;
$bah =~ s/$four//g;
$bah =~ s/$two//g;
#print "S 3\n". $bah . "\n";


$out = "a";
$foo = $meterport->write($out);
sleep 0.1;
$out = " ";
$foo = $meterport->write($out);
sleep 0.1;
$out = "1";
$foo = $meterport->write($out);
sleep 0.1;
$out = " ";
$foo = $meterport->write($out);
sleep 0.1;
for($i = 0; $i < length($numreadings); $i++)
  {
    $out = substr($numreadings,$i,1);
    $foo = $meterport->write($out);
    sleep 0.1;
  }
$bah = $meterport->input;


$out = pack("C",hex(D));
$foo = $meterport->write($out);
sleep 0.3;
$bah = $meterport->input;
$bah =~ s/$six//g;
$bah =~ s/$four//g;
$bah =~ s/$three//g;
$bah =~ s/$two//g;
#print "a 1 5\n". $bah . "\n";
$reading = substr($bah,3,3)*1;
$hour = substr($bah,6,2);
$minute = substr($bah,8,2);
$day = substr($bah,10,2);
$month = substr($bah,12,2);
$year = substr($bah,14,2);
print "$month/$day/20$year $hour:$minute - $reading\n"; #werte ausgabe (zeit /datum)
for ($i = 2; $i <= $numreadings; $i++)
  {
    $out = chr(6);
    $foo = $meterport->write($out);
    sleep 0.3;
    $bah = $meterport->input;
    $bah =~ s/$four//g;
    $bah =~ s/$three//g;
    $bah =~ s/$two//g;
    #print $bah . "\n";
    $reading = substr($bah,3,3)*1;
    $hour = substr($bah,6,2);
    $minute = substr($bah,8,2);
    $day = substr($bah,10,2);
    $month = substr($bah,12,2);
    $year = substr($bah,14,2);
    print "$month/$day/20$year $hour:$minute - $reading\n"; #werte schreiben (print dump)
  }


$out = pack("C",hex(0x1D)); #messgerŠt sagen, dass alles io und kill com mode
$foo = $meterport->write($out);
sleep 0.1;
$bah = $meterport->input;
print $bah . "\n";
