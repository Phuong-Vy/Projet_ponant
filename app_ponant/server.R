library(shiny)
library(ggplot2)
library(dplyr)

function(input, output, session) {
  
  output$plot_ponant <- renderPlot({
    
    df_final %>% 
      filter(Ile == input$choix_ile & Tout == input$choix_indicateur) %>% 
      ggplot() +
      geom_line(aes(x = Date, y = Nombre)) # Remplacez 'Nombre' par le nom de votre colonne de valeurs
    
  })
  
}