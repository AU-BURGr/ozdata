run_shiny_search <- function(x, ...)
{
    shiny::runApp(appDir = system.file("shiny_search", package = "ozdata"))
}
