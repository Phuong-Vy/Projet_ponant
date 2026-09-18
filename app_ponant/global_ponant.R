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


git config --global user.email "pvnguyen2607@gmail.com"

# IMPORTATION---------------------

## Importation fichier csv----------------
df_ponant<- read_excel("app_ponant/data/Data_Ponant.xlsx")

glimpse(df_ponant)

df_nettoyer <- df_ponant %>% 
  select(-c("Nom commune")) %>% 
  filter(Ile!="Locmaria" & Ile!="Le Palais" & Ile!="Sauzon"& Ile!="Bangor") %>%
  mutate(`Prix médian du bâti au m2 (2023)` = as.numeric(`Prix médian du bâti au m2 (2023)`))



glimpse(df_nettoyer)

df_final<-df_nettoyer %>% 
  pivot_longer(cols=! "Ile",
               names_to="Tout",
               values_to="Nombre") %>% 
  separate(Tout, into = c("Tout", "Date"), sep = "\\(") %>% 
  mutate(Date = str_remove(Date, "\\)")) %>% 
  pivot_wider(names_from = Tout, values_from =Nombre)