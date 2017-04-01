require(shiny)
require(MASS)

shinyServer(function(input, output) {

    output$value1 <- renderText({ paste("Your search term(s) are:  ",  input$text) })

    output$text1 <- renderText({
        paste("You have selected", input$select)
    })

    output$text2 <- renderText({
        paste("Your date range is ", input$dates[[1]], " to ", input$dates[[2]])
    })

    # Output table for UScereals
    output$table <- renderTable({
        #as_data_frame(read.csv(file = "shinySearch/data/UScereal.csv"))
    as_data_frame(UScereals)

    })   # End US cereals table output

})   # end Shiny Server defintion
