#' @include internal.R
NULL

#' Download meta-data
#'
#' Meta-data for all Australian datasets on \url{https://data.gov.au}.
#'
#' @param cache Should metadata be loaded from cache? Defaults to \code{TRUE}.
#'
#' @return \code{link[tibble]{tibble}} table.
#'
#' @examples
#' \donttest{
#' # download latest version of metadata
#' metadata <- download_oz_metadata()
#' # print first 10 rows of data set
#' head(metadata)
#' }
#' @export
download_oz_metadata <- function() {
  # download first data set
  search <- ckanr::package_search(as = "table", rows = 1, start = 1,
                                  url = "https://data.gov.au")
  # extract number of datasets
  n <- search$count
  # get starts for each chunk
  starts <- seq(1, n, 1e+3)
  # download metadata in chunks
  metadata <- plyr::llply(starts, .progress = "text", function(i) {
    # download chunk
    d <- ckanr::package_search(as = "table",
                               rows  = 1e+3, start = i,
                               url = "https://data.gov.au")$results
    # add data in columns that are a data.frame as columns to the table
    df_columns <- vapply(d, inherits, logical(1), "data.frame")
    for (j in names(df_columns)[which(df_columns)]) {
      # extract columns
      for (k in names(d[[j]]))
        d[[paste0(j, "_", k)]] <- d[[j]][[k]]
      # delete column
      d[[j]] <- NULL
    }
    # return data.frame
    return(d)
  })
  # compile and return metadata as tibble
  tibble::as_tibble(plyr::rbind.fill(metadata))
}
