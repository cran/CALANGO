# -=-=-=- Correlation analysis -=-=-=-

# Produces a vector with the correlation of each ontology term with the
# attribute in question.
#
# Args:
#   x: (vector) variable with the counting of an attribute of
#               interest, like G+C, gene count or longevity.
#   y: (data.frame) table counting the presence of annotations
#                   of an ontology in each genome.
#   method: (char) method to use, allows "pearson", "spearman" and "kendall".
#   denominator: (numeric) parameter for normalization of the y variable.
# Returns:
#   correlations: (vector) correlation of all listed ontology terms for the
#                          attribute in question.

# Consider adding differentiation for x and y denominator column.
FindCorrelations <- function(x, y, method = "pearson", denominator = 1,
                             cores = 1, cl = NULL) {

  # ================== Sanity checks ==================
  assertthat::assert_that(is.data.frame(x),
                          is.data.frame(y),
                          is.null(denominator) | is.numeric(denominator),
                          is.null(denominator) | all(denominator > 0))


  # Normalizing
  # FIXED
  # y is a data frame and denominator is a numeric vector.
  # is this division *really* what you want? Because it is dividing in a very
  # counterintuitive manner. A possibly better way is suggested below.
  if (!is.null(denominator)) y <- sweep(y, MARGIN = 1, denominator, `/`) # y <- y / denominator

  message("Calculating correlations:", method)
  tmpfun <- function(tmpy, tmpx, method, ny){
    mycor <- stats::cor(tmpx[ny, 1], tmpy,
                        method = method)
    mypv  <- stats::cor.test(tmpx[ny, 1], tmpy,
                             method = method)$p.value
    return(list(mycor = mycor, mypv = mypv))}

  if (.Platform$OS.type == "windows"){
    tmp <- parallel::parLapply(cl     = cl,
                               X      = y,
                               fun    = tmpfun,
                               tmpx   = x,
                               method = method,
                               ny     = rownames(y))
  } else {
    tmp <- pbmcapply::pbmclapply(X      = y,
                                 FUN    = tmpfun,
                                 tmpx   = x,
                                 method = method,
                                 ny     = rownames(y),
                                 mc.preschedule = TRUE,
                                 mc.cores       = cores)
  }

  correlations               <- sapply(tmp, function(tmpx) tmpx$mycor)
  correlations.pvalue        <- sapply(tmp, function(tmpx) tmpx$mypv)
  names(correlations)        <- colnames(y)
  names(correlations.pvalue) <- colnames(y)
  correlations               <- sort(correlations,
                                     decreasing = TRUE)
  correlations.pvalue        <- sort(correlations.pvalue,
                                     decreasing = TRUE)

  return(list(cor         = correlations,
              cor.pvalues = correlations.pvalue))

}
