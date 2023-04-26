use strict;
use warnings;

if (!$ARGV[0]) {
  print_help();
} 

#interpro output file, tsv-delimited
my $infile = $ARGV[0];
chomp $infile;

#the bunch of code below is just to generate a suitable output file path
my @interpro_path = split(/\//, $infile);

my $file_name = pop @interpro_path;

my @tmp_name = split(/_/, $file_name);

my $final_name = join("_", $tmp_name[0], $tmp_name[1]);

open(IN, "<$infile") || die($!);

#will store gene-centered data
my %data;

while (my $line = <IN>) {
  chomp $line;   
  my @aux = split(/\t/, $line);
  my $gene_id = shift @aux;
  foreach my $element (@aux) {
    if ($element =~ /^GO:/) {
#      my $tmp = parse_GO($element);
      if (defined $data{$gene_id}) {
        $data{$gene_id} = join("|", $element, $data{$gene_id});
      } else {
        $data{$gene_id} = $element;
      }
    }
  }
}

close IN;

my $count = 0;

foreach my $key(keys %data) {
  my $unique = unique_values_count($data{$key});
  $count = $count + $unique;
#  my $a = <STDIN>;
}

print("$final_name\t$count\n");

sub unique_values_count {
  my $tmp = $_[0];
  my %tmp_data;
  my @aux = split(/\|/, $tmp);
  foreach my $element (@aux) {
    if (defined $tmp_data{$element}) {

    } else {
      $tmp_data{$element} = 1;
    }
  }
  my @uniquearray = keys %tmp_data;
  my $tmp_out = $#uniquearray + 1;
  return $tmp_out;
}

#close OUT;

sub print_help {
  die("Use this program like: perl count_GO_gene2GO.pl <path to interproscan tsv output file>\n");
}
