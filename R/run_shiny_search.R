#' Run shiny search app
#'
#' This function runs the shiny search app for data.gov.au.
#'
#' @return A shiny application
#'
#' @author Simon Lyons, Cameron Roach
#'
#' @export
#'
#' @examples
#' \donttest{
#' run_shiny_search()
#' }
run_shiny_search <- function()
{
    shiny::runApp(appDir = system.file("shiny_search", package = "ozdata"))
}
