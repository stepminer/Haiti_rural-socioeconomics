#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(leaflet)
library(dplyr)
library(DT)
library(ggplot2)
library(corrplot)

# Load the data (replace this with your actual file path)


sektions_geocoded <- read.csv('sections_geocoded.csv')

# Define UI for the Shiny app
ui <- fluidPage(
  titlePanel("Haiti Rural Sections Insights"),
  sidebarLayout(
    sidebarPanel(
      selectInput("dept", "Select Department:", 
                  choices = c("All DEPARTEMENTS", unique(sektions_geocoded$DEPARTEMENT))),
      selectInput("commune", "Select Commune:", 
                  choices = c("All COMMUNES", unique(sektions_geocoded$COMMUNE))),
      selectInput("variable", "Select Socio-Economic Variable:",
                  choices = c("Population Density" = "DANSI2021",
                              "Poverty %" = "PC_POV",
                              "Livestock Value per capita (US $)" = "VALUE_US",
                              "Access to Health Center (%)" = "PC_3kmSant",
                              "Access to School (%)" = "PC_3kmLekol")),
      downloadButton("downloadData", "Download Filtered Data")
    ),
    mainPanel(
      leafletOutput("map"),
      plotOutput("barPlot"),
      dataTableOutput("summaryTable"),
      plotOutput("corrHeatmap")
    )
  )
)

# Define server logic for the app
server <- function(input, output, session) {
  
  # Reactive filter for the selected department and commune
  filtered_data <- reactive({
    data <- sektions_geocoded
    if (input$dept != "All DEPARTEMENTS") {
      data <- data %>% filter(DEPARTEMENT == input$dept)
    }
    if (input$commune != "All COMMUNES") {
      data <- data %>% filter(COMMUNE == input$commune)
    }
    data
  })
  
  # Render Leaflet map with color coding based on selected variable
  output$map <- renderLeaflet({
    data <- filtered_data()
    
    leaflet(data) %>%
      addTiles() %>%
      addCircleMarkers(~longitude, ~latitude,
                       color = ~colorFactor(topo.colors(5), data[[input$variable]])(data[[input$variable]]),
                       popup = ~paste0("Commune", COMMUNE, "<br>",
                                       "Value: ", data[[input$variable]])) %>%
      addLegend("bottomright", 
                pal = colorFactor(topo.colors(5), data[[input$variable]]),
                values = data[[input$variable]],
                title = input$variable)
  })
  
  # Render bar plot for selected variable
  output$barPlot <- renderPlot({
    data <- filtered_data()
    
    ggplot(data, aes_string(x = "COMMUNE", y = input$variable)) +
      geom_bar(stat = "identity", fill = "steelblue") +
      labs(x = "COMMUNE", y = input$variable, title = paste(input$variable, "COMMUNE")) +
      theme(axis.text.x = element_text(angle = 45, hjust = 1))
  })
  
  # Render data table for selected rural sections
  output$summaryTable <- renderDataTable({
    filtered_data() %>%
      select(DEPARTEMENT, COMMUNE, input$variable)
  })
  
  # Render correlation heatmap for selected variables
  output$corrHeatmap <- renderPlot({
    data <- filtered_data()
    
    corr_matrix <- data %>%
      select(DANSI2021, PC_POV, VALUE_US, PC_3kmSant, PC_3kmLekol) %>%
      cor(use = "complete.obs")
    
    corrplot(corr_matrix, method = "color", type = "upper", tl.col = "black", tl.srt = 45)
  })
  
  # Download handler for filtered data
  output$downloadData <- downloadHandler(
    filename = function() {
      paste("filtered_data_", input$dept, "_", input$commune, ".csv", sep = "")
    },
    content = function(file) {
      write.csv(filtered_data(), file)
    }
  )
}

# Run the Shiny app
shinyApp(ui = ui, server = server)

 