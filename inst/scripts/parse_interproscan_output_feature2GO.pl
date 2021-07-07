use strict;
use warnings;

if (!$ARGV[1]) {
  print_help();
} 

my @path = split(/\//, $ARGV[0]);

my $file_name = pop @path;

my @tmp_name = split(/_/, $file_name);

my $final_name = join("_", $tmp_name[0], $tmp_name[1]);

$final_name =~ s/\./_/g;

my $infile = $ARGV[0];

my $feature_name = $ARGV[1];
chomp $feature_name;

open(IN, "<$infile") || die($!);

#my $header = <IN>;

#my @col_names = split(/\t/, $header);

print("Feature\t$feature_name\n");

#my %data;

#my $total = 0;

my $i = 0;

while (my $line = <IN>) {
  chomp $line;   
  my @aux = split(/\t/, $line);
  my $actual_feature = $aux[3];
  if ((defined $actual_feature)&&($actual_feature eq $feature_name)) {
    my $GOs = get_GO($line);
    if (defined $GOs) { #new feature has GO terms; print them
      $GOs =~ s/\|/;/g;
      print "$feature_name\_$i\t$GOs\n";
      $i++;
    } else {
      next();
    }
  }
}


close IN;

sub print_help {
  die("Use this program like: perl parse_interproscan_feature2GO.pl <path to interproscan output file> <feature to extract (e.g. \"Pfam\")>\n");
}

sub get_GO {
  my $tmp = $_[0];
  my @aux = split(/\t/, $tmp);
  foreach my $element (@aux) {
    if ($element =~ /^GO:/) {
      return $element;
    }
  }
  return undef;
}

