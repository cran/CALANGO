set_absolute_paths <- function(defs){
  
  # Potential fields that require normalisation:
  fields <- c("annotation.files.dir", 
              "output.dir",
              "dataset.info",
              "dict.path",
              "tree.path")
  
  if(defs$basedir == ""){
    defs$basedir <- "./"
  }
  
  defs$dirsep <- ifelse(.Platform$OS.type == "windows", "\\", "/")

  defs$basedir <- gsub("[/|\\]*$", "", normalizePath(defs$basedir))

  
  defs$paths <- data.frame(field = character(), 
                           rel   = character(),
                           abs   = character())
  
 
  
  for (i in seq_along(fields)){
    if(!is.null(defs[[fields[i]]]) && defs[[fields[i]]] != ""){
      rel <- gsub("[/|\\]*$", "", defs[[fields[i]]])
      if(.Platform$OS.type == "windows"){
        rel <- gsub("/", "\\", rel, fixed = TRUE)
      } else {
        rel <- gsub("\\", "/", rel, fixed = TRUE)
      }
      
      defs$paths <- rbind(defs$paths, 
                          data.frame(field = fields[i], 
                                     rel   = rel,
                                     abs   = paste0(defs$basedir, defs$dirsep, 
                                                    rel)))
      defs[[fields[i]]] <- defs$paths$abs[nrow(defs$paths)]
      
    }
  }
  return(defs)
}
