restore_relative_paths <- function(defs){
  
  if(nrow(defs$paths) > 0){
    for (i in 1:nrow(defs$paths)){
      defs[[defs$paths$field[i]]] <- defs$paths$rel[i]
    }
  }
  return(defs)
}