use strict;
use warnings;

my $infile = $ARGV[0];

print ("$infile\t");

chomp $infile;

open(IN, $infile) ||
  die();

while (my $line = <IN>) {
  chomp $line;
  if ($line =~ /Complete BUSCOs/) {
    my @aux = split(/\t/, $line);
    print ("$aux[1]\t");
  } elsif ($line =~ /Complete and single-copy BUSCOs/) {
    my @aux = split(/\t/, $line);
    print ("$aux[1]\t");
  } elsif ($line =~ /Complete and duplicated BUSCOs/) {
    my @aux = split(/\t/, $line);
    print ("$aux[1]\t");

  } elsif ($line =~ /Fragmented BUSCOs/) {
    my @aux = split(/\t/, $line);
    print ("$aux[1]\t");
  } elsif ($line =~ /Missing BUSCOs/) {
    my @aux = split(/\t/, $line);
    print ("$aux[1]\t");
  } elsif ($line =~ /Total BUSCO groups searched/) {
    my @aux = split(/\t/, $line);
    print ("$aux[1]\n");
  } else {
  }
}

close IN;
