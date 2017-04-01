require(shiny)
require(tibble)

myUI <- shinyUI(fluidPage(

    titlePanel("Search ozdata.gov.au"),

    sidebarLayout(
        # Sidebar panel which contains the input options for user selection
        # Define sidebar panel width
        sidebarPanel(
            helpText("Welcome to the R Project interface for searching Australian government open data."),

        # text search input box
        textInput("text", label = h5("Input search keyword"), value = "Enter text..."),

        # Insert date range selection option
        fluidRow(
            column(12,
                   dateRangeInput("dates", label = h5("Date range")))),

        # Insert drop down box with data.gov.au catetegory selections
        column(12,
               selectInput("select", label = h5("data.gov.au groups"),
                           choices = list("No selection" = 1, "Civic" = 2,
                                          "Cultural" = 3, "Defence" = 4,
                                          "Environment" = 5, "Finance" = 6,
                                          "Health" = 7, "Immigration" = 8),
                                            selected = 1)),

        # There has to be a better way for formatting this break....
        br(), br(), br(), br(), br(),

        # Insert BUGr image and licence conditions
        img(src="highres_456807711.png", height = 40, width = 40), "BURGr UnConf 2017",
        p("Insert licence conditions - e.g. GPL2", style = "font-family: 'times'; font-size:7pt")
        ),   # end 'sidebarPanel'

        # Define shiny Main Panel
        mainPanel(
            tabsetPanel(
                tabPanel("Search Results",
                         h4("Main Panel - yet to be defined", align = "center"),
                         p("This area will be used to display search output tables"),
                         # Call in
                         textOutput("value1"), br(),
                         textOutput("text1"), br(),
                         textOutput("text2")   # Reactive output from server.R file
                        ),
                tabPanel("Results",
                         tableOutput("table")

                         )



                  )   # end 'mainPanel'

    )   # end 'sidebarLayout'

)))   # end Shiny UI definition

