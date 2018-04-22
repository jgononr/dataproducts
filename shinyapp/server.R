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
        deg1 <- input$model1_poly.degree
        deg2 <- input$model2_poly.degree
        model1.lm3 <- lm(mpg ~ poly(horsepower, degree=deg1),
                         data=Auto[trainset(),])
        model2.lm3 <- lm(mpg ~ poly(horsepower, degree=deg2),
                         data=Auto[trainset(),])
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
                model1 <- model.lm
            } else if (sel == 2) {
                ## Polynomial regression
                lines(polydata1$horsepower, polydata1$mpg,
                      col = input$model1_colorsel, lwd = input$model1_width,
                      lty = input$model1_linetype)
                model1 <- model1.lm3
            } else {
                ## Smooth spline
                lines(model.ss,
                      col = input$model1_colorsel, lwd = input$model1_width,
                      lty = input$model1_linetype)
                model1 <- model.ss
            }
            if (sel != 3) {
                output$model1_pred <- renderText({
                    paste("Model 1 prediction:",
                          round(predict(model1,
                                        newdata = data.frame(horsepower = input$plot_horsepower))
                                ,digits = 2), "mpg")
                })
                points(input$plot_horsepower,
                       predict(model1, newdata = data.frame(horsepower = input$plot_horsepower)),
                       cex = 2, pch = 18, col = input$model1_colorsel)
            } else {
                pred <- predict(model1,
                                newdata = data.frame(horsepower = input$plot_horsepower))
                pred <- pred$y[sum(pred$x < input$plot_horsepower)]
                output$model1_pred <- renderText({
                    paste("Model 1 prediction:",
                          round(pred ,digits = 2), "mpg")
                })
                points(input$plot_horsepower, pred, cex = 2, pch = 18,
                       col = input$model1_colorsel)
            }
        }
        if (input$model2_plot) {
            sel <- input$model2_modelsel
            if (sel == 1) {
                ## Linear model
                abline(model.lm,
                       col = input$model2_colorsel, lwd = input$model2_width,
                       lty = input$model2_linetype)
                model2 <- model.lm
            } else if (sel == 2) {
                ## Polynomial regression
                lines(polydata2$horsepower, polydata2$mpg,
                      col = input$model2_colorsel, lwd = input$model2_width,
                      lty = input$model2_linetype)
                model2 <- model2.lm3
            } else {
                ## Smooth spline
                lines(model.ss,
                      col = input$model2_colorsel, lwd = input$model2_width,
                      lty = input$model2_linetype)
                model2 <- model.ss
            }
            if (sel != 3) {
              output$model2_pred <- renderText({
                paste("Model 2 prediction:",
                      round(predict(model2,
                                    newdata = data.frame(horsepower = input$plot_horsepower))
                            ,digits = 2), "mpg")
              })
              points(input$plot_horsepower,
                     predict(model2, newdata = data.frame(horsepower = input$plot_horsepower)),
                     cex = 2, pch = 18, col = input$model2_colorsel)
            } else  {
                pred <- predict(model2,
                                newdata = data.frame(horsepower = input$plot_horsepower))
                pred <- pred$y[sum(pred$x < input$plot_horsepower)]
                output$model2_pred <- renderText({
                    paste("Model 2 prediction:",
                          round(pred ,digits = 2), "mpg")
                })
                points(input$plot_horsepower, pred, cex = 2, pch = 18,
                       col = input$model2_colorsel)
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
