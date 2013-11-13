#!/usr/bin/perl 
#Parse Imaris tracking data
#Kevin Distor
#University of California - Davis

use strict;
use warnings;

#usage perl imaris_parser.pl <input file> <output file> unless @ARGV == 2;

my $infile = $ARGV[0];
my $outfile = $ARGV[1];

open (INFILE, "<$infile") or die 'File cannot be opened\n\n';
open (OUTFILE, ">$outfile") or die 'File cannot be opened\n\n';
open (TEST, ">test.txt") or die 'File cannot be opened\n\n';

while (<INFILE>) {
	chomp;
	next if ($_ =~ m/^\D/);
	my @linedata = split(/\,/);
	my $yintensity = $linedata[4];
	my $parent = $linedata[10];
	my $time = $linedata[8];
	if ($time == 1) {
		print TEST "\n$yintensity";
	} else {
		print TEST "\t$yintensity";
	}
}

close (TEST);

open (TEST, "<test.txt") or die 'File cannot be opened\n\n';

my(%data);
my($maxcol) = 0;
my($rownum) = 0;

while (<TEST>) {
	next if ($_ =~ m/\t\n/);
	my(@row) = split /\s+/;
	my($colnum) = 0;
	foreach my $val (@row)
	{
		$data{$rownum}{$colnum++} = $val;
	}
	$rownum++;
	$maxcol = $colnum if $colnum > $maxcol;
}

my $maxrow = $rownum;
for (my $col = 0; $col < $maxcol; $col++) {
	for (my $row = 0; $row < $maxrow; $row++) {
	print OUTFILE ($row == 0) ? "" : "\t",
	defined $data{$row}{$col} ? $data{$row}{$col} : "0";
	}
	print OUTFILE "\n";
}
