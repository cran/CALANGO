set_absolute_paths <- function(defs){
  
  # Potential fields that require normalisation:
  fields <- c("annotation.files.dir", 
              "output.dir",
              "dataset.info",
              "dict.path",
              "tree.path")
  
  if(defs$basedir == c("")){
    defs$basedir <- "./"
  }
  
  defs$basedir <- normalizePath(defs$basedir)
  
  defs$paths <- data.frame(field = character(), 
                           rel   = character(),
                           abs   = character())
  
  for (i in seq_along(fields)){
    if(!is.null(defs[[fields[i]]]) && defs[[fields[i]]] != ""){
      defs$paths <- rbind(defs$paths, 
                          data.frame(field = fields[i], 
                                     rel   = defs[[fields[i]]],
                                     abs   = paste0(defs$basedir, "/", 
                                                    defs[[fields[i]]])))
      defs[[fields[i]]] <- paste0(defs$basedir, "/", defs[[fields[i]]])
    }
  }
  return(defs)
}