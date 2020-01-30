#! /usr/bin/perl

#@array_files = ('xlor1.bin','ylor1.bin','zlor1.bin');
$DIR_CURRENT=`pwd`; chomp($DIR_CURRENT);
$nodata=-999;
($file,$tstep)=@ARGV;

$ctl = $file;
$ctl =~ s/\.bin/\.ctl/g;
&crea_ctl('2000','Jan','01',$ctl,$file,$tstep);

sub crea_ctl {
	my $yini = shift();
	my $mini = shift();
	my $dini = shift();
	my $fctl = shift();
	my $fbin = shift(); chomp($fbin);
	$fbin =~ s/$DIR_CURRENT//g;
	my $tdef = shift();
	
	
	open(FCTL,">$fctl") || die "opss FCTL $fctl\n";
  	print FCTL "DSET ^$fbin"."\n";
	print FCTL "UNDEF $nodata"."\n";
#	print FCTL "OPTIONS 365_day_calendar"."\n";
	print FCTL "TITLE Useless title"."\n";
	print FCTL "XDEF 1 linear    0 1"."\n";
	print FCTL "YDEF 1 linear    0 1"."\n";
	print FCTL "ZDEF 1 levels 500hpa"."\n";
	print FCTL "TDEF "."$tdef"." LINEAR $dini$mini$yini 1dy"."\n";
	print FCTL "VARS 1"."\n";
	print FCTL "data\t0 99 ch01 Daily Data"."\n";
	print FCTL "ENDVARS"."\n";
	close(FCTL);
}

