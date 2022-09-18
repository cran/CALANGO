#' Run the CALANGO pipeline
#'
#' This function runs the complete workflow of CALANGO and generates the
#' HTML5 output pages and export files.
#'
#' The script expects a `CALANGO`-type list, passed either as an actual list
#' object or as a file path. In the latter case, notice that
#' the file must be a text file with a `field = value` format.
#' Blank likes and lines starting with `#` are ignored. The function expects the
#'  input list to have the following fields:
#' \itemize{
#'    \item\code{annotation.files.dir} (required, string) - Folder where
#'    annotation files are located.
#'    \item\code{output.dir} (required, string) - output folder for results
#'    \item\code{dataset.info} (required, string) - genome metadata file, it
#'    should contain at least:
#'    \itemize{
#'      \item File names. Please notice this information should be the first
#'      column in metadata file;
#'      \item Phenotype data (numeric, this is the value CALANGO uses to rank
#'      species when searching for associations)
#'      \item Normalization data (numeric, this is the value CALANGO uses as a
#'      denominator to compute annotation term frequencies to remove potential
#'      biases caused by, for instance, over annotation of model organisms or
#'      large differences in the counts of genomic elements). Please notice that
#'      CALANGO does not require normalization data for GO, as it computes the
#'      total number of GO terms per species and uses it as a normalizing factor.
#'    }
#'    \item\code{x.column} (required, numeric) - which column in "dataset.info"
#'    contains the phenotype data?
#'    \item\code{ontology} (required, string)  - which dictionary data type to
#'    use? Possible values are "GO" and "other". For GO, CALANGO can compute
#'    normalization data.
#'    \item\code{dict.path} (required, string)  - file for dictionary file
#'    (two-column file containing annotation IDs and their descriptions. Not
#'    needed for GO.
#'    \item\code{column} (required, string)  - which column in annotation files
#'    should be used (column name)
#'    \item\code{denominator.column} (optional, numeric) - which column contains
#'    normalization data (column number)
#'    \item\code{tree.path} (required, string)  - path for tree file in either
#'    newick or nexus format
#'    \item\code{tree.type} (required, string) - tree file type (either "nexus"
#'    or "newick")
#'    \item\code{cores} (optional, numeric) - how many cores to use? If not
#'    provided the function defaults to 1.
#'    \item\code{linear.model.cutoff} (required, numeric) - parameter that
#'    regulates how much graphical output is produced. We configure it to
#'    generate plots only for annotation terms with corrected q-values for
#'    phylogenetically independent contrasts (standard: smaller than 0.5).
#'    \item\code{MHT.method} (optional, string) - type of multiple hypothesis
#'    correction to be used. Accepts all methods listed by
#'    `stats::p.adjust.methods()`. If not provided the function defaults to
#'    "BH".
#' }
#' 
#'
#' @param defs either a CALANGO-type list object or
#' a path to a text file containing the required definitions (see Details).
#' @param type type of analysis to perform. Currently only "correlation" is
#' supported.
#' @param cores positive integer, how many CPU cores to use (multicore
#' acceleration does not work in Windows systems). Setting
#' this parameter overrides any `cores` field from `defs`. Multicore support is
#' currently implemented using the `parallel` package, which uses forking
#' (which means that multicore support is not available under Windows)
#' @param render.report logical: should a HTML5 report be generated?
#' @param basedir path to base folder to which all relative paths in `defs` 
#'                refer to.
#'
#' @importFrom assertthat assert_that is.count has_name
#' @importFrom ggplot2 "%+%"
#'
#' @return Updated `defs` list, containing:
#' \itemize{
#'    \item All input parameters originally passed or read from a `defs` file 
#'    (see **Details**).
#'    \item Derived fields loaded and preprocessed from the files indicated in 
#'    `defs`.
#'    \item Several statistical summaries of the data (used to render the 
#'    report), including correlations, contrasts, covariances, p-values and 
#'    other summary statistics.
#' }
#' 
#' Results are also saved to files under `defs$output.dir`.
#'
#' @export
#'
#' @examples
#' \dontrun{
#'
#' ## Install any missing BioConductor packages for report generation 
#' ## (only needs to be done once)
#' # CALANGO::install_bioc_dependencies()
#'
#' # Retrieve example files
#' basedir <- tempdir()
#' retrieve_data_files(target.dir = paste0(basedir, "/data"))
#' defs <- paste0(basedir, "/data/parameters/parameters_domain2GO_count_less_phages.txt")
#'
#' # Run CALANGO
#' res <- run_CALANGO(defs, cores = 2)
#' }
#' 

run_CALANGO <- function(defs, type = "correlation",
                        cores = NULL, render.report = TRUE, 
                        basedir = ""){
  
  # ================== Sanity checks ==================
  isOK <- check_bioc_dependencies()
  if (!isOK) {
    warning("run_CALANGO() stopped prematurely.")
    return(NULL)
  }
  
  assert_that(is.list(defs) || file.exists(defs),
              is.null(cores) || is.count(cores),
              is.null(type) || is.character(type),
              is.null(type) || length(type) == 1,
              is.logical(render.report), length(render.report) == 1,
              msg = "input error(s) in CALANGO::run_CALANGO()")

  # If defs is a file path, read it into list
  if(!is.list(defs)) {
    defs <- read_calango_file(defs)
  }
  
  defs$basedir <- basedir
  defs <- set_absolute_paths(defs)

  if(is.null(defs$type)) defs$type <- type

  # ================== Set up parallel processing ==================
  if(!is.null(cores)) {
    defs$cores <- cores
  } else if(!has_name(defs, "cores")) {
    defs$cores <- 1
  }

  available.cores <- parallel::detectCores()
  if (defs$cores >= available.cores){
    defs$cores <- max(1, available.cores - 1)
    warning("Input argument 'cores' too large, we only have ", available.cores,
            " cores.\nUsing ", defs$cores,
            " cores for run_CALANGO().")
    
  }
  if (.Platform$OS.type == "windows"){
    defs$cl <- parallel::makeCluster(defs$cores, setup_strategy = "sequential")
  }

  defs <- load_data(defs)      # Load required data
  defs <- clean_data(defs)     # Preliminary data cleaning
  defs <- do_analysis(defs)    # perform the analysis
  defs <- save_tsv_files(defs) # Save results to .tsv files
  defs <- make_report(defs, render.report = render.report) # generate HTML page

  if (.Platform$OS.type == "windows"){
    ## Stop the cluster
    parallel::stopCluster(defs$cl)
  }

  if(is.null(defs$output.dir)) saveRDS(defs,
                                       file = paste0(defs$output.dir,
                                                     "/results.rds"))
  
  defs <- restore_relative_paths(defs)

  invisible(defs)
}
