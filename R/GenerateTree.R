# Function to generate and plot a taxonomic tree
GenerateTree <- function(taxonIds, db = "ncbi") {
  taxize_class <- taxize::classification(taxonIds, db = db)
  taxize_tree  <- taxize::class2tree(taxize_class, check = TRUE)
  # taxize::plot.classtree(taxize_tree)
  invisible(taxize_tree)
}
