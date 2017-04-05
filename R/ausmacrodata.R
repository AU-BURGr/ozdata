#' Read data from ausmacrodata.org
#'
#' \code{get_ausmacrodata} returns a time series data set from \url{http://ausmacrodata.org}.
#'
#' @param dataset a URL for a specific data set on ausmacrodata.org, or an id for a data set.
#' @param format The desired format for the object to be returned. Possible
#' values are \code{ts}, \code{xts} and \code{tibble}. By default a \code{ts}
#' object is returned for quarterly, monthly or annual data, and an
#' \code{xts} object is returned for daily data.
#'
#' @author Rob J Hyndman
#'
#' @export
#' @examples
#' # Read quarterly Australia GDP using full URL
#' y <- get_ausmacrodata("http://ausmacrodata.org/series.php?id=gdpcknaasaq")
#' plot(y)
#'
#' # Read daily cash rate target interest rate using only series ID
#' z <- get_ausmacrodata('crtdoirymmdir')
#' library(xts)
#' plot(z)

get_ausmacrodata <- function(dataset, format) {
  # Find last occurrence of "=" in dataset
  id <- utils::tail(strsplit(dataset, "=")[[1]], 1)

  # Create URL
  url <- paste("http://ausmacrodata.org/series.php?id=", id, sep = "")

  # Scrape page to find csv file
  links <- rvest::html_attr(rvest::html_nodes(xml2::read_html(url), "a"),
                            "href")
  datalink <- stringr::str_subset(links, "\\.csv")

  # Check there is only one
  if (length(datalink) > 1) {
    warning("More than one csv file found. Using first one")
    datalink <- datalink[1]
  }

  # Read data
  dataurl <- paste("http://ausmacrodata.org", datalink, sep = "")
  y <- readr::read_csv(dataurl)
  dates <- y[["date"]]
  splitdates <- stringr::str_split(dates, "/")
  dailydata <- (nchar(dates[1]) == 10L)

  # Set format
  if (missing(format))
    format <- ifelse(dailydata, "xts", "ts")

  # Set up data in required format
  if (format == "tibble") {
    return(y[, c("date", "value")])
  }
  else if (format == "xts") {
    if (nchar(dates[1]) == 7L)
      dates <- paste("01/", dates, sep = "")
    y <- xts::as.xts(y[["value"]],
            order.by = as.Date(dates, format = "%d/%m/%Y"))
    return(y)
  }
  else if (format == "ts") {
    if (dailydata) {
      years <-  as.numeric(unlist(lapply(splitdates, function(x)x[[3]])))
      tblyears <- table(years)
      daysperyear <- max(tblyears)
      y <- stats::ts(y[["value"]],
          frequency = daysperyear,
          start = c(years[1] - 1 + tblyears[1] / daysperyear))
    }
    else {
      #We have monthly, quarterly or annual data
      seasons <- as.numeric(unlist(lapply(splitdates, function(x)x[[1]])))
      years <-  as.numeric(unlist(lapply(splitdates, function(x)x[[2]])))
      useasons <- sort(unique(as.numeric(seasons)))
      y <- stats::ts(y[["value"]],
        frequency = length(useasons),
        start = c(years[1], match(seasons[1], useasons)))
    }
    return(y)
  }
  else
    stop("I can't understand this format")
}
