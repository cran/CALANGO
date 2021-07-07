#' Retrieve data files from the Github repository
#'
#' This script downloads relevant data files from the CALANGO project
#' repository. It will extract the data into a folder containing
#' directories related to dictionary files, Gene Ontology annotation
#' files, tree files, etc. Note: you may need to edit the file paths in the 
#' example scripts contained under the `parameters` subfolder of `target.dir`, 
#' or pass an appropriate base path using parameter `basedir` in [run_CALANGO()].
#'
#' If the `target.dir` provided does not exist it is created
#' (recursively) by the function.
#'
#' @param target.dir path to the folder where the files will be saved (
#' accepts relative and absolute paths)
#' @param method Method to be used for downloading files. Current download
#' methods are "internal", "wininet" (Windows only) "libcurl", "wget" and
#' "curl", and there is a value "auto": see _Details_ and _Note_ in the
#' documentation of \code{utils::download.file()}.
#' @param unzip The unzip method to be used. See the documentation of
#' \code{utils::unzip()} for details.
#' @param url example URL. **Do not change** unless you really know what
#' you're doing.
#'
#' @export
#'
#' @examples
#' \dontrun{
#'   CALANGO::retrieve_data_files(target.dir = "./data")
#' }
#' 
#' @return No return value, called for side effects (see Description).

retrieve_data_files <- function(target.dir,
                                method = "auto",
                                unzip  = getOption("unzip"),
                                url = "https://github.com/fcampelo/CALANGO/raw/master/inst/extdata/Examples.zip"){

  # ================== Sanity checks ==================
  assertthat::assert_that(is.character(target.dir),
                          length(url) == 1)

  if(!dir.exists(target.dir)){
    dir.create(target.dir, recursive = TRUE)
  } else {
    filelist <- dir(target.dir, full.names = TRUE)
    unlink(filelist, recursive = TRUE, force = TRUE)
  }
  
  res1 <- utils::download.file(url,
                               quiet    = TRUE,
                               destfile = paste0(target.dir, "/tmpdata.zip"),
                               cacheOK  = FALSE,
                               method   = method)
  if(res1 != 0) stop("Error downloading file \n", url)

  utils::unzip(paste0(target.dir, "/tmpdata.zip"),
               unzip = unzip,
               exdir = target.dir)
  unlink(paste0(target.dir, "/__MACOSX"), recursive = TRUE, force = TRUE)
  
  file.remove(paste0(target.dir, "/tmpdata.zip"))

  invisible(TRUE)
}
