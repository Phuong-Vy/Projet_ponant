# Évolution des logements sur les îles du Ponant

Application web interactive développée avec **R Shiny** pour explorer l'évolution démographique et immobilière des îles du Ponant à partir de données inspirées de l'open-data INSEE.

## Fonctionnalités

- **À propos** : présentation du projet, des enjeux d'aménagement insulaire et des indicateurs suivis.
- **Page Graphique** :
  - Sélection d'une ou plusieurs îles et d'un indicateur (*Nb d'habitants*, *Taux de résidences secondaires*, *Prix au mètre carré*).
  - **Boîtes de variation (KPI)** : mise en avant des îles présentant les plus fortes évolutions par rapport à la période précédente.
  - **Graphiques interactifs (`plotly`)** : courbe d'évolution temporelle, graphique en barres sur la dernière année disponible et graphique empilé.
- **Carte** : visualisation géographique interactive des îles avec `leaflet` et `tidygeocoder`.

## Données

- Source : fichier Excel `app_ponant/data/Data_Ponant.xlsx`.
- Préparation (`global.R`) : nettoyage des données, regroupement des communes de Belle-Île en un total global, mise au format long (`tidyr::pivot_longer`), calcul des variations absolues et en pourcentage, et récupération des coordonnées géographiques.

## Structure du projet

```text
.
├── global.R              # Chargement des packages, import, nettoyage et préparation des données
├── ui.R                  # Interface utilisateur (navbarPage, onglets, contrôles)
├── server.R              # Logique réactive, KPI, graphiques plotly et carte leaflet
├── app_ponant/
│   └── data/
│       └── Data_Ponant.xlsx
└── www/                  # Logos et illustrations (logo_ponant.png, logo_ubs1.png, photos...)
