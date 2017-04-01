#' Get data set from Australian data portal
#'
#' @param x \code{character} or \code{data.frame} object that contains
#'  information on which data set to download. See Details for more
#'  information.
#'
#' @param progress \code{character} passed to \code{.progress} argument in
#'   \code{\link[plyr]{llply}}.
#'
#' @param ... arguments passed to \code{\link[plyr]{llply}}.
#'
#' @return \code{list} of data.
#'
#' @export
#'
#' @details If argument to \code{x} is a \code{character} then the
#'  input is assumed to be the data set id. If it is a \code{data.frame}
#'  then the ids are accessesed from it \code{data.frame}.
#'
#' @examples
#' \donttest{
#' # download data using character id
#' d <- get_oz_dataset("062801f2-dcf9-4a2d-b65b-52f20d4da721")
#'
#' # download data using data.frame
#' d2 <- get_oz_dataset(oz_metadata[1:2,])
#' }
get_oz_dataset <- function(x, progress, ...) UseMethod("get_oz_dataset")

#' @export
get_oz_dataset.character <- function(x,  progress = "text", ...) {
  assertthat::assert_that(is.character(x), length(x) > 0, all(!is.na(x)))
  d <- plyr::llply(x, .progress = progress, ..., .fun = function(x) {
    urls <- get_url(x)
    stats::setNames(plyr::llply(urls, get_dataset_from_url), urls)
  })
  stats::setNames(d, x)
}

#' @export
get_oz_dataset.data.frame <- function(x, progress = "text", ...) {
  assertthat::assert_that(inherits(x, "data.frame"),
                          assertthat::has_name(x, "data"),
                          assertthat::has_name(x$data, "url"))
  get_oz_dataset.character(x$package_id)
}
