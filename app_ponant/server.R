library(shiny)
library(ggplot2)
library(dplyr)

function(input, output, session) {
  
  perimetre <- reactive({
    df_final %>% 
      filter(Ile %in% input$choix_ile & Tout == input$choix_indicateur)
  })
  

  output$plot_ponant <- renderPlot({
    perimetre() %>% 
      ggplot(aes(x = Date, y = Nombre, colour = Ile)) +
      geom_line() +
      geom_point()+
      labs( # Titres, sous-titres
        title = "Répartition des films selon le **genre**", # Genre en gras
        subtitle = "*Toutes nationalités* confondues",
        y = "",
        x = "Nombre de films"
      )+
      theme_classic()
  })
  
  output$bar_ponant <- renderPlot({
    perimetre() %>% 
      group_by(Ile) %>%                
      arrange(desc(Date)) %>%
      slice_head(n = 1) %>%
      ungroup() %>% 
      ggplot(aes(x = Ile, y = Nombre, fill = Ile)) +
      geom_col()+
      theme_classic()
  
  })
  
}