#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#

library(shiny)

# Define UI for application that draws a histogram
navbarPage("Evolution des logements sur les île du Ponant",
    
    #theme=shinytheme("journal"),

    #logo ubs
    img(src="logo_ubs.png", width="100"),
    
    # Premier onglet
    tabPanel("Page Graphique",

      # Sidebar with a slider input for number of bins
      sidebarLayout(
          sidebarPanel(
            
              # Liste déroulante des îles
              selectInput("choix_ile",
                          "Choix des iles du Ponant:",
                          choices = df_final$Ile,
                          multiple=TRUE),
              
              # Boutons pour l'analyse des indicateurs
              radioButtons("choix_indicateur",
                           "Choix de l'indicateur",
                           choices = c("Nb d'habitants ",
                                       "Taux de résidendes secondaires ",
                                       "Prix médian du bâti au m2 "))
          ),
  
          # Show a plot of the generated distribution
          mainPanel(
              plotOutput("plot_ponant"),
              plotOutput("bar_ponant")
          )
        
    ) 
  ),
    
    # Deuxième onglet
    tabPanel("A propos",
             # Texte statique en HTML
             br(),
             "Ceci est une mini-application ", strong("Shiny"),
             " basée sur les données", em("Allociné"))
)
