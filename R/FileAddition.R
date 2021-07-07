# Obtains the annotation from a file about a specific genome.
#
# Input:
#   file: char, path to the file with the annotation.
#   column: char label or integer index of column with the desired annotation.
# Returns list with the annotation of that genome.
FileAddition <- function(file, column) {

  # ===== Sanity check =====
  assertthat::assert_that(is.character(file),
                          length(file) == 1,
                          file.exists(file),
                          is.character(column) || is.numeric(column),
                          length(column) == 1)


  anno <- utils::read.table(file,
                            sep = "\t", header = TRUE,
                            colClasses = "character",
                            strip.white = TRUE, comment.char = "",
                            row.names = 1, check.names = FALSE)

  # ===== Sanity check =====
  if (is.numeric(column)){
    assertthat::assert_that(column %% floor(column) == 0,
                            column >= 1, column <= ncol(anno))
  } else {
    assertthat::assert_that(column %in% names(anno))
  }

  # Parsing the tab format from Uniprot
  genomeMap <- strsplit(anno[, column], split = " *; *")
  names(genomeAnno) <- rownames(anno)

  return(genomeAnno)
}
