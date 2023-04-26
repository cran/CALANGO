check_bioc_dependencies <- function(...) {
  # Check if bioconductor dependencies are installed
  pkgs <- c("AnnotationDbi", "KEGGREST", "GO.db")
  x <- rownames(utils::installed.packages())
  idx  <- which(!pkgs %in% x)
  
  if (length(idx) > 0){
    msg <- paste0("\nCALANGO: ",
                  "Comparative AnaLysis with ANnotation-based Genomic cOmponentes")
    for (i in seq_along(idx)){
      msg <- paste0(msg, "\n* NOTE: Missing BioConductor dependency: ", pkgs[idx[i]])
    }
    msg <- paste0(msg, 
                  "\nPlease run install_bioc_dependencies() before using run_CALANGO()")
    message(msg)
    return(FALSE)
  } else {
    return(TRUE)
  }
}
