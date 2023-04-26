# Specific function to load data if type == "correlation" in the CALANGO
# definition list. (Not exported to to the namespace)

load_data_correlation <- function(defs){

  # ================== Sanity checks ==================
  # TODO: write check function
  # defs <- check_inputs_correlation(defs)


  # ================== Process test.path  ==================

  defs$y.name <- utils::read.csv(defs$dataset.info,
                                 header       = FALSE,
                                 strip.white  = TRUE,
                                 comment.char = "",
                                 check.names  = FALSE,
                                 sep          = "\t",
                                 stringsAsFactors = FALSE)

  defs$x <- defs$y.name[, defs$x.column]

  if (defs$denominator.column == "") {
    defs$denominator <- ""
  } else {
    defs$denominator <- defs$y.name[, defs$denominator.column]
  }

  if (defs$short.name.column == "") {
    defs$short.name <- ""
  } else {
    defs$short.name <- defs$y.name[, defs$short.name.column]
  }

  if (defs$group.column == "") {
    defs$groups <- ""
  } else {
    defs$groups <- defs$y.name[, defs$group.column]
  }

  #q-value cutoffs for Pearson, Spearman, Kendall and phylogeny-aware linear models

  if (defs$spearman.qvalue.cutoff == "") {
    defs$spearman.qvalue.cutoff <- 1
  } 

  if (defs$pearson.qvalue.cutoff == "") {
    defs$pearson.qvalue.cutoff <- 1
  } 

  if (defs$kendall.qvalue.cutoff == "") {
    defs$kendall.qvalue.cutoff <- 1
  } 

  if (defs$linear_model.qvalue.cutoff == "") {
    defs$linear_model.qvalue.cutoff <- 1
  } 


  #correlation cutoffs, used to select only highly correlated annotation terms

  if (defs$spearman.cor.upper.cutoff == "") {
    defs$spearman.cor.upper.cutoff <- -1
  } 

  if (defs$spearman.cor.lower.cutoff == "") {
    defs$spearman.cor.lower.cutoff <- 1
  } 

  if (defs$pearson.cor.upper.cutoff == "") {
    defs$pearson.cor.upper.cutoff <- -1
  }

  if (defs$pearson.cor.lower.cutoff == "") {
    defs$pearson.cor.lower.cutoff <- 1
  }

  if (defs$kendall.cor.upper.cutoff == "") {
    defs$kendall.cor.upper.cutoff <- -1
  }

  if (defs$kendall.cor.lower.cutoff == "") {
    defs$kendall.cor.lower.cutoff <- 1
  }


  # standard deviation and correlation coefficient filters, used to remove low-variability terms. Only terms with values greater than cutoff are analyzed

  if (defs$sd.cutoff == "") {
    defs$sd.cutoff <- 0
  } 

  if (defs$cv.cutoff == "") {
    defs$cv.cutoff <- 0
  } 

  #sum of annotation terms, used to remove low-count terms if needed. Only terms with counts greater than cutoff are further evaluated.
  if (defs$annotation_size.cutoff == "") {
    defs$annotation_size.cutoff <- 0
  } 

  if (defs$prevalence.cutoff == "") {
    defs$prevalence.cutoff <- 0
  }

  if (defs$heterogeneity.cutoff == "") {
    defs$heterogeneity.cutoff <- 0
  } 


  #to remove terms where standard deviation of counts equals zero
  if (defs$raw_data_sd_filter %in% c("", "TRUE")) {
    defs$raw_data_sd_filter <- TRUE
  } else {
    defs$raw_data_sd_filter <- FALSE
  }

  defs$y.name <- paste0(defs$annotation.files.dir, "/", defs$y.name[, 1])
  defs$y.name <- gsub(pattern = "//", replacement = "/", x = defs$y.name,
                      fixed = TRUE)

  message("Loading data:")
  if (.Platform$OS.type == "windows"){
    cat("...")
    defs$y <- parallel::parLapply(cl             = defs$cl,
                                  X              = defs$y.name,
                                  fun            = utils::read.csv,
                                  sep            = "\t",
                                  header         = TRUE,
                                  colClasses     = "character",
                                  strip.white    = TRUE,
                                  comment.char   = "",
                                  check.names    = FALSE)
    cat(" done!\n")
  } else {
    defs$y <- pbmcapply::pbmclapply(X              = defs$y.name,
                                    FUN            = utils::read.csv,
                                    sep            = "\t",
                                    header         = TRUE,
                                    colClasses     = "character",
                                    strip.white    = TRUE,
                                    comment.char   = "",
                                    check.names    = FALSE,
                                    mc.preschedule = FALSE,
                                    mc.cores       = defs$cores)
  }

  return(defs)
}
