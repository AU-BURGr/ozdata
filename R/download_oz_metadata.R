#' @include internal.R
NULL

# TODO use standard evaluation for dplyr commands
globalVariables(c("id", "package_id", "data_url", "toplevel_id"))

#' Download meta-data
#'
#' Meta-data for all Australian datasets on \url{https://data.gov.au}. Collecting all of the meta-data entries will take quite some time.
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

  # download first data set
  search <- ckanr::package_search(as = "table", rows = 1, start = 1,
                                  url = "https://data.gov.au")
  # extract number of datasets
  n <- min(search$count, max_results)
  # n <- 100
  # get starts for each chunk
  starts <- seq(1, n, 1e+3)
  # starts <- seq(1, n, 1e+2)
  # download metadata in chunks
  metadata <- plyr::llply(starts, .progress = "text", function(i) {
    # download chunk as json
    d <- ckanr::package_search(as = "json",
                               rows  = ifelse(max_results < 1e3L, max_results, 1e3L), start = i,
                               # rows  = ifelse(max_results < 1e2L, max_results, 1e2L), start = i,
                               url = "https://data.gov.au")

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

    # extract organisation
    d %>%
        enter_object("result") %>%
        enter_object("results") %>%
        gather_array() %>%
        spread_values(toplevel_id = jstring("id")) %>%
        enter_object("organization") %>%
        spread_values(organization = jstring("title"),
                      org_description = jstring("description")) -> orgs

    # extract groups
    d %>%
        enter_object("result") %>%
        enter_object("results") %>%
        gather_array() %>%
        spread_values(toplevel_id = jstring("id")) %>%
        enter_object("groups") %>%
        gather_array() %>%
        spread_values(group = jstring("title")) -> grp

    tbm <- suppressMessages(merge(tbj, tglist, by = "toplevel_id", all.x = TRUE))
    tbm <- suppressMessages(merge(tbm, orgs, by = "toplevel_id", all.x = TRUE))
    tbm <- suppressMessages(merge(tbm, grp, by = "toplevel_id", all.x = TRUE))

        # return tbl_json
        return(tbm)
    })

  ## remove the tidyjson columns
  metadata <- dplyr::bind_rows(metadata) %>%
      dplyr::select(-starts_with("document.id"), -starts_with("array.index"))

  ## nest the data sub-matrix
  metadata_tbl <- suppressMessages(
      metadata %>%
      dplyr::group_by(package_id) %>%
      tidyr::nest(id:data_url) %>%
          dplyr::left_join(metadata %>%
                               dplyr::select(-c(id:data_url)) %>%
                               unique
                           )
  )


    # compile and return metadata as tibble
    # tibble::as_tibble(plyr::rbind.fill(metadata))
    return(metadata_tbl)
}
