#### Shiny App for Exploring Manufacturing Activity in California ####

rm(list = ls())
#load packages -----------
library(shiny)
library(shinythemes)
library(tidyverse)
library(sf)
library(rgdal)
library(ggspatial)
library(viridis)
library(leaflet)
library(DT)
library(knitr)
library(pals)
library(leaflegend)
library(readxl)


#Load files ---------
setwd("~/DTSC/Manufacturing_Projects/Manufacturing-SCP/App-1/app_data")

#Read in terrestrial and aquatic significant habitat data for ranks 4 & 5. 
terrestrial_lyr<- st_read("Ter_hab_4_5.shp")
aquatic_lyr <- st_read("Aqu_hab_4_5.shp")

#Read in data for data tables
manufacturers_data <- read_excel("facilities_shiny.xlsx")

#Create product category choices
prod_cat_choices <- c("Beauty, Personal Care, and Hygiene Products", "Building Products & Materials Used in Construction and Renovation", "Chemical Manufacturing", "Children's Products",
                      "Cleaning Products", "Electrical Equipment Manufacturing", "Food Packaging", "Household, School, and Workplace Furnishings", "Machinery Manufacturing", "Medical Equipment Manufacturing",
                      "Metal Manufacturing", "Miscellaneous Manufacturing", "Motor Vehicle Tires", "Paper Manufacturing", "Pharmaceuticals", "Plastics Product Manufacturing", "Textiles",
                      "Tobacco Manufacturing", "Transportation Manufacturing") 

#Change the projections of these datasets to match WGS84 projection for leaflet.
aquatic_lyr <- st_transform(aquatic_lyr, CRS("+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs"))
terrestrial_lyr <- st_transform(terrestrial_lyr, CRS("+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs"))


#set color palettes for maps.
aq5 <- colorFactor(c("#8c510a", "#35978f"), domain = aquatic_lyr$AqHabRank)
tr5 <- colorFactor(c("#fdb863", "#542788"), domain = terrestrial_lyr$TerrHabRan)


### Create User Interface -------
ui <- fluidPage(
  tags$div(tags$style(HTML( ".selectize-dropdown, .selectize-dropdown.form-control{z-index:10000;}"))),
  theme = shinytheme("flatly"),
  
  #Interactive Map Page ---- 
  navbarPage("California Manufacturing Activity Project",
             id = "home",
      tabPanel(id= "map", title = "Interactive Map", fluid = TRUE, icon = icon("compass"),
               #Options on left-hand side for map
               sidebarLayout(
                 sidebarPanel(
                   #Panel options for Significant Habitat Rankings
                   titlePanel("Significant Habitat Rankings"),
                   #Instructions for reader
                   helpText("Explore California's aquatic and terrestrial significant habitats through rank filters. See the 'About the Datasets' tab for more information."),
                   fluidRow(column(8,
                                   #Select which rank(s) to plot
                                   checkboxGroupInput("aquatic", 
                                                      h4("Aquatic Significant Habitat Rank"), 
                                                      choices = list("Rank 5" = 5,
                                                                     "Rank 4" = 4)),
                                   checkboxGroupInput("terrestrial", 
                                                      h4("Terrestrial Significant Habitat Rank"), 
                                                      choices = list("Rank 5" = 5,
                                                                     "Rank 4" = 4))
                                   )),
                   hr(),
                   #Panel options for Product Categories
                   titlePanel("Product Category"),
                   #Instructions for reader
                   helpText("Explore potential product categories based on NAICS and SIC codes. See the 'Methods' tab for more information."),
                   fluidRow(column(8,
                                   #Select product categories to show on map
                                   checkboxGroupInput("products", 
                                                      h4("Potential Product Categories"), 
                                                      choices = c(prod_cat_choices))
                   ))),
                 #Output interactive mapping
                 mainPanel(
                   h2("California Manufacturing Activity Interactive Map", align = "center", style = "color:#00819D"),
                   leafletOutput("map", height = "800px")
                   ))),
      
      #Panel for manufacturing data table ----
      tabPanel(id = "datatable", title = "Manufacturer Data Table", fluid = TRUE, icon=icon("table"),
               #Options for left-hand side bar
               sidebarLayout(
                 sidebarPanel(
                   width = 4,
                   titlePanel("California Manufacturers"),
                   helpText("Check Product Category box to see relevant manufacturers"),
                   fluidRow(column(8,
                                   checkboxGroupInput("ProductCategories",
                                                      label = "Product Categories",
                                                      choices = c(prod_cat_choices))
               ))),
               mainPanel(
                 h2("Manufacturer Data Table", align = "center", style = "color:#00819D"),
                 DT::dataTableOutput("mantable"), style = "font-size:80%",
                 downloadButton("download_mandata", "Download filtered data"))
               )),
      
      #Panel for chemical data table ----
      tabPanel(id = "chemicaltable", title = "Chemical Data Table", fluid = TRUE, icon=icon("flask")),
      
      #Panel for tool instructions ----
      tabPanel(id = "howto", title = "How to Use This Tool", fluid = TRUE, icon= icon("question"),
               fluidRow(column(6,
                               HTML("<title> How to Use This Tool </title>")),
                        uiOutput("markdown"))),
      
      #Panel describing datasets ----
      tabPanel(id = "about", title = "About the Datasets", fluid = TRUE, icon= icon("database"),
               fluidRow(column(6,
                               HTML("<title> About the Datasets </title>")),
                        uiOutput("markdown.about"))),
      
      #Panel describing project methods ----
      tabPanel(id = "methods", title = "Methods", fluid = TRUE, icon = icon("gear"),
               fluidRow(column(6,
                               HTML("<title> Methods </title>")),
                        uiOutput("markdown.methods"))),
      tabPanel(id = "references", title = "References", fluid= TRUE, icon = icon("circle-info"),
               fluidRow(column(6,
                               HTML("<title> References </title>")),
                        column(12,
                               #text
                               tags$div(HTML("<a href = 'https://dtsc.ca.gov/scp/'>
                               <img src= 'SCP_Logo.png' width = '128' height = '98.5'style=' margin-left: 5px; margin-right: 5px; margin-top: 5px; margin-bottom: 5px' /> </a>
                               <hr>"))),
                        uiOutput("markdown.references")))
      
))
      
# Define server logic 
server <- function(input, output, session) {
  
  #Reactive expression for the aquatic layer rank selected by the user
  aq_data <- reactive({
    filter(aquatic_lyr[aquatic_lyr$AqHabRank %in% input$aquatic, ])
  })
  
  #Reactive expression for the terrestrial layer rank selected by the user
  tr_data <- reactive({
    filter(terrestrial_lyr[terrestrial_lyr$TerrHabRan %in% input$terrestrial, ])
  })
  
  #base map -- 
  mapbase <- reactive({
    leaflet(options = leafletOptions(minZoom = 5.5, maxZoom = 18)) %>%
      addTiles() %>% 
      setView(lat = 36.778259, lng = -119.417931, zoom = 6)
    })

  #rendering map --
  output$map <- renderLeaflet({
    mapbase() %>% 
      addProviderTiles(providers$Stamen.Terrain, group = "Terrain")
    })
  
  #Observe aquatic significant habitat filter changes
  observeEvent({input$aquatic
    input$terrestrial}, {
    leafletProxy("map") %>% 
      clearShapes() %>% 
      addPolygons(data=aq_data(), 
                  fillColor= ~aq5(input$aquatic),
                  fillOpacity =.7,
                  color= NA) %>% 
      addPolygons(data=tr_data(),
                  fillColor= ~tr5(input$terrestrial),
                  fillOpacity =.7,
                  color= NA)
  })
  
  #manufacturer data check all
  filtered_manufacturers_data <- reactive({
    if("Check all" %in% input$ProductCategories) {
      filtered_manufacturers_data <- manufacturers_data
    } else {
      filtered_manufacturers_data <- manufacturers_data[manufacturers_data$"Product_Category" %in% input$ProductCategories, ]
    }
    return(filtered_manufacturers_data)
  })
  
  #Render manufacturer data table based on filtered data
  output$mantable <- DT::renderDataTable({
    DT::datatable(
      filtered_manufacturers_data(), filter = "top",
      class = "cell-border stripe",
      options = list(autoWidth = TRUE)
    )
  })
  
  #download manufacturer data
  output$download_mandata <- downloadHandler(
    filename = function() {
      paste("manufacturers_data_", Sys.Date(), ".csv", sep = "")
    },
    content = function(file) {
      #write filtered data to a CSV file
      write.csv(filtered_manufacturers_data(), file, row.names = FALSE)
    }
  )
  
  #Output text for "How to Use this Tool" markdown
  output$markdown <- renderUI({
    HTML(markdown::markdownToHTML(knit('how_to_use.rmd', quiet = TRUE),fragment.only = T ))
  })
  
  #Output text for "About the Datasets" markdown
  output$markdown.about <- renderUI({
    HTML(markdown::markdownToHTML(knit("about_datasets.rmd", quiet=T), fragment.only = T))
  })
  
  #Output text for "Methods" markdown
  output$markdown.methods <- renderUI({
    HTML(markdown::markdownToHTML(knit("methods.rmd", quiet=T), fragment.only = T))
  })
  
  #Output text for "References" markdown
  output$markdown.references <- renderUI({
    HTML(markdown::markdownToHTML(knit("references.rmd", quiet=T), fragment.only = T))
  })

}
# Run the application 
shinyApp(ui = ui, server = server)

