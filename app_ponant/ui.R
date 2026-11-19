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

   
    img(src="logo_ponant.png", width="140"),
    
    header = tagList(
      tags$head(
        tags$style(HTML("
        .navbar {
          position: relative;
        }
        .logo-ubs-coin { #Positionnement du logo Ubs
          position: absolute;
          right: 20px;
          top: 8px;
          z-index: 1000;
        }
      "))
      ),
      img(src = "logo_ubs1.png", width = "60", class = "logo-ubs-coin") 
    ),
    
    # Premier onglet
    tabPanel("À propos",
           fluidPage(
             # En-tête avec le logo et le titre 
             div(
               style = "display: flex; align-items: center; gap: 20px; margin-bottom: 20px;",
               img(src = "photo_port2.jpg", width = "230"), 
               h3("Bienvenue sur l'espace des Îles du Ponant !", style = "margin: 0; font-weight: bold;")
             ),
             
             p("Vous vous êtes déjà demandé comment évoluent l'immobilier et la population sur nos îles ? Ce site est là pour y répondre !"),
             p("Pensée autour de données open-data officielles de l'INSEE, cette application interactive vous emmène à la découverte des Îles du Ponant. L'objectif est simple : vous offrir une vision claire et visuelle de la façon dont ces territoires insulaires se développent et changent au fil du temps."),
             
             br(),
             
             
             h3("Qu'est-ce qu'on peut y faire ?"),
             tags$ul(
               tags$li(tags$b("Explorer 3 indicateurs clés :"), " Plongez dans les chiffres de la démographie (nombre d'habitants), de l'habitat (taux de résidences secondaires) et du marché immobilier (prix au mètre carré)."),
               tags$li(tags$b("Mener vos propres comparatifs :"), " Sélectionnez une ou plusieurs îles pour observer leurs courbes d'évolution au fil des années, ou comparez-les directement sur l'année la plus récente grâce à des graphiques dynamiques. (Petite précision : les différentes communes de Belle-Île ont été regroupées pour n'afficher qu'un seul total global)."),
               tags$li(tags$b("Naviguer en un clin d'œil :"), " Besoin de situer géographiquement ces îles ? Un onglet cartographique interactif est également à votre disposition pour explorer la zone.")
             ),
             
             br(),
             
             img(
               src = "decouverte-iles-ponant.jpg", 
               width = "270",
               style = "float: right; margin-left: 25px; margin-bottom: 15px; border-radius: 8px;"
             ),
             
             h3("C'est quoi les Îles du Ponant ?"),
             
             div(
               style = "display: flex; align-items: flex-start; gap: 20px;",
               
               p(
                 "Les ", strong("îles du Ponant"), " désignent un ensemble de ",
                 em("15 îles"), " et archipels français habités en permanence, situés le long de la façade ",
                 strong("ouest"), " de la France, de la Manche à l’océan Atlantique. Le mot ",
                 em("« Ponant »"), " vient de l'ancien français et signifie le ",
                 em("« couchant »"), " (l'Ouest).",
                 br(), br(),
                 "Ces territoires insulaires se distinguent par leur identité ", em("maritime forte, "),
                 "façonnée par l'océan, et par des écosystèmes fragiles mais précieux. ",
                 "Habiter le Ponant, c'est vivre au rythme des marées, du vent et de l'insularité, ",
                 "tout en relevant le défi de la gestion durable d'un patrimoine naturel et culturel unique.",
                 br(), br(),
                 "La gestion du logement y est particulièrement ", strong("complexe"), ", équilibrant les besoins ",
                 "des résidents à l'année, le tourisme saisonnier et la préservation de l'espace littoral, ",
                 "faisant de ces îles des observatoires privilégiés pour ", strong("l'aménagement du territoire.")
               )
             ),
             
             br(),
             h3("Auteurs :"),
             p("NGUYEN Phuong-vy"),
             p("BOSSER Clarence"),
             
             br(),
             p(em("Bonne exploration de nos îles ! ⛵"))
           )
  ),
  
    # Deuxième onglet
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
            
              uiOutput("boxes_ponant"), #Box évollution des indicateur
              
              br(),
              
              plotlyOutput("plot_ponant"),
              
              hr(),
              
              tabsetPanel(
                tabPanel("Graphique en barres", plotlyOutput("bar_ponant")),
                tabPanel("Graphique empilé", plotlyOutput("stacked_ponant"))
              )
          )
        
    ) 
  ),
  
  # Troisième onglet
  tabPanel("Carte",
           leafletOutput("mymap"),
           p()
  )
)
