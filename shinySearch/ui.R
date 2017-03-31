require(shiny)

myUI <- shinyUI(fluidPage(

    titlePanel("Search ozdata.gov.au"),

    sidebarLayout(
        sidebarPanel(
            helpText("Welcome to the R Project interface for searching Australian government open data."),
            br(),
        # text input box
        textInput("text", label = h5("Input search keyword"), value = "Enter text..."),

        hr(),
        fluidRow(column(10, verbatimTextOutput("value"))),

        # Insert date range selection option
        fluidRow(
            column(10,
                   dateRangeInput("dates", label = h5("Date range")))),

        # Insert drop down box with data.gov.au catetegory selections
        column(10,
               selectInput("select", label = h5("data.gov.au groups"),
                           choices = list("No selection" = 1, "Civic" = 2,
                                          "Cultural" = 3, "Defence" = 4,
                                          "Environment" = 5, "Finance" = 6,
                                          "Health" = 7, "Immigration" = 8), selected = 1)),

        br(),
        img(src = "highres_456807711.png", height = 36, width = 36),
        "BURGr UnConf 2017",
        br(),
        p("Insert licence conditions - e.g. GPL2", style = "font-family: 'times'; font-size:7pt")
        ),   # end 'sidebarPanel'

        mainPanel(h4("Main Panel - yet to be defined", align = "center"),
                  p("This area will be used to display search output tables")

                  )   # end 'mainPanel'

    )   # end 'sidebarLayout'

))   # end Shiny UI definition

