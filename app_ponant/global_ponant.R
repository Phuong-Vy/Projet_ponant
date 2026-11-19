# PACKAGES---------------------

library(tidyverse)
library(readr)     # Importation de données (tidyverse)
library(dplyr)     # Traitement de données (tidyverse)
library(readxl)    # Importation de fichier Excel (tidyverse)
library(forcats)   # Gestion de facteurs (tidyverse)
library(ggplot2)   # Visualisation graphique (tidyverse)
library(lubridate) # Gestion des dates (tidyverse)
library(ggiraph) # Dataviz interactive
library(ggtext) # Complément ggplot2
library(shinythemes)
library(plotly)
library(leaflet) #Carte interactive
library(tidygeocoder) #Permet de trouver la localisation d'un lieu
library(bslib)
library(bsicons)

# IMPORTATION---------------------

## Importation fichier csv----------------
df_ponant<- read_excel("app_ponant/data/Data_Ponant.xlsx")

glimpse(df_ponant)

#Pouur la la localisation
df_nettoye_v0 <- df_ponant %>% 
  mutate(`Nom commune` = ifelse(`Nom commune` == "Total Belle-île", "Belle-île", `Nom commune`))%>%
  filter(Ile!="Locmaria" & Ile!="Le Palais" & Ile!="Sauzon"& Ile!="Bangor") %>%  # retrait des îles qui font partie de l'archipel Belle-île en Mer
  mutate(`Prix médian du bâti au m2 (2023)` = as.numeric(`Prix médian du bâti au m2 (2023)`))  # mettre les valeurs en numeric


df_nettoye <- df_nettoye_v0 %>% 
  select(-c("Nom commune"))  # suppression de la colonne Nom commune

glimpse(df_nettoye)

df_final<-df_nettoye %>% 
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


df_compa <- df_final %>%
  group_by(Ile, Tout) %>%
  arrange(desc(Date), .by_group = TRUE) %>%
  mutate(
    val_precedente = lead(Nombre, n = 1), # valeur de la date juste avant
    date_precedente = lead(Date, n = 1),
    diff_abs = Nombre - val_precedente,
    diff_pct = ifelse(!is.na(val_precedente) & val_precedente != 0,
                      ((Nombre - val_precedente) / abs(val_precedente)) * 100,
                      NA_real_)
  ) %>%
  slice_head(n = 1) %>% # garde uniquement la date la plus récente par île et indicateur
  ungroup()

localisation <- df_nettoye_v0 %>%
  rename(lng = any_of(c("lng", "long"))) %>%
  geocode(address = `Nom commune`, method = 'osm', lat = lat, long = lng) %>%
  select(Ile, lat, lng)
