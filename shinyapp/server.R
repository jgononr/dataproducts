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
library(caret)

# Define server logic required to draw a histogram
shinyServer(function(input, output, session) {

    trainset <- reactive({
        sel <- input$config_trainsetselection
        percent <- input$config_trainsetpercent

        if(sel == 1) {
            ## First n% elements
            selectedrow <- round(nrow(Auto)*percent/100)
            rows <- c(1:selectedrow)
        } else if (sel == 2) {
            ## Middle n%elements
            trainsetelements <- round(nrow(Auto)*(100 - percent)/2)/100
            rows <- c(trainsetelements:(nrow(Auto)-trainsetelements))
        } else if (sel == 3) {
            ## Last n% elements
            selectedrow <- nrow(Auto) - round(nrow(Auto)*percent/100)
            rows <- c(selectedrow:nrow(Auto))
        } else {
            ## Create data partitions
            rows <- createDataPartition(y = Auto$mpg, p = percent/100,
                                        list = FALSE)
        }
        rows
    })

    plotmodel <- reactive({
        model.lm <- lm(mpg~horsepower, data = Auto[trainset(),])
        model.ss <- smooth.spline(Auto[trainset(), ]$horsepower,
                      Auto[trainset(), ]$mpg,
                      df = input$model_ss.df, nknots = input$model_ss.knots)
        model1.lm3 <- lm(mpg ~ poly(horsepower, degree=input$model1_poly.degree),
                        data=Auto)
        model2.lm3 <- lm(mpg ~ poly(horsepower, degree=input$model2_poly.degree),
                         data=Auto)
        polydata1 <- polydata2 <- data.frame(horsepower = seq(
                                                min(df$horsepower),
                                                max(df$horsepower),
                                                length.out = 100))
        polydata1$mpg <- predict(model1.lm3, newdata = modelplot)
        polydata2$mpg <- predict(model2.lm3, newdata = modelplot)
        if (input$model1_plot) {
            sel <- input$model1_modelsel
            if (sel == 1) {
                ## Linear model
                abline(model.lm,
                       col = input$model1_colorsel, lwd = input$model1_width,
                       lty = input$model1_linetype)
            } else if (sel == 2) {
                ## Polynomial regression
                lines(polydata1$horsepower, polydata1$mpg,
                      col = input$model1_colorsel, lwd = input$model1_width,
                      lty = input$model1_linetype)
            } else {
                ## Smooth spline
                lines(model.ss,
                      col = input$model1_colorsel, lwd = input$model1_width,
                      lty = input$model1_linetype)
            }
        }
        if (input$model2_plot) {
            sel <- input$model2_modelsel
            if (sel == 1) {
                ## Linear model
                abline(model.lm,
                       col = input$model2_colorsel, lwd = input$model2_width,
                       lty = input$model2_linetype)

            } else if (sel == 2) {
                ## Polynomial regression
                cat(file = stderr(), "model1_poly_change\n")
                lines(polydata2$horsepower, polydata2$mpg,
                      col = input$model2_colorsel, lwd = input$model2_width,
                      lty = input$model2_linetype)
            } else {
                ## Smooth spline
                lines(model.ss,
                      col = input$model2_colorsel, lwd = input$model2_width,
                      lty = input$model2_linetype)
            }
        }
    })

    output$plot <- renderPlot({
        df <- Auto[order(Auto$horsepower),]
        plot(y = df[trainset(),]$mpg, x = df[trainset(),]$horsepower,
             ylim = c(0, max(Auto$mpg)), xlim = c(0, max(Auto$horsepower)),
             col = input$config_trainsetcolor,
             ylab = "Miles per Gallon", xlab = "Horsepower")
        points(y = df[-trainset(),]$mpg, x = df[-trainset(),]$horsepower,
             col = input$config_testsetcolor)
        plotmodel()
    })

    output$dataset <- DT::renderDataTable({
        DT::datatable({Auto})
    })

    session$onSessionEnded(stopApp)
})
