library(shiny)

shinyUI(fluidPage(
  titlePanel(h1(strong("Dota2 6.87 Metadata"))),
  
  sidebarLayout(
    sidebarPanel(
      
      #radioButtons('typegraph',
                   #label = h3('Graph Type'),
                   #choices = list('Single Hero' = 1,
                   #               'Multi Hero' = 2,
                   #               'Attribute Group By' = 3),
                   #selected = 1),
      img(src = 'voker.png',width = 260,height=135,style='float:middle'),
      selectInput("hero", 
                  label = "Choose a hero to display",
                  choices = unlist(lapply(dota$Hero, as.character)),
                  selected = "Abaddon"),
      
      
      
      
      
      br(),
      
      em('Data collected from '),
      a(href = 'http://www.dotabuff.com/',img(src='dbuff.png')),
      tags$style('.well {background-color:white;}')),
    
    mainPanel(
      plotOutput('theplot'),
      plotOutput('pickplot')
  )
)
))

