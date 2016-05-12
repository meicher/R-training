
library(shiny)
runExample('01_hello')

#ui.R controls layout/appearnaace of your app
#server.R script contains instructions that your computer needs to build the app.

#each app will need its own unique directory with both scripts inside it

#You can run a Shiny app by giving the name of its directory to the function runApp. 
#For example if your Shiny app is in a directory called my_app: runApp(directory path with folder name)


runApp('App-1',display.mode = 'showcase')

#sidebarLayout always takes 2 arguments: sidebarPanel and mainPanel
#advanced layout options:
# navbarPage gives your app a multi-page user-interface that includes a navigation bar
# fluidRow and column can build your layout up from a grid system

