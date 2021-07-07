# Specific function to clean data if type == "significance" in the CALANGO
# definition list. (Not exported to to the namespace)

clean_data_significance <- function(defs){

  stop("Type 'significance' not yet available.")

  # # Set the names of defs$test and defs$back
  # defs$test.name   <- basename(defs$test.name)
  # defs$back.name   <- basename(defs$back.name)
  # names(defs$test) <- defs$test.name
  # names(defs$back) <- defs$back.name
  #
  # # Safety check, removes the counts if any value is missing
  # if (!is.null(defs$testElementCount)) {
  #   names(defs$testElementCount) <- defs$test.name
  #   if (any(is.na(defs$testElementCount))) {
  #     defs$testElementCount <- NULL
  #   }
  # }
  # if (!is.null(defs$backElementCount)) {
  #   names(defs$backElementCount) <- defs$back.name
  #   if (any(is.na(defs$backElementCount))) {
  #     defs$backElementCount <- NULL
  #   }
  # }
  #
  # # Parse Genome Maps
  # defs$test.anno <- pbmcapply::pbmclapply(X              = defs$test,
  #                                         FUN            = parse_GenomeMap,
  #                                         column         = defs$column,
  #                                         mc.preschedule = FALSE,
  #                                         mc.cores       = defs$cores)
  #
  # defs$back.anno <- pbmcapply::pbmclapply(X              = defs$back,
  #                                         FUN            = parse_GenomeMap,
  #                                         column         = defs$column,
  #                                         mc.preschedule = FALSE,
  #                                         mc.cores       = defs$cores)
  #
  # # Remove test and back fields from defs
  # defs$test <- NULL
  # defs$back <- NULL
  #
  # return(defs)
}
