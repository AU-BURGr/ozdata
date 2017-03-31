#' @include internal.R

#' Datasets
#'
#' List all available datasets.
#'
#' @return \code{link[tibble]{tibble}}
datasets <- function() {
  # set up api access
  ckanr::ckanr_setup(url = "data.gov.au")
  # download ids
  ids <- ckanr::package_list(as = "table", limit = NULL)
  # download metatadata and convert to data
  do.call(rbind, lapply(ids, ckanr::package_show))
}
