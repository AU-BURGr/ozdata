#' Read data from ausmacrodata.org
#'
#' \code{ausmacro} returns a data set from \url{ausmacrodata.org}.
#' By default, it will return a time series (a `ts` object), although
#' a `tibble` is also possible (and probably preferable for daily data).
#'
#' @param dataset a URL for a specific data set on ausmacrodata.org, or an id for a data set.
#' @param format The desired format for the object to be returned.
#' @param ... Other arguments, not currently used.
#'
#' @author Rob J Hyndman
#'
#' @examples
#' y <- ausmacro("http://ausmacrodata.org/series.php?id=gdpcknaasaq")
#' plot(y)
#' z <- ausmacro("gdpcknaasaq")

ausmacro <- function(dataset, format=c("ts","tibble"), ...)
{
    format <- match.arg(format)

    # Find last occurrence of "=" in dataset
    id <- tail(strsplit(dataset, "=")[[1]],1)

    # Create URL
    url <- paste("http://ausmacrodata.org/series.php?id=", id, sep="")

    # Scrape page to find csv file
    links <- rvest::html_attr(rvest::html_nodes(xml2::read_html(url), "a"), "href")
    datalink <- stringr::str_subset(links, "\\.csv")

    # Check there is only one
    if(length(datalink) > 1)
    {
        warning("More than one csv file found. Using first one")
        datalink <- datalink[1]
    }

    # Read data
    dataurl <- paste("http://ausmacrodata.org", datalink, sep="")
    y <- readr::read_csv(dataurl)

    if(format=="tibble")
    {
        return(y[,c("date","value")])
    }
    else #return a ts
    {
        # Now check time attributes
        dates <- y[["date"]]
        dates <- stringr::str_split(dates,"/")
        if(length(dates[[1]]) == 3)
        {
            # We have daily data
            years <-  as.numeric(unlist(lapply(dates, function(x)x[[3]])))
            tblyears <- table(years)
            daysperyear <- max(tblyears)
            y <- ts(y[['value']],
                    frequency=daysperyear,
                    start=c(years[1]-1 + tblyears[1]/daysperyear))
        }
        else if(length(dates[[1]])==2)
        {
            #We have monthly, quarterly or annual data
            seasons <- as.numeric(unlist(lapply(dates, function(x)x[[1]])))
            years <-  as.numeric(unlist(lapply(dates, function(x)x[[2]])))
            useasons <- sort(unique(as.numeric(seasons)))
            y <- ts(y[['value']],
                frequency=length(useasons),
                start=c(years[1], match(seasons[1], useasons)))
        }
        else
            stop("Not sure what to do know")
        return(y)
    }
}

