
shinyServer(function(input, output) {

    
  output$theplot<- renderPlot({
    heroplot(input$hero)
    
  })
  output$pickplot<- renderPlot({
    heroplot(input$hero,'pick')
  })
  
  
})
