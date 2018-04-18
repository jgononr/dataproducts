#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(

  # Application title
  titlePanel("Modelling Shiny App"),

  # Sidebar with a slider input for number of bins
  sidebarLayout(position = "right",
    sidebarPanel(
        navlistPanel(
            tabPanel("Model", "Content 1"),
            tabPanel("Panel 2", "Content 2"),
            tabPanel("Panel 3", "Content 3")
        )
    ),

    # Show a plot of the generated distribution
    mainPanel(
        tabsetPanel(
            tabPanel("Data", DT::dataTableOutput("dataset")),
            tabPanel("Plot", "Plot Panel Content")
        )
    )
  )
))
