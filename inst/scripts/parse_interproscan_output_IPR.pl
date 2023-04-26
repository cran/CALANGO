use strict;
use warnings;

if (!$ARGV[1]) {
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

my $final_name = join("_", $tmp_name[0], $tmp_name[1], "IPR_out.txt");

my $outfile_path = join("/", $outdir_path, $final_name);

#$outfile_path = join(".", $outfile_path, $feat_class, "txt");

print ("Generating file $outfile_path\n");

if (-e $outfile_path) {
  die "Outfile $outfile_path already exists.\n";
} else {
  open(OUT,">$outfile_path");
}

open(IN, "<$infile") || die($!);

#my $header = <IN>;

#my @col_names = split(/\t/, $header);

print OUT ("Feature\tIPR\n");

#my %data;

#my $total = 0;

my $i = 0;

while (my $line = <IN>) {
  chomp $line;   
  my @aux = split(/\t/, $line);
  if ((defined $aux[11])&&($aux[11] =~ /^IPR/)) {
    print OUT ("$i\t$aux[11]\n");
    $i++;
  }
}


close IN;
close OUT;

sub print_help {
  die("Use this program like: perl parse_interproscan_tabular.pl <path to interproscan tsv output file> <output_dir>\n");
}

