library(shiny)

shinyUI(fluidPage(
  titlePanel(strong("My Shiny App")),
  sidebarLayout(
    sidebarPanel(h3(strong('Installation')),
                 ('Shiny is available on CRAN, so you can install it in the usual way from your R console:'),align='left',
                 br(),
                 code('install.packages("shiny")'),
                 br(),
                 br(),
                 br(),
      img(src = 'bigorb.png',width = 72, height =72),
      ('Shiny is a product of'),
      a(href= 'https://www.rstudio.com/','RStudio')),
    mainPanel(
      h2(strong('Introducing Shiny',align='left')),
      ('Shiny is a new package from RStudio that makes it'),
      em('incredibly easy'),
      'to build interactive web
       applications with R.',
      br(),
      br(),
      br(),
      ('For an introduction and live examples, visit the'),
      a(href= 'http://shiny.rstudio.com/','Shiny Homepage'),
      br(),
      br(),
      br(),
      br(),
      strong(h2('Features')),
      p('* Build useful web application with only a few lines of codee - no JavaScript required.'),
      p('* Shiny applications are auto live in the same way',strong('spreadsheets'),'are live')
    )
  )
))
