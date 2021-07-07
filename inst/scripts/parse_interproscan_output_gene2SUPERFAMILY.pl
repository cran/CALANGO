use strict;
use warnings;

if (!$ARGV[0]) {
  print_help();
} 

#interpro output file, tsv-delimited
my $infile = $ARGV[0];

#output directory
my $outdir_path = $ARGV[1];
chomp $outdir_path;

#the bunch of code below is just to generate a suitable output file path
my @interpro_path = split(/\//, $infile);

my $file_name = pop @interpro_path;

my @tmp_name = split(/_/, $file_name);

my $final_name = join("_", $tmp_name[0], $tmp_name[1]);

my $outfile_path = join("/", $outdir_path, $final_name);

$outfile_path = join(".", $outfile_path, "gene2GO", "txt");

print ("Generating file $outfile_path\n");

if (-e $outfile_path) {
  die "Outfile $outfile_path already exists.\n";
} else {
  open(OUT,">$outfile_path");
}

my $feature_name = "SUPERFAMILY";

open(IN, "<$infile") || die($!);

#my $header = <IN>;

#my @col_names = split(/\t/, $header);

print OUT ("Feature\t$feature_name\n");

#will store gene-centered data
my %data;

while (my $line = <IN>) {
  chomp $line;   
  my @aux = split(/\t/, $line);
  my $gene_id = shift @aux;
  my $feature_class = $aux[4];
  print ("$feature_class\n");
  my $a = <STDIN>;
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

foreach my $key(keys %data) {
  my $unique = unique_values($data{$key});
  print OUT ("$key\t$unique\n");
#  my $a = <STDIN>;
}

sub unique_values {
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
  my $tmp_out = join(";", @uniquearray);
  return $tmp_out;
}

#close OUT;

sub print_help {
  die("Use this program like: perl parse_interproscan_gene2GO.pl <path to interproscan tsv output file>\n");
}

