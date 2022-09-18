# Specific function to load data if type == "significance" in the CALANGO
# definition list. (Not exported to to the namespace)

load_data_significance <- function(defs){

  stop("Type 'significance' not yet available.")

  # ================== Sanity checks ==================
  # defs <- check_inputs_significance(defs)


  # ================== Process test.path  ==================
#
#   # If path points to a file containing the paths to the genome files
#   if (utils::file_test("-f", defs$test.path)) {
#     defs$test.name <- utils::read.table(file         = defs$test.path,
#                                         sep          = "\t",
#                                         strip.white  = TRUE,
#                                         comment.char = "",
#                                         check.names  = FALSE,
#                                         header       = FALSE,
#                                         stringsAsFactors = FALSE)
#
#     # May have the total number of elements in that genome in the second
#     # column, in case the files themselves have missing elements
#     if (ncol(defs$test.name) == 2) {
#       defs$testElementCount <- defs$test.name[, 2]
#     }
#     defs$test.name <- defs$test.name[, 1]
#
#
#     # If path points to a folder containing the genome files themselves
#   } else if (utils::file_test("-d", defs$test.path)){
#     defs$test.name <- list.files(path       = defs$test.path,
#                                  all.files  = FALSE,
#                                  full.names = TRUE,
#                                  recursive  = FALSE)
#
#   } else stop("test.path is neither a valid file nor a valid folder")
#
#   # ================== Process back.path  ==================
#
#   # If path points to a file containing the paths to the genome files
#   if (utils::file_test("-f", defs$back.path)) {
#     defs$back.name <- utils::read.table(file         = defs$back.path,
#                                         sep          = "\t",
#                                         strip.white  = TRUE,
#                                         comment.char = "",
#                                         check.names  = FALSE,
#                                         header       = FALSE,
#                                         stringsAsFactors = FALSE)
#
#     # May have the total number of elements in that genome in the second
#     # column, in case the files themselves have missing elements
#     if (ncol(defs$back.name) == 2) {
#       defs$backElementCount <- defs$back.name[, 2]
#     }
#     defs$back.name <- defs$back.name[, 1]
#
#
#     # If path points to a folder containing the genome files themselves
#   } else if (utils::file_test("-d", defs$back.path)) {
#     defs$back.name <- list.files(path       = defs$back.path,
#                                  all.files  = FALSE,
#                                  full.names = TRUE,
#                                  recursive  = FALSE)
#
#   } else stop("back.path is neither a valid file nor a valid folder")
#
#
#   # Read genome files
#   cat("\nLoading data:\n")
#   defs$test <- pbmcapply::pbmclapply(X              = defs$test.name,
#                                      FUN            = utils::read.table,
#                                      sep            = "\t",
#                                      header         = TRUE,
#                                      colClasses     = "character",
#                                      strip.white    = TRUE,
#                                      comment.char   = "",
#                                      row.names      = 1,
#                                      check.names    = FALSE,
#                                      mc.preschedule = FALSE,
#                                      mc.cores       = defs$cores)
#
#   defs$back <- pbmcapply::pbmclapply(X              = defs$back.name,
#                                      FUN            = utils::read.table,
#                                      sep            = "\t",
#                                      header         = TRUE,
#                                      colClasses     = "character",
#                                      strip.white    = TRUE,
#                                      comment.char   = "",
#                                      row.names      = 1,
#                                      check.names    = FALSE,
#                                      mc.preschedule = FALSE,
#                                      mc.cores       = defs$cores)
#
#   return(defs)
}
