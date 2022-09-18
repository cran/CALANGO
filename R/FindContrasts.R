# -=-=-=- Phylogenetically Independent Contrast analysis -=-=-=-

# Produces a vector with the correlation of each ontology term with the
# attribute in question after correcting for phylogenetic bias (see
# Felsenstein 1985 and APE package for details).
#
# Args:
#   x: (vector) variable with the counting of an attribute of
#               interest, like G+C, gene count or longevity.
#   y: (data.frame) table counting the presence of annotations
#                   of an ontology in each genome.
#   method: (char) method to use, allows "pearson", "spearman" and "kendall".
#   denominator: (numeric) parameter for normalization of the y variable.
#
# TODO: Check documentation of 'method' above. It is inconsistent with
#       the function definition (which accepts method = "gls" or method = "pic")
#
# Returns:
#   correlations: (vector) correlation of all listed ontology terms for the
#                          attribute in question.

FindContrasts <- function(x, y, tree, method = "gls", denominator = 1,
                          cores = 1, cl = NULL) {

  # ================== Sanity checks ==================
  assertthat::assert_that(is.data.frame(x),
                          is.data.frame(y),
                          class(tree) %in% c("phylo", "multiPhylo"),
                          method %in% c("pic", "gls"),
                          is.null(denominator) | is.numeric(denominator),
                          is.null(denominator) | all(denominator > 0))


  tmp_x         <- x[, 1]
  names(tmp_x)  <- rownames(x)

  # Phylogenetically Independent Contrasts
  if (method == "pic") {
    contrast_x <- ape::pic(x = tmp_x, phy = tree)

    # Normalizing
    if (!is.null(denominator)) y <- sweep(y, MARGIN = 1, denominator, `/`) # y <- y / denominator


    message("Computing contrasts")
    if (.Platform$OS.type == "windows"){
      models <- parallel::parLapply(cl   = cl,
                                    X    = y,
                                    fun  = function(tmpy, tree, cx, nx){
                                      names(tmpy) <- nx
                                      cy  <- ape::pic(tmpy, phy = tree)
                                      mod <- stats::lm(cy ~ cx + 0)
                                      return(summary(mod)$coefficients[1, 4])},
                                    tree = tree,
                                    cx   = contrast_x,
                                    nx   = rownames(x))
    } else {
      models <- pbmcapply::pbmclapply(y,
                                      function(tmpy, tree, cx, nx){
                                        names(tmpy) <- nx
                                        cy  <- ape::pic(tmpy, phy = tree)
                                        mod <- stats::lm(cy ~ cx - 1)
                                        return(summary(mod)$coefficients[1, 4])},
                                      tree           = tree,
                                      cx             = contrast_x,
                                      nx             = rownames(x),
                                      mc.preschedule = TRUE,
                                      mc.cores       = cores)
    }

  } else if (method == "gls") {
    # TODO: method "gls" throws errors both in the original version and the
    # reimplemented version below. Please check.

    # Normalizing
    if (!is.null(denominator)) {
      # Getting counts per million to avoid false convergence (8) error
      # from gls function for small values,
      # see http://r.789695.n4.nabble.com/quot-False-convergence-quot-in-LME-td860675.html
      # y <- (y / denominator) * 10^6
      y <- sweep(y, MARGIN = 1, denominator, `/`) * 10^6
    }

    tmpfun <- function(tmpy, tmpx, nx, tree){
      if(any(tmpy == 0)){
        model <- nlme::gls(tmp_y ~ tmp_x,
                           data = as.data.frame(cbind(tmpx, tmpy)),
                           correlation = ape::corPagel(value = 1,
                                                       phy = tree),
                           control     = list(singular.ok = TRUE))
        return(as.numeric(summary(model)$coefficients[2]))
      } else {
        return(1)
      }}

    if (.Platform$OS.type == "windows"){
      models <- parallel::parLapply(cl   = cl,
                                    X    = y,
                                    fun  = tmpfun,
                                    tmpx = tmp_x,
                                    nx   = rownames(x),
                                    tree = tree)
    } else {
      models <- pbmcapply::pbmclapply(X    = y,
                                      FUN  = tmpfun,
                                      tmpx = tmp_x,
                                      nx   = rownames(x),
                                      tree = tree,
                                      mc.preschedule = TRUE,
                                      mc.cores = cores)
    }
  } else{
    stop("'", method,"' is not a recognized method in CALANGO::FindContrasts()")
  }

  models        <- unlist(models)
  return(sort(models, decreasing = FALSE))
}
