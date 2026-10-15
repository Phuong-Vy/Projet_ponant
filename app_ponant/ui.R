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
    
    theme=shinytheme("flatly"),

    #logo ubs
    img(src="logo_ubs.png", width="140"),
    img(src="logo_ponant.png", width="140"),
    
    # Premier onglet
    tabPanel("Page Graphique",

      # Sidebar with a slider input for number of bins
      sidebarLayout(
          sidebarPanel(
            style = "margin-top: 100px;",
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
                                       "Prix au mètre carré")),
              
              # Bouton pour déclencher la mise à jour
              actionButton(
                "go_button",
                "Appliquer",
                class = "btn-primary btn-lg"
              )
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
           #Titre
           h1("C'est quoi les Ile du Ponant ?", style = "font-size: 36px; font-weight: bold; margin-bottom: 25px;"),
           
           div(
             style = "display: flex; align-items: flex-start; gap: 20px;",
             
             
             # Image
             img(src = "ile_ponant.jpg", width = "200"),
             
             
             # Texte
             p(
               "Les ", strong("îles du Ponant"), " désignent un ensemble de ",
               em("15 îles"), " et archipels français habités en permanence, situés le long de la façade ",
               strong("ouest"), " de la France, de la Manche à l’océan Atlantique. Le mot ",
               em("« Ponant »"), " vient de l'ancien français et signifie le ",
               em("« couchant »"), " (l'Ouest).",
               br(),
               "Ces territoires insulaires se distinguent par leur identité ",em("maritime forte, "),
               "façonnée par l'océan, et par des écosystèmes fragiles mais précieux. ",
               "Habiter le Ponant, c'est vivre au rythme des marées, du vent et de l'insularité, ",
               "tout en relevant le défi de la gestion durable d'un patrimoine naturel et culturel unique.",
               br(),
                 "La gestion du logement y est particulièrement ",strong("complexe")," équilibrant les besoins ",
                 "des résidents à l'année, le tourisme saisonnier et la préservation de l'espace littoral, ",
                 "faisant de ces îles des observatoires privilégiés pour ",strong("l'aménagement du territoire.")
               
             )
           ),
           h3("Auteur:"),
           br(),
           p("NGUYEN Phuong-vy"),
           p("BOSSER Clarence")
  )
)
