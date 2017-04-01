require(shiny)
require(tibble)
require(shinythemes)


myUI <- shinyUI(fluidPage(theme = shinytheme("cerulean"),

    titlePanel("Search data.gov.au"),

    sidebarLayout(
        # Sidebar panel which contains the input options for user selection
        # Define sidebar panel width
        sidebarPanel(
            helpText("Welcome to the R Project interface for searching Australian government open data."),

        # text search input box
        textInput("text", label = h5("Input search keyword"), value = "Enter text..."),

        # dropdown for ids
        selectInput("oz_id",
                    label = h5("Package ID"),
                    choices = NULL,
                    multiple = FALSE),
        actionButton("button_get_data", "Get data"),


        # Insert date range selection option
        fluidRow(
            column(12,
                   dateRangeInput("dates", label = h5("Date range")))),

        # Insert drop down box with data.gov.au catetegory selections
        column(12,
               selectInput("select", label = h5("data.gov.au groups"),
                           choices = group_var, selected = 1)),

        # Insert BUGr image and licence conditions
        img(src="highres_456807711.png", height = 40, width = 40), "BURGr UnConf 2017",
        p("Insert licence conditions - e.g. GPL2", style = "font-family: 'times'; font-size:7pt")
        ),   # end 'sidebarPanel'

        # Define shiny Main Panel
        mainPanel(
            tabsetPanel(
                tabPanel("Search Results",
                         h4("Metadata", align = "center"),
                         p("This area will be used to display search output tables"),
                         # Call in
                         textOutput("value1"), br(),
                         textOutput("text1"), br(),
                         textOutput("text2"), br(),  # Reactive output from server.R file
                         dataTableOutput("table_metadata")
                        ),
                tabPanel("URLs",
                         verbatimTextOutput("react_test")
                         )



                  )   # end 'mainPanel'

    )   # end 'sidebarLayout'

)))   # end Shiny UI definition

