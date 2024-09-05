# Load and verify all required data for the CALANGO workflow
#
# This script represents the first step of the LCFD workflow of CALANGO.
# It separates the data loading, which can be the longest step of a workflow,
# from the analysis itself, which is faster and can be redone multiple times.
#
# The script expects a `CALANGO`-type list, which is a list object containing
# at least the following fields:
# \itemize{
#    \item \code{test.path} (char string): path to the folder containing
#    annotation files of the test group
#    \item \code{back.path} (char string): path to the folder containing
#    annotation files of the background group
#    \item \code{x.path} (char string): path to the file containing
#    the genomes' attributes (for correlation test)
#    \item \code{y.path} (char string): path to the folder containing
#    the the genomes and their annotations (for correlation test)
#    \item \code{ontology} (char string): which ontology to use. Currently
#    accepts "GO" or "Gene Ontology", "KEGG" and "other".
#    \item \code{dict.path} (char string): file with the dictionary (terms and
#    their meaning) of the ontology, if `ontology` is set as "other".
#    \item \code{type} (char string): comparison module to use. Accepts
#    "significance" (compares two groups of genomes within an ontology) or
#    "correlation" (establishes how much avariable explains the variations
#    seen in the genomes).
# }
#
# The input definitions can also be passed as a file path. If that is the
# case the file must be in a `field = value` format. Blank likes and lines
# starting with `#` are ignored. Required fields are the same described for the
# `CALANGO` list described above.
#
# @param defs either a CALANGO-type list object (see Details) or
# a path to a text file containing the required definitions.
# @param cores positive integer, how many CPU cores to use (multicore
# acceleration does not work in Windows systems). Notice that setting
# this parameter will override any `type` field from `defs`.
#
# @return updated \code{defs} list containing the information loaded
# from the files.
#

load_data <- function(defs, cores = NULL){

  # ================== Sanity checks ==================
  # assertthat::assert_that(assertthat::has_name(defs, "type"),
  #                         is.character(defs$type),
  #                         length(defs$type) == 1,
  #                         defs$type %in% c("correlation"),
  #                         msg = "Invalid defs$type")


  # ================== Load files and prepare list ==================
  defs <- switch(tolower(defs$type),
                 significance = load_data_significance(defs),
                 correlation  = load_data_correlation(defs))

  if(is.null(defs)) stop("'", defs$type, "'",
                         "is not a recognized type argument for CALANGO.")


  # Load ontology dictionary if ontology is "other"
  if (defs$ontology == "other") {
    assertthat::assert_that(file.exists(defs$dict.path),
                            msg = "defs$dict.path does not point to a file.")

    defs$dictionary <- utils::read.csv(defs$dict.path,
                                       sep          = "\t",
                                       quote        = "",
                                       colClasses   = "character",
                                       strip.white  = TRUE,
                                       comment.char = "#",
                                       stringsAsFactors = FALSE)

  }

  class(defs) <- c("CALANGO", "list")
  return(defs)
}
