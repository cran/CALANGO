# Adds the field "Term" of each GO/KO ID to the results.
#
# Args:
#   defs: (list) a CALANGO-type list object (generated internally by the
#   CALANGO functions)
#   results: (list)  MHT-corrected p-values of all GO/KO IDs
#   ontology: (char) which ontology is used: GO, KO, other.
# Returns:
#   annotation: (list) translation of the ontology's terms.
AnnotateResults <- function(defs, results, ontology) {

  x <- switch(tolower(ontology),
              "go"            = as.list(AnnotationDbi::Term(GO.db::GOTERM[names(results)])),
              "gene ontology" = as.list(AnnotationDbi::Term(GO.db::GOTERM[names(results)])),
              "kegg"          = as.list(defs$allKOs[names(results)]),
              "other"         = defs$dictionary[names(results)])

  return(x)
}
