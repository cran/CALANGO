# Generates phyletic vectors of each genome in a group, which stores the
# count of appearences of a GO term in that genome.
#
# Generates phyletic vectors of each genome in a group, which stores the
# count of occurrences of a GO term in that genome.
#
# @param defs an enriched CALANGO-type list object containing at least the
#             fields named in parameters `anno` and `genome.names`, as well as
#             a field named `ontology` (containing the name of the ontology to
#             use). Depending on the ontology other fields may be needed.
# @param anno name of the field in `defs` containing a list with annotation
#             from the original input data
# @param genome.names name of the field in `defs` containing a char vector with
#             the names of the genomes to select.
# @param someGV data.frame containing a previously processed set of genome
#             vectors.
#
# @return list with the phyletic vector of each genome of the input group.
#

AddGenomeVectors <- function(defs, anno, genome.names,
                             someGV = NULL) {

  # ================== Sanity checks ==================
  assertthat::assert_that(all(c("list", "CALANGO") %in% class(defs)),
                          is.character(anno), length(anno) == 1,
                          is.character(genome.names), length(genome.names) == 1,
                          all(c(anno, genome.names, "ontology") %in% names(defs)),
                          is.null(someGV) || is.data.frame(someGV),
                          msg = "input error in CALANGO::AddGenomeVectors()")


  # To generate genome vectors, we need some information about the ontology.
  # Since it may be GO, KO or an arbitrary one, the information may come
  # from different variables, hence the following wrapper.
  ontologyInfo <- list(ontology = tolower(defs$ontology))
  if (ontologyInfo$ontology %in% c("go", "gene ontology")) {

    # TODO: add these to the function documentation
    assertthat::assert_that(all(c("allAncestor",
                                  "allObsolete",
                                  "allSynonym") %in% names(defs)))

    ontologyInfo$allAncestor <- defs$allAncestor
    ontologyInfo$allObsolete <- defs$allObsolete
    ontologyInfo$allSynonym  <- defs$allSynonym
    ontologyInfo$name        <- names(defs$allAncestor)

  } else if (ontologyInfo$ontology == "kegg") {
    assertthat::assert_that("allKOs" %in% names(defs))
    ontologyInfo$name <- names(defs$allKOs)

  } else if (ontologyInfo$ontology == "other") {
    assertthat::assert_that("dictionary" %in% names(defs))
    ontologyInfo$name <- names(defs$dictionary)

  } else{
    stop("'", ontologyInfo$ontology, "' is not a valid ontology type.")
  }

  # Select genomes from someAnno that are in genome.names and not in someGV,
  # so we don't add genome vectors that already exist.
  genome.names <- setdiff(defs[[genome.names]], rownames(someGV))
  someAnno     <- defs[[anno]][genome.names]



  # Add the genome vectors and fit them into a data.frame format.
  message("Generating Genome Vectors")
  if (.Platform$OS.type == "windows"){
    genomeVectors <- parallel::parLapply(cl           = defs$cl,
                                         X            = someAnno,
                                         fun          = GenerateGenomeVector,
                                         ontologyInfo = ontologyInfo,
                                         column       = defs$column)
  } else {
    genomeVectors <- pbmcapply::pbmclapply(X              = someAnno,
                                           FUN            = GenerateGenomeVector,
                                           ontologyInfo   = ontologyInfo,
                                           column         = defs$column,
                                           mc.preschedule = FALSE,
                                           mc.cores       = defs$cores)
  }

  genomeVectors <- as.data.frame(do.call(rbind, genomeVectors),
                                 optional = TRUE)

  # Merge with the existing genome vectors, if given.
  if (!is.null(someGV)) {
    genomeVectors <- rbind(someGV, genomeVectors)
  }

  return(genomeVectors)
}
