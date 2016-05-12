library(shiny)
library(mapproj)
library(maps)
source('helpers.R')

counties<- readRDS('data/counties.rds')


shinyServer(function(input, output) {
    

  output$map<- renderPlot({
    data<- switch(input$var,
                  'Percent White'= counties$white,
                  'Percent Black'= counties$black,
                  'Percent Hispanic' = counties$hispanic,
                  'Percent Asian'= counties$asian)
    legend<- switch(input$var,
                    'Percent White'= '% White',
                    'Percent Black'= '% Black',
                    'Percent Hispanic' = '% Hispanic',
                    'Percent Asian'= '% Asian')
    
    percent_map(var = data,
                color = 'darkgreen',
                legend.title = legend,
                max= input$range[2],
                min = input$range[1])
  })
})

?switch
