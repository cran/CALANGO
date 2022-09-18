# Count number of genes in each genome of a group.
#
# Input:
#   someAnno: list of genomes, each with a data frame that maps
#               each gene to its annotations (GO, KO).
#   genome.names: char vector of names of the genomes to count elements.
#                   May be used to restrict which genomes to count in this
#                   function.
#   mode: char, defines whether CALANGO must consider all elements in all
#           genomes (default), or treat each element independently of
#           others (experiment). The latter is an experiment for
#           alignments.
# Returns an integer vector with the number of elements in each genome
#   of someAnno.
GroupElementCount <- function(someAnno, genome.names = NULL, mode = "default") {

  if (is.null(genome.names) | length(genome.names) == 0) {
    # TODO: should this return zero or throw an error?
    return(0)
  }

  if (mode == "default") {
    elementCount <- sapply(X   = someAnno[genome.names],
                           FUN = length)

  } else if (mode == "experiment") {
    elementCount        <- rep(1, length(someAnno[genome.names]))
    names(elementCount) <- names(someAnno[genome.names])

  } else {
    stop("'", mode, "' is not a recognized mode in CALANGO::GroupElementCount()")
  }

  return(elementCount)
}
