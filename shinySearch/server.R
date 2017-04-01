require(shiny)

shinyServer(function(input, output) {

    # You can access the value of the widget with input$text, e.g.
    output$value <- renderPrint({ input$text })

    output$text1 <- renderText({
        paste("You have selected", input$select)
    })


}
)   # end Shiny Server defintion
