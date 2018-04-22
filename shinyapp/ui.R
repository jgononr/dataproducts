#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(ISLR)

# Define UI for application that draws a histogram
shinyUI(fluidPage(

    # Application title
    titlePanel("Modelling Shiny App"),

    # Sidebar with a slider input for number of bins
    sidebarLayout(position = "right", fluid = FALSE,
        sidebarPanel(
            tabsetPanel(
                tabPanel("Model 1",
                         selectInput("model1_modelsel",
                                     label = "Model selection",
                                     choices = list(
                                         "Linear" = 1,
                                         "Polynomial" = 2,
                                         "Smooth spline" = 3),
                                     selected = 1
                         ),
                         h4("Regression parameters"),
                         conditionalPanel(
                             condition = "input.model1_modelsel == '1'",
                             helpText("There are no specific parameters",
                                      "for this model")
                         ),
                         conditionalPanel(
                             condition = "input.model1_modelsel == '2'",
                             helpText("Use the slider to select the polynomial",
                                      "degree. E.g. ",
                                      "'2' for quadratic, '3' for cubic..."),
                             sliderInput("model1_poly.degree",
                                         label = "Polynomial degree",
                                         min = 2, max = 10, value = 2)
                         ),
                         conditionalPanel(
                             condition = "input.model1_modelsel == '3'",
                             sliderInput("model_ss.df",
                                         label = "Degrees of Freedom",
                                         min = 1, max = 10, value = 5),
                             sliderInput("model_ss.nknots",
                                         label = "Number of knots",
                                         min = 1, max = 10, value = 5)
                         ),
                         h4("Plot options"),
                         helpText("Use these controls to specify the regression",
                                  "line color, line style and width."),
                         selectInput("model1_colorsel",
                                     label = "Model color",
                                     choices = list(
                                         "Blue" = "blue",
                                         "Red" = "red",
                                         "Green" = "green",
                                         "Yellow" = "yellow"
                                     ), selected = "red"),
                         sliderInput("model1_width",
                                     label = "Line width",
                                     min = 1, max = 10, value = 2),
                         selectInput("model1_linetype",
                                     label = "Line type",
                                     choices = list(
                                         "Solid" = "solid",
                                         "Dashed" = "dashed",
                                         "Dotted" = "dotted",
                                         "Dot-Dash" = "dotdash",
                                         "Long Dash" = "longdash",
                                         "2-dash" = "twodash"
                                     ),
                                     selected = "solid"),
                         checkboxInput("model1_plot", "Plot", value = TRUE)
                ),
                tabPanel("Model 2",
                         selectInput("model2_modelsel",
                                     label = "Model selection",
                                     choices = list(
                                         "Linear" = 1,
                                         "Polynomial" = 2,
                                         "Smooth spline" = 3),
                                     selected = 2
                         ),
                         h4("Regression parameters"),
                         conditionalPanel(
                             condition = "input.model2_modelsel == '1'",
                             helpText("There are no specific parameters",
                                      "for this model")
                         ),
                         conditionalPanel(
                             condition = "input.model2_modelsel == '2'",
                             helpText("Use the slider to select the polynomial",
                                      "degree. E.g. ",
                                      "'2' for quadratic, '3' for cubic..."),
                             sliderInput("model2_poly.degree",
                                         label = "Polynomial degree",
                                         min = 2, max = 10, value = 2)
                         ),
                         conditionalPanel(
                             condition = "input.model2_modelsel == '3'",
                             sliderInput("model_ss.df",
                                         label = "Degrees of Freedom",
                                         min = 1, max = 4, value = 2),
                             sliderInput("model_ss.nknots",
                                         label = "Number of knots",
                                         min = 1, max = 10, value = 5)
                         ),
                         h4("Plot options"),
                         helpText("Use these controls to specify the regression",
                                  "line color, line style and width."),
                         selectInput("model2_colorsel",
                                     label = "Model color",
                                     choices = list(
                                         "Blue" = "blue",
                                         "Red" = "red",
                                         "Green" = "green",
                                         "Yellow" = "yellow"
                                     ), selected= "green"),
                         sliderInput("model2_width",
                                     label = "Line width",
                                     min = 1, max = 10, value = 2),
                         selectInput("model2_linetype",
                                     label = "Line type",
                                     choices = list(
                                         "Solid" = "solid",
                                         "Dashed" = "dashed",
                                         "Dotted" = "dotted",
                                         "Dot-Dash" = "dotdash",
                                         "Long Dash" = "longdash",
                                         "2-dash" = "twodash"
                                     ),
                                     selected = "solid"),
                         checkboxInput("model2_plot", "Plot", value = TRUE)
                ),
                tabPanel("Configuration",
                    h4("Training set"),
                    helpText("Please select which part and percentage",
                             "of the available data in the dataset will be",
                             "used for model training"),
                    selectInput("config_trainsetselection",
                                label = "Set selection",
                                choices = list(
                                    "First % data" = 1,
                                    "Middle % data" = 2,
                                    "Last % data" = 3,
                                    "Random data" = 4),
                                selected = 4
                     ),
                    conditionalPanel(
                        condition = "input.config_trainsetselection == '1'",
                        helpText("The left-hand percentage (ordered by horsepower)",
                                 "of the data set will be used for regression",
                                 "model calculation")
                    ),
                    conditionalPanel(
                        condition = "input.config_trainsetselection == '2'",
                        helpText("A centered percentage (ordered by horsepower)",
                                 "of the data set will be used for regression",
                                 "model calculation")
                    ),
                    conditionalPanel(
                        condition = "input.config_trainsetselection == '3'",
                        helpText("The right-hand percentage (ordered by",
                                 "horsepower)",
                                 "of the data set will be used for regression",
                                 "model calculation")
                    ),
                    conditionalPanel(
                        condition = "input.config_trainsetselection == '4'",
                        helpText("A random percentage",
                                 "of the data set will be used for regression",
                                 "model calculation")
                    ),
                    sliderInput("config_trainsetpercent",
                              label = "Available data percentage",
                              min = 1, max = 99, value = 75),
                    selectInput("config_trainsetcolor",
                                label = "Training data color",
                                choices = list(
                                    "Black" = "black",
                                    "Blue" = "blue",
                                    "Red" = "red",
                                    "Green" = "green",
                                    "Yellow" = "yellow"),
                                selected = "black"
                    ),
                    h4("Test set"),
                    selectInput("config_testsetcolor",
                                label = "Test data color",
                                choices = list(
                                    "Black" = "black",
                                    "Blue" = "blue",
                                    "Red" = "red",
                                    "Green" = "green",
                                    "Yellow" = "yellow"),
                                selected = "blue"
                    )
                )
            )
        ),
        # Show a plot of the generated distribution
        mainPanel(
            tabsetPanel(
                tabPanel("Plot",
                         helpText("Use the sidebar to select and plot one",
                                  "of the three available models.",
                                  "The configuration tab allows you to select",
                                  "which data will be used for training the
                                  model and testing it"),
                         plotOutput("plot"),
                         helpText("Use the slider to show the predicted value",
                                  "for each selected model based on horsepower"),
                         sliderInput("plot_horsepower",
                                     label = "Horsepower",
                                     min = 50, max = 250, value = 50),
                         textOutput("model1_pred"),
                         textOutput("model2_pred")
                ),
                tabPanel("Data", DT::dataTableOutput("dataset"))
            )
        )
    )
))
