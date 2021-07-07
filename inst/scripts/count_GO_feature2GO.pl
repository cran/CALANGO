use strict;
use warnings;

if (!$ARGV[1]) {
  print_help();
} 

#interpro output file, tsv-delimited
my $infile = $ARGV[0];

my $feature_type = $ARGV[1];
chomp $feature_type;

#the bunch of code below is just to generate a suitable output file path
my @interpro_path = split(/\//, $infile);

my $file_name = pop @interpro_path;

my @tmp_name = split(/_/, $file_name);

my $final_name = join("_", $tmp_name[0], $tmp_name[1]);

open(IN, "<$infile") || die($!);


my $count = 0;

while (my $line = <IN>) {
  chomp $line;   
  my @aux = split(/\t/, $line);
  my $feature = $aux[3];
  if ($feature eq $feature_type) {
    my $GOs = get_GO($line);
    if (defined $GOs) {
      my @aux2 = split(/\|/, $GOs);
      $count = $count + ($#aux2+1);
    }
  }
}

print("$final_name\t$count\n");

sub print_help {
  die("Use this program like: perl count_GO_gene2GO.pl <path to interproscan tsv output file> <feature type (e.g. \"Pfam\")>\n");
}

sub get_GO {
  my $tmp = $_[0];
  chomp $tmp;
  my @aux = split(/\t/, $tmp);
  foreach my $element (@aux) {
    if ($element =~ /^GO:/) {
      return $element;
    }
  }
  return undef;
}

