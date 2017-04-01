#' search_metadata
#'
#' Runs `grepl` over the `tags` column of the metadata file and returns matching rows
#'
#' @md
#' @param metadata a metadata table to search
#' @param search the search term to check
#'
#' @return a `tibble` of metadata rows which match the search
#'
#' @export
#'
#' @examples
search_metadata <- function(metadata = NULL, search) {

    ## requires some data
    stopifnot(!is.null(metadata))

    ## find 'search' in the tags column
    pos_matches <- metadata %>% dplyr::filter(grepl(search, .$tags, ignore.case = TRUE))

    return(pos_matches)

}
