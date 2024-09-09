# Haiti_rural-socioeconomics
Shiny app tool for visualizing and exploring socio-economic and geographical data of rural sections summarized by commune in Haiti. By Patrick Prezeau Stephenson and Jean Francois Tardieu.
# Haiti Rural Sections Insights Shiny App

## Overview

The **Haiti Rural Sections socioeconomics** Shiny app is an interactive tool for visualizing and exploring socio-economic and geographical data of rural sections in Haiti. The app provides insights into variables such as population density, poverty rates, and access to essential services like schools and health centers. The app is built using `R` and `Shiny` and includes interactive maps, bar plots, correlation heatmaps, and a table for exploring the data.

## Features

- **Department and Commune Filtering**: Filter data by Department and Commune with the option to display all sections.
- **Interactive Map**: A Leaflet map showing the geographical location of rural sections color-coded by selected socio-economic variables.
- **Dynamic Bar Plots**: Visualize selected socio-economic variables for each rural section.
- **Summary Table**: Displays filtered data based on selected department, commune, and socio-economic variables.
- **Correlation Heatmap**: Shows correlations between various socio-economic indicators.
- **Data Download**: Download the filtered data as a CSV file for further analysis.

## Data

The dataset `sections_geocoded.csv` contains information about Haiti’s rural sections, including variables like population density, poverty percentage, and access to services. The key columns are:

- **DEPARTEMENT**: Department of the rural section.
- **COMMUNE**: Commune of the rural section.
- **DANSI2021**: Population density in 2021.
- **PC_POV**: Poverty percentage.
- **VALUE_US**:Livestock Value per capita (US $).
- **PC_3kmSant**: Percentage of population within 3 km of a health center.
- **PC_3kmLekol**: Percentage of population within 3 km of a school.
- **latitude** and **longitude**: Geographic coordinates of the rural sections.

- The original data 'seksyon_redui.csv' is more granular at the communal section level and was made graciously available by Jean Francois Tardieu (Quisqueya University).

## Getting Started

### Prerequisites

To run the app locally, ensure you have the following installed:

- **R**: (version 4.0 or later)
- **RStudio**: (optional, but recommended)
- The following R packages are required:
  - `shiny`
  - `leaflet`
  - `dplyr`
  - `ggplot2`
  - `corrplot`
  - `DT`

You can install the required packages by running:

```r
install.packages(c("shiny", "leaflet", "dplyr", "ggplot2", "corrplot", "DT"))
