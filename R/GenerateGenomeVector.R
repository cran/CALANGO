# Generates a phyletic vector for a specific genome.
# Input:
#   genomeAnno: list, annotation of the genome.
#   ontologyInfo: list, wrapper for the ontology. Since it may be GO, KO, or an
#                   arbitrary one, the information may come in different
#                   variables, hence the wrapper.
# Returns list with the frequency count of each term in that genome.
GenerateGenomeVector <- function(genomeAnno, ontologyInfo, column) {

  # ===== Sanity check =====
  assertthat::assert_that(is.list(genomeAnno) || is.character(genomeAnno),
                          is.list(ontologyInfo),
                          "name" %in% names(ontologyInfo))

  # Check input format (file or annotation list), adapt if possible
  if (is.character(genomeAnno)) {
    if (utils::file_test("-f", genomeAnno)) {
      genomeAnno <- FileAddition(genomeAnno, column)
    } else {
      # TODO: Should it throw an error in this case?
      return(NULL)
    }
  }
  if (!is.list(genomeAnno)) {
    # TODO: Should it throw an error in this case?
    return(NULL)
  }

  genomeVector <- rep.int(0, times = length(ontologyInfo$name))
  names(genomeVector) <- ontologyInfo$name

  if (is.element(ontologyInfo$ontology, c("go", "gene ontology"))) {
    genomeAnno <- lapply(genomeAnno, RemoveObsoleteAndAlternative,
                         ontologyInfo$allObsolete, ontologyInfo$allSynonym)
    genomeAnno <- lapply(genomeAnno, ObtainGeneGOancestors,
                         ontologyInfo$allAncestor)
  }

  # If the genome has any annotation, count terms; just return otherwise
  # 'countIDs' has the names of ontologic terms found in a genome and the
  # number of genes/proteins/elements in which they appeared
  # countIDs[, 1] = ontologic terms
  # countIDs[, 2] = occurrences of the term
  genomeAnno <- unlist(genomeAnno)
  if (length(genomeAnno) > 0) {
    countIDs <- as.data.frame(table(genomeAnno), stringsAsFactors = FALSE)
    countIDs <- countIDs[is.element(countIDs[, 1], ontologyInfo$name), ]

    genomeVector[countIDs[, 1]] <- genomeVector[countIDs[, 1]] +
      countIDs[, 2]
  }

  return(genomeVector)
}



