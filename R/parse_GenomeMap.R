# Function to parse the tab format from Uniprot
parse_GenomeMap <- function(genome, column, split = " *; *") {
  genomeMap <- strsplit(x = genome[, column], split = split)
  names(genomeMap) <- rownames(genome)
  return(genomeMap)
}
