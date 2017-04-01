require(shiny)

shinyServer(function(input, output) {

    # You can access the value of the widget with input$text, e.g.
    output$value1 <- renderPrint({ input$text })

    output$text1 <- renderText({
        paste("You have selected", input$select)
    })

    output$text2 <- renderText({
        paste("Your date range is ", input$dates[[1]], " to ", input$dates[[2]])
    })


}
)   # end Shiny Server defintion
