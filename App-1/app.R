#### Shiny App for Exploring Manufacturing Activity in California ####

getwd()
#load packages -----------
#library(shiny)
library(shinythemes)
library(tidyverse)
library(sf)
library(leaflet)
library(DT)
library(knitr)
library(pals)
library(leaflegend)
library(readxl)


#Load files ---------

#Read in shapefiles for map
terrestrial_lyr<- st_read("Ter_hab_4_5.shp")
aquatic_lyr <- st_read("Aqu_hab_4_5.shp")
dacs <- st_read("535_dacs.shp")

#Read in data for data tables
manufacturers_data <- read_excel("facilities_shiny.xlsx")
chemical_data <- read_excel("chemical_data.xlsx")

#Read in facilities shapefile and create lat/long
facilities <- st_read("facilitylist.shp")

#This code creates longitude and latitude columns from the geometry information stored within the .shp.
coord <- 
  unlist(st_geometry(facilities)) %>% 
  matrix(ncol=2,byrow=TRUE) %>% 
  as_tibble() %>% 
  setNames(c("lon","lat"))

#This code binds the columns of coordinates to the facilities.
facilities <- bind_cols(facilities, coord)

#This chunk of code creates labels for polygons for the leaflet map
dac_label <- sprintf(
  "<h6>%s</h6>",
  dacs$ApprxLc) %>% 
  lapply(htmltools::HTML)

fac_lab <- sprintf(
  "<h6>%s</h6>",
  facilities$Prdct_C) %>% 
  lapply(htmltools::HTML)


#Create product category choices
prod_cat_choices <- c("Beauty, Personal Care, and Hygiene Products", "Building Products & Materials Used in Construction and Renovation", "Chemical Manufacturing", "Children's Products",
                      "Cleaning Products", "Electrical Equipment Manufacturing", "Food Packaging", "Household, School, and Workplace Furnishings", "Machinery Manufacturing", "Medical Equipment Manufacturing",
                      "Metal Manufacturing", "Miscellaneous Manufacturing", "Motor Vehicle Tires", "Paper Manufacturing", "Pharmaceuticals", "Plastics Product Manufacturing", "Textiles",
                      "Tobacco Manufacturing", "Transportation Manufacturing") 

#Change the projections of these datasets to match WGS84 projection for leaflet.
aquatic_lyr <- st_transform(aquatic_lyr, crs = "+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs")
terrestrial_lyr <- st_transform(terrestrial_lyr, crs = "+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs")
facilities <-st_transform(facilities, crs = "+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs")
dacs <-st_transform(dacs, crs = "+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs")

#set color palettes for maps.
aq5 <- colorFactor(c("#8c510a", "#35978f"), domain = aquatic_lyr$AqHabRank)
tr5 <- colorFactor(c("#fdb863", "#542788"), domain = terrestrial_lyr$TerrHabRan)
prod.cat <- colorFactor(polychrome(20), domain = facilities$Prdct_C)
dacs_col <- colorFactor(c("#c51b8a", "#1c9099"), domain = dacs$DAC_cat)

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
                          #Panel options for Product Categories
                          titlePanel("Product Category"),
                          #Instructions for reader
                          helpText("Explore potential product categories based on NAICS and SIC codes. See the 'Methods' tab for more information."),
                          fluidRow(column(8,
                                          #Select product categories to show on map
                                          radioButtons("products",
                                                       h4("Potential Product Categories"),
                                                       choices = c(prod_cat_choices),
                                                       selected = character(0)))),
                          hr(),
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
                          ))
                        ),
                        #Output interactive mapping
                        mainPanel(
                          h2("California Manufacturer Interactive Map", align = "center", style = "color:#00819D"),
                          leafletOutput("map", height = "800px"),
                          
                          hr(),
                          fluidRow(column(8,
                                          #This adds a tip to click on a facility to populate the table
                                          helpText("Click facility to populate table below with information about the facility")),
                                   column(width = 2, offset = 2, conditionalPanel(
                                     condition = "output.table_input"))),
                          br(),
                          fluidRow(
                            DT::dataTableOutput(outputId = "table_input")
                          )
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
             tabPanel(id = "chemicaltable", title = "Chemical Data Table", fluid = TRUE, icon=icon("flask"),
                      #Options for left-hand side bar:
                      sidebarLayout(
                        sidebarPanel(
                          width = 4,
                          titlePanel("Candidate Chemicals"),
                          helpText("Shows only chemicals that are on the Candidate Chemicals List"),
                          fluidRow(column(8,
                                          checkboxGroupInput("Candidate Chemicals",
                                                             label = "Candidate Chemicals",
                                                             choices = c("Yes", "No"))
                          )),
                          hr(),
                          titlePanel("Poly- and Perfluoroalkyl Substances (PFAS)"),
                          fluidRow(column(8,
                                          checkboxGroupInput("PFAS",
                                                             label = "PFAS",
                                                             choices = c("Yes", "No"))
                          ))
                        ),
                        mainPanel(
                          h2("Chemical Data Table", align = "center", style = "color:#00819D"),
                          DT::dataTableOutput("chemtable"), style = "font-size:80%",
                          downloadButton("download_chemdata", "Download filtered chemical data")
                        )
                      )),
             
             #Panel for tool instructions ----
             tabPanel(id = "howto", title = "About This Tool", fluid = TRUE, icon= icon("question"),
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
  
  #Reactive expression for manufacturing facilities product categories
  man_fac <- reactive({
    filter(facilities[facilities$Prdct_C %in% input$products, ])
  })
  
  #Reactive expression for the aquatic layer rank selected by the user
  aq_data <- reactive({
    filter(aquatic_lyr[aquatic_lyr$AqHabRank %in% input$aquatic, ])
  })
  
  #Reactive expression for the terrestrial layer rank selected by the user
  tr_data <- reactive({
    filter(terrestrial_lyr[terrestrial_lyr$TerrHabRan %in% input$terrestrial, ])
  })
  
  #Reactive expression for dacs layer selected by the user
  dac_data <- reactive({
    filter(dacs[dacs$DAC_cat %in% input$dacs, ])
  })
  
  #base map -- 
  mapbase <- reactive({
    leaflet(options = leafletOptions(minZoom = 5.5, maxZoom = 18)) %>%
      addTiles() %>% 
      setView(lat = 36.778259, lng = -119.417931, zoom = 6)
  })
  
  session$onFlushed(once = T, function() {
    
    #rendering map --
    output$map <- renderLeaflet({
      mapbase() %>% 
        addProviderTiles(providers$Stamen.Terrain) %>% 
        addPolygons(data = dacs,
                    fillColor= ~dacs_col(DAC_cat),
                    fillOpacity = 0.4,
                    color= "black",
                    weight=1,
                    group = "DACs",
                    label = dac_label,
                    labelOptions = labelOptions(
                      style = list("font-weight" = "normal",padding = "3px 8px"),
                      textsize = "15px",
                      direction = "auto")) %>% 
        addLegendFactor(position = "bottomright",
                        pal = dacs_col,
                        title = "DAC Type",
                        shape = "rect",
                        values = dacs$DAC_cat) %>% 
        addLegendFactor(position = "bottomright",
                        pal = aq5,
                        title = "Aquatic Rank",
                        shape = "rect",
                        values = aquatic_lyr$AqHabRank) %>% 
        addLegendFactor(position = "bottomright",
                        pal = tr5,
                        title = "Terrestrial Rank",
                        shape = "rect",
                        values = terrestrial_lyr$TerrHabRan)
    })
  })
  
  #Observe aquatic significant habitat filter changes
  observeEvent({input$aquatic
    input$terrestrial
    input$products}, {
      leafletProxy("map") %>% 
        clearShapes() %>% 
        addPolygons(data=aq_data(), 
                    fillColor= ~aq5(input$aquatic),
                    fillOpacity =.7,
                    color= NA) %>% 
        addPolygons(data=tr_data(),
                    fillColor= ~tr5(input$terrestrial),
                    fillOpacity =.7,
                    color= NA) %>% 
        addPolygons(data=dacs,
                    fillColor= ~dacs_col(DAC_cat),
                    fillOpacity = 0.4,
                    color = "#000000",
                    weight =1,
                    label = dac_label) %>% 
        addCircles(data = man_fac(),
                   color= ~prod.cat(input$products),
                   stroke = TRUE,
                   fillOpacity = 1,
                   weight = 5,
                   label = facilities$Prdct_C,
                   radius= 100)
    })
  
  
  # Table interface
  output$table_input=DT::renderDataTable({
    DT::datatable(filtered_chemical_data(), filter = "top", 
                   class = "cell-border stripe",
                   options = list(autoWidth = TRUE)
    )
  })
  
  # Update table on click event
  observeEvent(input$map_marker_click, {
    lat <- input$map_marker_click$lat
    lng <- input$map_marker_click$lng
    clicked_row <- facilities[facilites$lat == lat & facilities$lon == lng, ]
    if (nrow(clicked_row) > 0) {
      replaceData(proxy = "table_input", data = clicked_row, rownames = FALSE)
    }
  })
  
  
  #Define reactive data based on user inputs. Return full data set if no filters selected
  filtered_chemical_data <- reactive({
    if (is.null(chemical_data$"Candidate Chemical") && is.null(chemical_data$PFAS)){
      return(chemical_data)
    }
    #Apply filter to PFAS
    if ("Yes" %in% input$PFAS) {
      chemical_data <- chemical_data[chemical_data$PFAS != "No", ]
    } else if ("No" %in% input$PFAS) {
      chemical_data <- chemical_data[chemical_data$PFAS == "No", ]
    }
    
    #Apply filter for Candidate Chemicals
    if ("Yes" %in% input$'Candidate Chemicals') {
      chemical_data <- chemical_data[chemical_data$"Candidate Chemical" == "Yes", ]
    } else if ("No" %in% input$'Candidate Chemicals') {
      chemical_data <- chemical_data[chemical_data$"Candidate Chemical" == "No or unknown", ]
    }
    #Return filtered data set
    return(chemical_data)
  })
  
  #Render data table based on filtered chemical data
  output$chemtable <- DT::renderDataTable({
    DT::datatable(
      filtered_chemical_data(), filter = "top", 
      class = "cell-border stripe",
      options = list(autoWidth = TRUE)
    )
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
  
  #download chemical data
  output$download_chemdata <- downloadHandler(
    filename = function() {
      paste("candidate_chem_data_", Sys.Date(), ".csv", sep = "")
    },
    content = function(file) {
      #write filtered data to a CSV file
      write.csv(filtered_chemical_data(), file, row.names = FALSE)
    }
  )
  
  #Output text for "How to Use this Tool" markdown
  output$markdown <- renderUI({
    HTML(markdown::markdownToHTML(knit('how_to_use.Rmd', quiet = TRUE),fragment.only = T ))
  })
  
  #Output text for "About the Datasets" markdown
  output$markdown.about <- renderUI({
    HTML(markdown::markdownToHTML(knit("about_datasets.Rmd", quiet=T), fragment.only = T))
  })
  
  #Output text for "Methods" markdown
  output$markdown.methods <- renderUI({
    HTML(markdown::markdownToHTML(knit("methods.Rmd", quiet=T), fragment.only = T))
  })
  
  #Output text for "References" markdown
  output$markdown.references <- renderUI({
    HTML(markdown::markdownToHTML(knit("references.Rmd", quiet=T), fragment.only = T))
  })
  
}
# Run the application 
shinyApp(ui = ui, server = server)

