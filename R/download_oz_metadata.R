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
download_oz_metadata <- function(max_results = 1000) {
  # download first data set
  search <- ckanr::package_search(as = "table", rows = 1, start = 1,
                                  url = "https://data.gov.au")
  # extract number of datasets
  n <- min(search$count, max_results)
  # n <- 100
  # get starts for each chunk
  starts <- seq(1, n, 1e+3)
  # download metadata in chunks
  metadata <- plyr::llply(starts, .progress = "text", function(i) {
    # download chunk
    d <- ckanr::package_search(as = "json",
                               rows  = 1e+3, start = i,
                               url = "https://data.gov.au")

    # dt <- jsonlite::fromJSON(d)$result$results %>%
    #     select(-organization) %>%
    #     as_tibble()

    # jsonlite::fromJSON(d, simplifyDataFrame = TRUE)

    d %>%
        enter_object("result") %>%
        enter_object("results") %>%
        gather_array() %>%
        spread_values(license_title = jstring("license_title"),
                      jurisdiction = jstring("jurisdiction"),
                      author = jstring("author"),
                      contact_point = jstring("contact_point")) %>%
        enter_object("resources") %>%
        gather_array() %>%
        spread_values(package_id = jstring("package_id"),
                      id = jstring("id"),
                      size = jstring("size"),
                      description = jstring("description"),
                      name = jstring("name"),
                      created = jstring("created"),
                      data_url = jstring("url")) %>%
        as.tbl_json() -> tbj

    # return tibble
    return(tbj)
  })
  # compile and return metadata as tibble
  # tibble::as_tibble(plyr::rbind.fill(metadata))
  return(metadata)
}
