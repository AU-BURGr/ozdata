#' Download shape file
#'
#' Function for downloading shape file. Downloads zip file, unzips and loads
#' .shp file.
#'
#' @param url path to zip file to be downloaded.
#'
#' @return
#' @export
#'
#' @examples
download_shape <- function(url) {
    tmp_dir <- "./cache"
    dir.create(tmp_dir, F, T)
    tmp_file <- file.path(tmp_dir, "file.zip")
    download.file(url, tmp_file)
    unzip(tmp_file, exdir = tmp_dir, junkpaths = TRUE)
    shape_file <- list.files(path = tmp_dir, pattern = ".shp$")
    shape_points <- maptools::readShapePoints(file.path(tmp_dir, shape_file))
    unlink(tmp_dir, recursive = TRUE)

    return(shape_points)
}
