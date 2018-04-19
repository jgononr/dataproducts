#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(DT)
library(ISLR)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {

    model <- lm(mpg~horsepower, data = Auto)

    output$plot <- renderPlot({
        plot(y = Auto$mpg, x = Auto$horsepower,
             ylab = "Miles per Gallon", xlab = "Horsepower")
        abline(model, col = "red", lwd = 2)
    })

    output$sl_hp <- ({renderText(input$ti_hp)})

    output$ti_hp <- ({renderText(input$sl_hp)})

    output$dataset <- DT::renderDataTable({
        DT::datatable({Auto})
})

  ## session$onSessionEnded(stopApp)
})
