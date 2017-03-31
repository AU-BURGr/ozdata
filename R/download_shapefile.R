#' Download shape file
#'
#' Function for downloading shape files. Downloads zip file, unzips and loads
#' .shp file.
#'
#' @param url path to zip file to be downloaded.
#' @param output_type select from "sf" for simple format or "shape" for shape
#'   file.
#'
#' @author Cameron Roach
#'
#' @return returns either a sf or shape data frame object.
#' @export
#'
#' @examples
#' metadata <- ckanr::package_show("062801f2-dcf9-4a2d-b65b-52f20d4da721",
#'                                 as = "table",
#'                                 url = "http://www.data.gov.au")
#' url <- metadata$resources[["url"]]
#' dataset <- download_shapefile(url)
download_shapefile <- function(url) {
  # create temporary files and directories
  tmp_file <- tempfile()
  tmp_dir <- file.path(tempdir(), basename(tempfile()))
  dir.create(tmp_dir, showWarnings = FALSE, recursive = TRUE)
  # download zip file
  utils::download.file(url, tmp_file)
  # unzip file
  utils::unzip(tmp_file, exdir = tmp_dir, junkpaths = TRUE)
  # find file that ends in .shp
  shape_file <- list.files(path = tmp_dir, pattern = ".shp$")
  # load shapefile
  sf::st_read(file.path(tmp_dir, shape_file))
}
