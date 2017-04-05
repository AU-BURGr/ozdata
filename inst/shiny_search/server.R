require(shiny)
require(MASS)

shinyServer(function(input, output, clientData, session) {
    observe({
        ids <- oz_metadata %>%
            #dplyr::filter()
            .$package_id

        updateSelectInput(session,
                          "oz_id",
                          choices = ids,
                          selected = ids)
    })


    #### Reactives ====
    react_metadata <- reactive({
        if (input$select_organisation != "All") {
            oz_metadata %>%
                dplyr::filter(organization == input$select_organisation)
        } else {
            oz_metadata
        }
    })


    react_data <- eventReactive(input$button_get_data, {
        url <- get_url(id = input$oz_id)
        return(url)
        #data <- get_url_dataset(url)
        #return(data)
    })


    #### Outputs ====
    output$value1 <- renderText({ paste("Your search term(s) are:  ",  input$text) })

    output$text1 <- renderText({
        paste("You have selected", input$select)
    })

    output$text2 <- renderText({
        paste("Your date range is ", input$dates[[1]], " to ", input$dates[[2]])
    })

    output$table_metadata <- renderDataTable({
        react_metadata()
    })

    output$react_test <- renderPrint({
        react_data()
    })

})
