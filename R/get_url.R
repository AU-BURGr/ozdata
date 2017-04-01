#' Get the download URL for an Oz dataset using its ID
#'
#' Function for finding the download URL given a data set ID.
#'
#' @param id ID for which to find a URL
#'
#' @return The download URL for the item for which the ID has been given
#'
#' @author Adam H Sparks
#'
#' @export
#'
#' @examples
#' get_url(id = "062801f2-dcf9-4a2d-b65b-52f20d4da721")
#'
get_url <- function(id) {
    assertthat::assert_that(assertthat::is.string(id))
    d <- ckanr::package_show(paste0(id),
                             as = "table",
                             url = "http://www.data.gov.au")
    url <- d$resources[["url"]]
    return(url)
}
