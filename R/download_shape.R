#' Download shape file
#'
#' Function for downloading shape file. Downloads zip file, unzips and loads
#' .shp file.
#'
#' @param url path to zip file to be downloaded.
#' @param output_type select from "sf" for simple format or "shape" for shape
#'   file.
#'
#' @return
#' @export
#'
#' @examples
download_shape <- function(url, output_type = "sf") {
    tmp_dir <- "./cache"
    dir.create(tmp_dir, F, T)
    tmp_file <- file.path(tmp_dir, "file.zip")
    utils::download.file(url, tmp_file)
    utils::unzip(tmp_file, exdir = tmp_dir, junkpaths = TRUE)
    shape_file <- list.files(path = tmp_dir, pattern = ".shp$")

    if (output_type == "sf") {
        output <- sf::st_read(file.path(tmp_dir, shape_file))
    } else if (output_type == "shape") {
        output <- maptools::readShapePoints(file.path(tmp_dir, shape_file))
    }

    unlink(tmp_dir, recursive = TRUE)

    return(output)
}
