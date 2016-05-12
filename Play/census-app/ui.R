library(shiny)

shinyUI(fluidPage(
  titlePanel("Census Visualization"),
  
  sidebarLayout(
    sidebarPanel(
      helpText("Create demographic maps with 
               information from the 2010 US Census."),
      #var is the ID label for this widget and should be used as input$name in the server.R script
      selectInput("var", 
                  label = "Choose a variable to display",
                  choices = c("Percent White", "Percent Black",
                              "Percent Hispanic", "Percent Asian"),
                  selected = "Percent White"),
      #range is the ID label for this widget and should be used as input$name in the server.R script
      #slider is a range and therefore is stored as a vector of 2 values, those values change
      sliderInput("range", 
                  label = "Range of interest:",
                  min = 0, max = 100, value = c(0, 100))
      ),
    
    mainPanel(
      plotOutput('map')
    )
  )
))