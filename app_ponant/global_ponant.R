# PACKAGES---------------------

library(readr) # Importation de données (tidyverse)
library(dplyr) # Traitement de données (tidyverse)
library(readxl) # Importation de fichier Excel (tidyverse)
library(forcats) # Gestion de facteurs (tidyverse)
library(ggplot2) # Visualisation graphique (tidyverse)
library(lubridate) # Gestion des dates (tidyverse)

library(ggiraph) # Dataviz interactive
library(ggtext) # Complément ggplot2
library(tidyverse)
library(shinythemes)
library(plotly)
library(leaflet) #Carte interactive
library(tidygeocoder) #Permet de trouver la localisation d'un lieu


# IMPORTATION---------------------

## Importation fichier csv----------------
df_ponant<- read_excel("app_ponant/data/Data_Ponant.xlsx")

glimpse(df_ponant)

df_nettoyer <- df_ponant %>% 
  select(-c("Nom commune")) %>%  # suppression de la colonne Nom commune
  filter(Ile!="Locmaria" & Ile!="Le Palais" & Ile!="Sauzon"& Ile!="Bangor") %>%  # retrait des îles qui font partie de l'archipel Belle-île en Mer
  mutate(`Prix médian du bâti au m2 (2023)` = as.numeric(`Prix médian du bâti au m2 (2023)`))  # mettre les valeurs en numeric



glimpse(df_nettoyer)

df_final<-df_nettoyer %>% 
  pivot_longer(cols=! "Ile", 
               names_to="Tout",
               values_to="Nombre") %>% # Rautation de la table (colonne en variable et variable en colonne)
  separate(Tout, into = c("Tout", "Date"), sep = "\\(") %>%  #  Création d'une colonne Date
  mutate(Date = as.numeric(str_remove(Date, "\\)")))

df_final$Nombre <- round(df_final$Nombre , 4) #Arrondir les données
  
df_final$Tout <- ifelse(
  startsWith(df_final$Tout, "Prix médian"), #Change le nom des colonne pour correspondre au cahier des charges
  "Prix au mètre carré", 
  df_final$Tout
)  

localisation <- df_nettoyer %>%
  mutate(
  nom_pour_geocodage = case_when(
    Ile == "Aix" ~ "Île d'Aix, Charente-Maritime, France",
    Ile == "Batz" ~ "Île de Batz, Finistère, France",
    Ile == "Sein" ~ "Île de Sein, France",
    Ile == "Molène" ~ "Île de Molène, France",
    Ile == "Ouessant" ~ "Île d'Ouessant, France",
    Ile == "Groix" ~ "Île de Groix, France",
    Ile == "Hoëdic" ~ "Île d'Hoëdic, France",
    Ile == "Houat" ~ "Île de Houat, France",
    Ile == "Yeu" ~ "Île d'Yeu, France",
    Ile == "Bréhat" ~ "Île de Bréhat, France",
    TRUE ~ paste0(Ile, ", France") # Pour les autres (ex: Belle-île, etc.)
  ))%>%
  rename(long = any_of(c("lng", "long"))) %>%
  geocode(address = nom_pour_geocodage, method = 'osm', lat = lat, long = lng) %>%
  select(Ile, lat, lng)
