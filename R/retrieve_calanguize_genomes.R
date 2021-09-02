#' Retrieve calanguize_genomes script from the Github repository
#'
#' This script downloads the *calanguize_genomes.pl* Perl script from the 
#' repository, together with associated README instructions for using the 
#' script, managing dependencies, etc. It will extract the data into a folder 
#' containing everything that is needed for preparing data for using 
#' CALANGO.
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
#'
#' @export
#'
#' @examples
#' \dontrun{
#'   CALANGO::retrieve_calanguize_genomes(target.dir = "./data")
#' }
#' 
#' @return No return value, called for side effects (see Description).

retrieve_calanguize_genomes <- function(target.dir,
                                method = "auto",
                                unzip  = getOption("unzip")){
  
  # ================== Sanity checks ==================
  assertthat::assert_that(is.character(target.dir),
                          length(url) == 1)
  
  if(!dir.exists(target.dir)){
    dir.create(target.dir, recursive = TRUE)
  } else {
    filelist <- dir(target.dir, full.names = TRUE)
    unlink(filelist, recursive = TRUE, force = TRUE)
  }
  
  url <- "https://github.com/fcampelo/CALANGO/raw/master/inst/extdata/calanguize_genomes.zip"
  
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
