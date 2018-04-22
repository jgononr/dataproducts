<style>
.small-code pre code {
  font-size: 1em;
}
.footer {
    color: black; background: #E8E8E8;
    position: fixed; top: 90%;
    text-align:center; width:100%;
}

</style>

Data Products Final Project: shinyapp
========================================================
author: Javier González Onrubia
date: April 2nd 2018
autosize: true


The App
========================================================
This app uses the `Auto` dataset from the `ISLR` package
to model the relationship between `horsepower` and `mpg`.

The app provides a web user interface that allows to:

- Select which data will belong to the training and
testing sets: first %, middle %, last %, or caret's
`createDataPartition()`
- Select 2 regression models to compare predictions from
3 of the available ones
- See the predicted values from the predictor for each
of the selected models

Code: Configuring the training and test sets (server.R)
========================================================
class: small-code

```r
library(ISLR)
sel <- 1
percent <- 75

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
range(rows)
```

```
[1]   1 294
```

Regression models
========================================================

The sidebar allows to select 2 models to compare from the
3 available ones: linear regression, polynomial and
smooth spline:

- Linear regression: A straight line that minimizes the
quadratic distances to the outcomes (mpg)
- Polynomial regression: An extension of the previous
one that uses n-th grade polynomials. The polynomial
degree can be customized
- Smoothing spline: A regression model that uses a smoothing
spline as its model. Degrees of freedom and number of knots
can be customized

Code: Regression models (excerpt on server.R)
========================================================
class: small-code

```r
df <- Auto[order(Auto$horsepower),]
## Plotting train set and testing set
plot(y = df[trainset(),]$mpg, x = df[trainset(),]$horsepower,
     ylim = c(0, max(Auto$mpg)), xlim = c(0, max(Auto$horsepower)),
     col = input$config_trainsetcolor,
     ylab = "Miles per Gallon", xlab = "Horsepower")
points(y = df[-trainset(),]$mpg, x = df[-trainset(),]$horsepower,
     col = input$config_testsetcolor)
## Code (excerpt) for model 1's linear model
if (input$model1_plot) {
    sel <- input$model1_modelsel
    if (sel == 1) {
        ## Linear model
        abline(model.lm, col = input$model1_colorsel, lwd = input$model1_width,
               lty = input$model1_linetype)
        model1 <- model.lm
    } else if (sel == 2)
##[...]
## Prediction for model 1 output to widget on UI
    output$model1_pred <- renderText({paste("Model 1 prediction:",
    round(pred ,digits = 2), "mpg")})
```
