#' @include internal.R
NULL

#' Get a data set from a URL
#'
#' Download and import a data set from a URL. This function assumes that the
#' URL points to a zip archive.
#'
#' @param x \code{character} URL containing data to download and import.
#'
#' @param force \code{logical} If the argument to \code{x} contains a data set
#'   that is greater than 100 Mb in size, should the data set still be
#'   downloaded?.
#'
#' @return \code{\link[tibble]{tibble}} or \code{\link[sf]{sfc}}
#'   object.
#'
#' @examples
#' url <- paste0("https://datagovau.s3.amazonaws.com/bioregionalassessm",
#'               "ents/LEB/PED/DATA/Resources/Other/110_Context_statement",
#'               "NTGAB_Selected_Wetlands/062801f2-dcf9-4a2d-b65b-52f20d4",
#'               "da721.zip")
#' dataset <- get_url_dataset(url)
#'
#' @export
get_url_dataset <- function(x, force = FALSE) {
  ## assert input is valid
  # check arguments
  assertthat::assert_that(assertthat::is.string(x), assertthat::is.flag(force))
  # check that url exists
  url_properties <- RCurl::url.exists(x, .header = TRUE)
  if (identical(url_properties, FALSE))
    stop("url does not exist")
  # check that data set is not too big
  file_size <- as.numeric(url_properties["Content-Length"]) / 1000000
  if (file_size > 100)
    stop("data set size is ", file_size, ". Use force = TRUE to download it.")
  ## Download zip file and extract contents
  # create temporary files and directories
  tmp_dir <- file.path(tempdir(), basename(tempfile()))
  dir.create(tmp_dir, showWarnings = FALSE, recursive = TRUE)
  utils::download.file(x, file.path(tmp_dir, "archive.zip"))
  # unzip file
  utils::unzip(file.path(tmp_dir, "archive.zip"), exdir = tmp_dir,
               junkpaths = TRUE)
  # delete archive
  unlink(file.path(tmp_dir, "archive.zip"))
  ## Import data
  output <- list()
  # list files in folder
  files <- dir(path = tmp_dir, full.names = TRUE)
  # find .csv files
  csv_path <- grep(".csv$", files, value = TRUE)
  if (length(csv_path) > 0)
    output <- append(output, lapply(csv_path, data.table::fread,
                                    data.table = FALSE))
  files <- files[!files %in% csv_path]
  # coerce data.frames to tibbles
  df_objects <- which(sapply(output, class) == "data.frame")
  if (length(df_objects) > 0 )
    output[df_objects] <- lapply(output[df_objects], tibble::as_tibble)
  # check if data contains a shapefiles
  shapefile_path <- grep(".shp$", files, value = TRUE)
  # if directory contains shape files then load it
  if (length(shapefile_path) > 0)
    output <- append(output, lapply(shapefile_path, sf::st_read, quiet = TRUE))
  # remove shapefile paths
  shapefile_path <- gsub(".shp", "", shapefile_path, fixed = TRUE)
  shapefile_path <- c(paste0(shapefile_path, ".shp"),
                      paste0(shapefile_path, ".shp.xml"),
                      paste0(shapefile_path, ".sbn"),
                      paste0(shapefile_path, ".shx"),
                      paste0(shapefile_path, ".sbx"),
                      paste0(shapefile_path, ".dbf"),
                      paste0(shapefile_path, ".prj"))
  files <- files[!files %in% shapefile_path]
  # load remaining datasets
  if (length(files) > 0) {
    if (requireNamespace("rio", quietly = TRUE)) {
      output <- suppressWarnings(append(output, lapply(files, rio::import)))
    } else {
      warning("archive contains the following files that are not supported.",
              " Install the rio package to import them: ",
              paste(files, collapse = ","), ".")
    }
  }
  ## return object
  return(output)
}
