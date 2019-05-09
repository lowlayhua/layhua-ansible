#!/usr/bin/perl 

#############################################################################
### Description   : Check URL using wget
#############################################################################
### You may change this if you want to
$workdir="/u0/staff/layhua";
$email_list="layhua\@singtel.com";

my $curdate = `date +%d%m%Y`;
chop ($curdate);
my $statusfile;
my @URLs;
my $response;
my $msg;
my $url;
my $counter;

### Parsing user input
if ( ($ARGV[0] eq "") )
{
 print "Syntax: $0 The file name that contains the list of URLs to monitor is missing.\n";
 exit;
}


open(IN,$ARGV[0]) || die "No such file exist.";
@URLs = <IN>;

foreach (@URLs) {
	$msg="message-".$curdate;
	$counter=0;
#	system("wget -t 1 --timeout=65 -S --spider -o $workdir/$msg $_");
	system("wget -t 1 --timeout=65 -S --spider --no-check-certificate -o $workdir/$msg $_");
	$url=$_;
	open (RESP,"$workdir/$msg") || die "Cannot open $workdir/$msg file.";
	while (<RESP>){
		chomp ($_);
		if ($_ eq "200 OK") {
		$counter =1;

		}
	}
	close RESP;
	if ($counter!=1){

## send sms alerts to system people

#	qx/mail -s "Alert: $url" layhua\@singtel.com < $workdir\/$msg /;
	qx/mail -s "Alert: $url" $email_list < $workdir\/$msg /;
#        qx/mail -s "96375733" issm\@issm1. < $workdir\/$msg /; 
#        qx/mail -s "98349137" issm\@issm1. < $workdir\/$msg /; 
	qx/cat $workdir\/$msg >> $workdir\/error-$curdate/;	

	}
	unlink ("$workdir/$msg");
}


close IN;

exit;
