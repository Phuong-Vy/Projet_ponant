# PACKAGES---------------------

library(shiny)
library(ggplot2)
library(dplyr)

function(input, output, session) {
  
  perimetre <- eventReactive(input$go_button,{
    df_final %>% 
      filter(Ile %in% input$choix_ile & Tout == input$choix_indicateur) #Filtrage des paramètres choisis par l'utilisateur
  })
  
  #Creation des différentes courbe d'évolution en fonction de l'indicateur et de(s) ile(s) choisie
  output$plot_ponant <- renderPlot({
    perimetre() %>% 
      ggplot(aes(x = Date, y = Nombre, colour = Ile)) + 
      geom_line() +
      geom_point()+ #Ajoute un point à chaque date
      geom_text(
        aes(label = Nombre), 
        vjust = -1, size = 3
      )+
      labs( # Titres, sous-titres
        title = paste("Évolution du ", input$choix_indicateur," dans le temps"),
        y = paste(input$choix_indicateur),
        x = "Date"
      )+
      theme_classic()
  })
  
  #Graphique de comparaison des différentes iles en fonction des indicateurs
  output$bar_ponant <- renderPlot({
    perimetre() %>% 
      group_by(Ile) %>%                
      arrange(desc(Date)) %>% #Classe les dates de manière décroissante
      slice_head(n = 1) %>%
      ungroup() %>% 
      ggplot(aes(x = Ile, y = Nombre, fill = Ile)) + 
      geom_col()+
      labs( # Titres, sous-titres
        title = paste("Évolution du ", input$choix_indicateur," de l'année la plus résente"), 
        subtitle = "Comparaison entre île",
        y = paste(input$choix_indicateur),
        x = "Ile"
      )+
      theme_classic()
  
  })
  
}