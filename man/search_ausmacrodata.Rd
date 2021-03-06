% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/ausmacrodatasearch.R
\name{search_ausmacrodata}
\alias{search_ausmacrodata}
\title{Search ausmacrodata.org}
\usage{
search_ausmacrodata(term)
}
\arguments{
\item{term}{a character string containing a search term.}
}
\description{
\code{search_ausmacrodata()} searches \url{http://ausmacrodata.org} and returns a
data frame describing data sets matching the search query.
}
\examples{
# Find all data sets that are about births
datasets <- search_ausmacrodata('births')
# Load first data set
y <- get_ausmacrodata(datasets[1,'ID'])
}
\author{
Rob J Hyndman
}
