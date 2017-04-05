run_shiny_search <- function()
{
    shiny::runApp(appDir = system.file("shiny_search", package = "ozdata"))
}
