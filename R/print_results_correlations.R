print_results_correlations <- function(correlations, annotation,
                                      outputName, type) {
  # Generates a .tsv file with the results of the analysis.
  #
  # Args:
  #   correlations: (vector) value of the correlations between ontology's term
  #                          and variable.
  #   annotation: (list) translation of the ontology's terms.
  #   outputName: (char) name of the output file.
  #   type: (char) type of file being produced.
  # Returns:
  #   none.

  outputName  <- gsub("//", "/", outputName, fixed = TRUE)


  output <- annotation[names(correlations)]
  #  colnames(output)
  for (term in names(correlations)) {
    #    term <- names(correlations)[i]
    output[[term]] <- c(term, correlations[[term]], annotation[[term]])
  }


  df.output <- data.frame(matrix(unlist(output), nrow = length(output),
                                 byrow = T, dimnames = list(names(output))))

  type_col <- switch(EXPR = tolower(type),
                     "correlation" = "CC",
                     "sum" = "sum",
                     "cv" = "cv",
                     "q_value" = "q_val")

  if(is.null(type_col)) type_col <- "generic"

  output.columns <- c("ann_term", type_col, "annotation")

  utils::write.table(df.output, file = outputName, quote = FALSE,
                     row.names = FALSE, col.names = output.columns,
                     sep = "\t")

  return(NULL)

}
