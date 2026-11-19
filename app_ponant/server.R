# PACKAGES---------------------

library(shiny)
library(ggplot2)
library(dplyr)

function(input, output, session) {
  
  perimetre <- eventReactive(input$go_button,{
    df_final %>% 
      filter(Ile %in% input$choix_ile & Tout == input$choix_indicateur) #Filtrage des paramètres choisis par l'utilisateur
  })
  
  # Périmètre précalculé pour les value_box (1 ligne par île et indicateur)
  kpi_perimetre <- eventReactive(input$go_button, {
    df_compa %>%
      filter(Ile %in% input$choix_ile & Tout == input$choix_indicateur)
  })
  
  # Value boxes au-dessus du line-graph
  output$boxes_ponant <- renderUI({
    req(kpi_perimetre())
    
    # Nom propre de l'indicateur (sans espace superflu à la fin)
    nom_indicateur <- trimws(isolate(input$choix_indicateur))
    
    # Nombre total d'îles retenues dans le périmètre actuel
    nb_iles_dispo <- kpi_perimetre() %>%
      filter(!is.na(diff_pct)) %>%
      nrow()
    
    kpi_df <- kpi_perimetre() %>%
      filter(!is.na(diff_pct)) %>%
      arrange(desc(abs(diff_pct))) %>%
      slice_head(n = 3)
    
    req(nrow(kpi_df) > 0)
    
    # Titre adaptatif selon s'il y a plus de 3 îles ou non
    titre_section <- if (nb_iles_dispo > 3) {
      paste0("Top 3 des îles présentant le plus de changement — ", nom_indicateur)
    } else {
      paste0("Îles présentant le plus de changement — ", nom_indicateur)
    }
    
    boxes <- lapply(seq_len(nrow(kpi_df)), function(i) {
      row <- kpi_df[i, ]
      
      est_positif <- !is.na(row$diff_abs) && row$diff_abs > 0
      est_negatif <- !is.na(row$diff_abs) && row$diff_abs < 0
      
      # Couleur de fond et icône selon hausse ou baisse
      theme_box <- if (est_positif) {
        value_box_theme(bg = "#198754", fg = "#ffffff") # Vert
      } else if (est_negatif) {
        value_box_theme(bg = "#dc3545", fg = "#ffffff") # Rouge
      } else {
        value_box_theme(bg = "#6c757d", fg = "#ffffff") # Gris neutre
      }
      
      icone_box <- if (est_positif) {
        bs_icon("graph-up-arrow")
      } else if (est_negatif) {
        bs_icon("graph-down-arrow")
      } else {
        bs_icon("dash-lg")
      }
      
      signe_abs <- ifelse(!is.na(row$diff_abs) && row$diff_abs >= 0, "+", "")
      signe_pct <- ifelse(!is.na(row$diff_pct) && row$diff_pct >= 0, "+", "")
      
      valeur_affichee <- format(round(row$Nombre, 2), big.mark = " ", decimal.mark = ",")
      abs_formate <- if (!is.na(row$diff_abs)) {
        paste0(signe_abs, format(round(row$diff_abs, 2), big.mark = " ", decimal.mark = ","))
      } else {
        "N/A"
      }
      pct_formate <- if (!is.na(row$diff_pct)) {
        paste0(signe_pct, format(round(row$diff_pct, 1), decimal.mark = ","), "%")
      } else {
        "N/A"
      }
      
      texte_delta <- paste0(pct_formate, " vs ", format(row$date_precedente))
      
      value_box(
        title = paste0(row$Ile),
        value = valeur_affichee,
        p(texte_delta),
        showcase = icone_box,
        theme = theme_box
      )
    })
    
    # C'est ce tagList qui manquait au retour !
    tagList(
      h4(
        titre_section,
        style = "font-weight: bold; margin-bottom: 12px;"
      ),
      layout_column_wrap(
        width = 1 / min(length(boxes), 3),
        fill = FALSE,
        !!!boxes
      )
    )
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