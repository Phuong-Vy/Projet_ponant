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
  output$plot_ponant <- renderPlotly({
    p <- perimetre() %>% 
        ggplot(aes(x = Date, y = Nombre, colour = Ile)) + 
        geom_line() +
        geom_point()+ #Ajoute un point à chaque date
        labs( # Titres, sous-titres
          title = paste("Évolution du ", input$choix_indicateur," dans le temps"),
          y = paste(input$choix_indicateur),
          x = "Date"
        )+
        theme_classic()+
        theme(
          plot.title = element_markdown(size = 14, hjust = 0.5))
    
    ggplotly(p)
  })
  
  #Graphique de comparaison des différentes iles en fonction des indicateurs
  output$bar_ponant <- renderPlotly({
    p <- perimetre() %>% 
        group_by(Ile) %>%                
        arrange(desc(Date)) %>% #Classe les dates de manière décroissante
        slice_head(n = 1) %>%
        ungroup() %>% 
        ggplot(aes(x = Ile, y = Nombre, fill = Ile,
                   text = paste0("Ile: ", Ile, "<br>Nombre total: ",Nombre))) + 
        geom_col()+
        labs( # Titres, sous-titres
          title = paste("Évolution du ", input$choix_indicateur," de l'année la plus résente"), 
          subtitle = "Comparaison entre île",
          y = paste(input$choix_indicateur),
          x = "Ile"
        )+
        theme_classic()+
        theme(
          plot.title = element_markdown(size = 14, hjust = 0.5), #titre centré
          plot.subtitle = element_markdown(size = 12, hjust = 0.5)) # Sous-titre centré
    
    ggplotly(p, tooltip ="text")
  })
  
  #Graphique de comparaison des différentes iles en fonction des indicateurs
  output$stacked_ponant <- renderPlotly({
    df_stack <- perimetre() %>% 
      group_by(Ile,Tout) %>% # Remplace 'Categorie' par ta vraie colonne de sous-groupes
      arrange(desc(Date)) %>% 
      slice_head(n = 1) %>%
      ungroup() %>% 
      group_by(Tout) %>%
      mutate(
        Total_bar = sum(Nombre),
        Pourcentage = round((Nombre / Total_bar) * 100, 1)
      ) %>%
      ungroup()
    
      p <- df_stack %>%
        mutate(Ile = reorder(Ile, Pourcentage)) %>%
        ggplot(aes(x = Tout, y = Nombre, fill = Ile,
                   text = paste0("Île : ", Ile, 
                                 "<br>Nombre : ", Nombre, 
                                 "<br>Part de l'île : ", Pourcentage, "%"))) + # fill gère l'empilement
        geom_col(position = "stack") +
        theme_minimal() +
        labs(title = paste("Graphique empilé des Île et la Catégorie : ",input$choix_indicateur),
             x = "Catégorie",
             y = "Nombre",
             fill = paste(input$choix_indicateur)) +
        theme_classic()+
        theme(
          plot.title = element_markdown(size = 14, hjust = 0.5), #titre centré
          plot.subtitle = element_markdown(size = 12, hjust = 0.5)) # Sous-titre centré
    
  ggplotly(p, tooltip = "text")
  })
  
  points <- eventReactive(input$recalc, {
    localisation
  }, ignoreNULL = FALSE)
  
  output$mymap <- renderLeaflet({
    leaflet(data = points()) %>%
      addTiles() %>%
      addMarkers(
        lng = ~lng, 
        lat = ~lat, 
        popup = ~Ile
      )
  })
  
}