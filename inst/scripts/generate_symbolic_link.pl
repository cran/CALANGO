use strict;
use warnings;

if (!$ARGV[0]) {
  print_help();
}



sub print_help {
  die("Use this program like: perl create_symbolic_link.pl <path containing the files you want to create symbolic links> <radical to select which files to analyse>
}
