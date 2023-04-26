# Specific function to clean data if type == "correlation" in the CALANGO
# definition list. (Not exported to to the namespace)

clean_data_correlation <- function(defs){

  # Set names of x and y within defs
  defs$y.name   <- basename(defs$y.name)
  names(defs$y) <- defs$y.name
  names(defs$x) <- defs$y.name

  if (length(defs$denominator) <= 1) {
    defs$denominator <- NULL
  } else {
    names(defs$denominator) <- defs$y.name
  }

  # Safety check, returns error if any value is missing
  if (is.null(defs$x) || any(is.na(defs$x))) {
    stop("Missing values in the (x variable), check your dataset info file.")
  }

  defs$x <- as.data.frame(defs$x)

  # Parse Genome Maps
  if (.Platform$OS.type == "windows"){
    defs$y.anno <- parallel::parLapply(cl     = defs$cl,
                                       X      = defs$y,
                                       fun    = parse_GenomeMap,
                                       column = defs$column)
  } else {
    defs$y.anno <- pbmcapply::pbmclapply(X              = defs$y,
                                         FUN            = parse_GenomeMap,
                                         column         = defs$column,
                                         mc.preschedule = FALSE,
                                         mc.cores       = defs$cores)
  }

  # Remove y field from defs
  defs$y <- NULL

  return(defs)
}
