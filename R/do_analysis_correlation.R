# Specific function to perform analysis if type == "correlation" in the CALANGO
# definition list. (Not exported to to the namespace)

do_analysis_correlation <- function(defs){

  # ================== Sanity checks ==================
  defs$ontology  <- tolower(defs$ontology)
  defs$tree.type <- tolower(defs$tree.type)

  assertthat::assert_that(defs$tree.type %in% c("nexus", "newick"),
                          msg = "tree.type must be either 'nexus' or 'newick'")

  assertthat::assert_that(defs$ontology %in% c("go", "gene ontology", "kegg", "other"),
                          msg = 'ontology must be "go", "gene ontology", "kegg" or "other"')



  # Read tree file
  defs$tree <- switch(defs$tree.type,
                      nexus  = ape::read.nexus(defs$tree.path),
                      newick = ape::read.tree(defs$tree.path))


  # Create fully dicotomic tree as required by pic() function
  defs$tree <- ape::multi2di(defs$tree, equiprob = FALSE)

  # Create data structure for dictionary
  if (defs$ontology %in% c("go", "gene ontology")) {
    defs$allAncestor <- ListAncestors()
    defs$allObsolete <- ListObsoletes()
    defs$allSynonym  <- ListSynonyms()

  } else if (defs$ontology == "kegg") {
    # TODO: KEGG is not working anymore, must check
    defs$allKOs <- ListKOs()

  } else if (defs$ontology == "other" & defs$dict.path == "") {
    defs$dictionary <- CreateDictionary(defs$y.anno)
  }

  # if (is.null(defs$yElementCount)) {
  #   # TODO: Check this: the output will *always* be zero under this condition.
  #   # See GroupElementCount() in utils_genome_vector.R
  #   defs$yElementCount <- GroupElementCount(defs$y.anno)
  # }

  defs$y <- AddGenomeVectors(defs,
                             anno         = "y.anno",
                             genome.names = "y.name")

  # Calculate the denominator for GO analysis
  if (defs$ontology %in% c("go", "gene ontology") &
      length(defs$denominator) < 2) {
    defs$denominator <- rowSums(defs$y)
  }

  # Compute basic statistics of annotation elements and sum
  defs$sum  <- sapply(defs$y, sum)
  defs$sd   <- sapply(defs$y, stats::sd)
  defs$mean <- sapply(defs$y, mean)
  defs$cv   <- mapply(FUN = function(x,y){ifelse(y == 0, 0, x/y)},
                      defs$sd, defs$mean,
                      SIMPLIFY = TRUE)


  # Compute coverage
  # (defined as: proportion of samples with annotation term count > 0)
  defs$greaterthanzero <- sapply(defs$y, function(v){sum(v > 0) / length(v)})

  # Compute sample mode and sample heterogenity
  # (defined as: proportion of samples distinct from the sample mode)
  message("Computing sample mode and sample heterogenity")
  if (.Platform$OS.type == "windows"){
    tmp <- parallel::parLapply(cl  = defs$cl,
                               X   = defs$y,
                               fun = function(v){
                                 tmp <- sort(table(v), decreasing = TRUE)
                                 return(list(m = as.numeric(names(tmp)[1]),
                                             h = sum(tmp[-1]) / length(v)))
                               })
  } else {
    tmp <- pbmcapply::pbmclapply(defs$y,
                                 function(v){
                                   tmp <- sort(table(v), decreasing = TRUE)
                                   return(list(m = as.numeric(names(tmp)[1]),
                                               h = sum(tmp[-1]) / length(v)))
                                 },
                                 mc.cores = defs$cores)
  }

  defs$heterogeneity <- sapply(tmp, function(x) x$h)
  defs$mode          <- sapply(tmp, function(x) x$m)


  # Compute contrasts
  defs$contrasts <- FindContrasts(x           = defs$x,
                                  y           = defs$y,
                                  tree        = defs$tree,
                                  method      = "pic",
                                  denominator = defs$denominator,
                                  cores       = defs$cores,
                                  cl          = defs$cl)

  defs$contrasts.corrected <- stats::p.adjust(p      = defs$contrasts,
                                              method = defs$MHT.method)

  # Compute correlations, correlation p-values and
  # MHT-corrected correlation p-values
  cortypes <- c("pearson", "spearman", "kendall")
  for (i in seq_along(cortypes)){
    tmp <- FindCorrelations(x           = defs$x,
                            y           = defs$y,
                            method      = cortypes[i],
                            denominator = defs$denominator,
                            cores       = defs$cores,
                            cl          = defs$cl)
    tmp$mhtpv <- stats::p.adjust(p      = tmp$cor.pvalues,
                                 method = defs$MHT.method)

    defs[[paste0("correlations.", cortypes[i])]] <- tmp$cor
    defs[[paste0("correlations.pvalue.", cortypes[i])]] <- tmp$cor.pvalue
    defs[[paste0("results.correlations.pvalue.", cortypes[i])]] <- tmp$mhtpv
  }

  # Annotate results
  fieldnames <- c("correlations.pearson", "contrasts", "sum", "cv", "sd")
  outnames   <- paste0("annotation.", c("cor", "contrasts", "sum", "cv", "sd"))

  for (i in seq_along(fieldnames)){
    defs[[outnames[i]]] <- AnnotateResults(defs     = defs,
                                           results  = defs[[fieldnames[i]]],
                                           ontology = defs$ontology)
  }

  return(defs)

}
