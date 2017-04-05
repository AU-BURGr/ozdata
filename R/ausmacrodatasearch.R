#' Search ausmacrodata.org
#'
#' \code{search_ausmacrodata()} searches \url{http://ausmacrodata.org} and returns a
#' data frame describing data sets matching the search query.
#'
#' @param term a character string containing a search term.
#'
#' @author Rob J Hyndman
#'
#' @export
#' @examples
#' # Find all data sets that are about births
#' datasets <- search_ausmacrodata('births')
#' # Load first data set
#' y <- get_ausmacrodata(datasets[1,'ID'])

search_ausmacrodata <- function(term)
{
  # Construct URL for search
  url <- paste("http://ausmacrodata.org/searchvarlistJSON.php?sterm=", term, sep="")
  # Download file in JSON format
  doc <- RCurl::getURL(url)
  # Turn into data frame
  # (someone might like to replace this with a call using tidyjson)
  df <- jsonlite::fromJSON(doc)[[1]]
  if(length(df)==0L)
    message("No matching data sets found")
  # Return result
  return(df)
}

