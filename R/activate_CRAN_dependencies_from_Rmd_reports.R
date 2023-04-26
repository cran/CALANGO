activate_CRAN_dependencies_from_Rmd_reports <- function(){
  # IMPORTANT: any new CRAN package dependency that's used only in the .Rmd
  # files must be called once below, to prevent CRAN warnings (CRAN will
  # check if all packages in `Depends` are used at least once within the
  # functions in the `R` folder.)
  if (FALSE){ # <---------------- code in here is never to be called, of course.
    dendextend::fac2num(factor(3:5))
    heatmaply::BrBG(5)                # for heatmaply
    ggplot2::aes()                    # for ggplot2
    plotly::api()                     # for plotly
    DT::JS()                          # for DT
    htmltools::a()                    # for htmltools
    htmlwidgets::JS()                 # for htmlwidgets
    pkgdown::as_pkgdown()             # for pkgdown
    knitr::all_labels()               # for knitr
  }
}