# library(rgdal)
# library(mapview)
# library(ckanr)
# library(dplyr)
# library(rio)
# library(tibble)


multi.sapply <- function(...) {
  # http://rsnippets.blogspot.com.au/2011/11/applying-multiple-functions-to-data.html
  arglist <- match.call(expand.dots = FALSE)$...
  var.names <- sapply(arglist, deparse)
  has.name <- (names(arglist) != "")
  var.names[has.name] <- names(arglist)[has.name]
  arglist <- lapply(arglist, eval.parent, n = 2)
  x <- arglist[[1]]
  arglist[[1]] <- NULL
  result <- sapply(arglist, function (FUN, x) sapply(x, FUN), x)
  colnames(result) <- var.names[-1]
  return(result)
}

globalVariables(c("matched"))

characterise_data <- function(resources) {

  multi.sapply(resources$url, is_csv, is_web, is_xls, is_xlsx, is_xml, is_zip) %>%
    as.data.frame() %>%
    dplyr::mutate(matched = rowSums(.)) %>%
    tibble::rownames_to_column(var = "url") %>%
    dplyr::mutate(can_use = ifelse(matched == 1, "yes", "no"))

}


search_data <- function(query = "name:location", limit = 10) {

  ckanr::ckanr_setup("http://www.data.gov.au")

  ## obtain the result of the search
  ## and check if they can be processed
  all_res <- ckanr::resource_search(q = query, as = "table", limit = limit)$results

  ## add a column stating whether or not we can use this data yet
  all_res$can_use <- characterise_data(all_res)$can_use

  return(all_res)

}


is_zip <- function(x) endsWith(x, ".zip")


is_xlsx <- function(x) endsWith(x, ".xlsx")


is_xls <- function(x) endsWith(x, ".xls")


is_csv <- function(x) endsWith(x, ".csv")


is_xml <- function(x) endsWith(x, ".xml")


is_web <- function(x) {
  endsWith(x, ".php") || endsWith(x, ".html") || endsWith(x, ".html") || endsWith(x, ".htm")
}


show_data <- function(resource_row) {

  if (nrow(resource_row) > 1L)
    stop("Only one at a time, please.")

  ## extract the data URL
  resurl <- resource_row$url

  print(resurl)

  ## is this a file we can use?
  if (resource_row$can_use == "no")
    stop("Sorry, can't work with this file yet.")

  ## is this a .zip file?
  if (is_zip(resurl)) {

    message("Working with .zip (shp) file... Evaluate returned object.")

    ## create a temporary file for the .zip
    tf <- tempfile()

    ## save the .zip to the temporary directory
    try(utils::download.file(resurl, destfile = tf))

    ## unzip the folder
    shpfiles <- try(utils::unzip(tf, exdir = tempdir()))

    ## read the shapefile
    shpfile <- grep(".shp$", shpfiles, value = TRUE)

    ## sometimes there are 0 .shp files, sometimes too many
    if (length(shpfile) != 1) stop("Unexpected unzipping of files.")

    ## read the shapefile into a usable format
    shp <- try(rgdal::readOGR(shpfile))

    ## plot the shapefile on exit
    return(mapview::mapview(shp))

  } else if (is_csv(resurl) || is_xls(resurl) || is_xlsx(resurl)) {

    message("Working with .[csv|xls|xlsx] file... Returning data.")

    ## use rio to import the data if it can
    return(try(rio::import(resurl)))

  } else {

    message("Sorry, not sure how to work with this data.")

  }

}

#### USAGE:

# library(dplyr)
# res <- search_data("name:water", limit = 20)
# res %>% filter(can_use == "yes") %>% slice(2) %>% show_data

# res <- search_data("name:fire", limit = 20)
# res %>% filter(can_use == "yes") %>% slice(3) %>% show_data %>% View
# res %>% filter(can_use == "yes") %>% slice(4) %>% show_data

# res <- search_data("name:population", limit = 20)
# res %>% filter(can_use == "yes") %>% View
# res %>% filter(can_use == "yes") %>% slice(5) %>% show_data() %>% View

# res <- search_data("name:location", limit = 100)
# res %>% filter(can_use == "yes", format == "SHP") %>% View
# res %>% filter(can_use == "yes", format == "SHP") %>% slice(6) %>% show_data()
# res %>% filter(can_use == "yes", format == "SHP") %>% slice(7) %>% show_data()

# res <- search_data("format:SHP", limit = 100)
# res %>% filter(can_use == "yes") %>% View
# res %>% filter(can_use == "yes") %>% slice(4) %>% show_data()
# res %>% filter(can_use == "yes") %>% slice(22) %>% show_data()

# res <- search_data("description:QLD", limit = 100) ## BIG!
# res %>% filter(can_use == "yes", format == "SHP") %>% View
# res %>% filter(can_use == "yes", format == "SHP") %>% slice(2) %>% show_data()

## useful to search:
# name
# url
# licence_id
# description
# id
# format
#
