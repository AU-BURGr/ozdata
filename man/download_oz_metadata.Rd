% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/download_oz_metadata.R
\name{download_oz_metadata}
\alias{download_oz_metadata}
\title{Download meta-data}
\usage{
download_oz_metadata()
}
\arguments{
\item{cache}{Should metadata be loaded from cache? Defaults to \code{TRUE}.}
}
\value{
\code{link[tibble]{tibble}} table.
}
\description{
Meta-data for all Australian datasets on \url{https://data.gov.au}.
}
\examples{
\donttest{
# download latest version of metadata
metadata <- download_oz_metadata()
# print first 10 rows of data set
head(metadata)
}
}