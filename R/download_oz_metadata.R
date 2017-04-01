#' Download meta-data from data.gov.au
#'
#' Meta-data for all Australian datasets on \url{https://data.gov.au}.
#'
#' @param max_results Maximum results to return. Set to \code{Inf} for everything (40,000+).
#'
#' @return \code{link[tibble]{tibble}} table.
#'
#' @import tidyjson
#'
#' @examples
#' \donttest{
#' # download latest version of metadata
#' metadata <- download_oz_metadata(max_results = 100)
#' # print first 10 rows of data set
#' head(metadata)
#' }
#' @export
download_oz_metadata <- function(max_results = 1000) {
    toplevel_id <-
        name <-
        document.id <- array.index <- package_id <- id <- data_url <- NULL
    # download first data set
    search <- ckanr::package_search(
        as = "table",
        rows = 1,
        start = 1,
        url = "https://data.gov.au"
    )
    # extract number of datasets
    n <- min(search$count, max_results)
    # n <- 100
    # get starts for each chunk
    starts <- seq(1, n, 1e+3)
    # download metadata in chunks
    metadata <- plyr::llply(starts, .progress = "text", function(i) {
        # download chunk as json
        d <- ckanr::package_search(
            as = "json",
            rows  = min(1e+3, n),
            start = i,
            url = "https://data.gov.au"
        )

        ## create the relevant columns using tidyjson syntax
        d %>%
            enter_object("result") %>%
            enter_object("results") %>%
            gather_array() %>%
            spread_values(
                license_title = jstring("license_title"),
                jurisdiction = jstring("jurisdiction"),
                author = jstring("author"),
                contact_point = jstring("contact_point"),
                toplevel_id = jstring("id"),
                notes = jstring("notes")
            ) %>%
            enter_object("resources") %>%
            gather_array() %>%
            spread_values(
                package_id = jstring("package_id"),
                id = jstring("id"),
                size = jstring("size"),
                description = jstring("description"),
                name = jstring("name"),
                created = jstring("created"),
                data_url = jstring("url")
            ) %>%
            as.tbl_json() -> tbj

        # extract the tags and concatenate them
        d %>%
            enter_object("result") %>%
            enter_object("results") %>%
            gather_array() %>%
            spread_values(toplevel_id = jstring("id")) %>%
            enter_object("tags") %>%
            gather_array() %>%
            spread_values(name = jstring("name")) %>%
            dplyr::group_by(toplevel_id) %>%
            dplyr::summarise(tags = toString(name)) -> tglist

        tbm <-
            suppressMessages(merge(tbj,
                                   tglist,
                                   by = "toplevel_id",
                                   all.x = TRUE))

        # return tbl_json
        return(tbm)
    })

    ## remove the tidyjson columns
    metadata <-
        metadata[[1]] %>% dplyr::select(-document.id, -array.index)

    ## nest the data sub-matrix
    metadata_tbl <- suppressMessages(
        metadata %>%
            dplyr::group_by(package_id) %>%
            tidyr::nest(id:data_url) %>%
            dplyr::left_join(metadata %>%
                                 dplyr::select(-c(id:data_url)) %>% unique)
    )

    # compile and return metadata as tibble
    # tibble::as_tibble(plyr::rbind.fill(metadata))
    return(metadata_tbl)
}
