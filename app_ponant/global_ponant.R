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



# IMPORTATION---------------------

## Importation fichier csv----------------
df_ponant<- read_excel("app_ponant/data/Data_Ponant.xlsx")

glimpse(df_ponant)

df_nettoyer <- df_ponant %>% 
  select(-c("Nom commune")) %>%  # suppression de la colonne Nom commune
  filter(Ile!="Locmaria" & Ile!="Le Palais" & Ile!="Sauzon"& Ile!="Bangor") %>%  # retrait des îles qui font partie de l'archipel Belle-île en Mer
  mutate(`Prix médian du bâti au m2 (2023)` = as.numeric(`Prix médian du bâti au m2 (2023)`)) # mettre les valeurs en numeric




glimpse(df_nettoyer)

df_final<-df_nettoyer %>% 
  pivot_longer(cols=! "Ile", 
               names_to="Tout",
               values_to="Nombre") %>% # Rautation de la table (colonne en variable et variable en colonne)
  separate(Tout, into = c("Tout", "Date"), sep = "\\(") %>%  #  Création d'une colonne Date
  mutate(Date = as.numeric(str_remove(Date, "\\)")))
  


  


