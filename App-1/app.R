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

#Load files ---------
setwd("~/DTSC/Manufacturing_Projects/Manufacturing-SCP/App-1/app_data")

#This reads in the .gdb and shows the layers so you know which layer to read in. In this case, it doesn't matter. But some other .gdb will have multiple layers.
aquatic.gdb <- st_read("ds2756.gdb")
st_layers("ds2756.gdb")

aquatic_lyr <- sf::st_read(dsn = "ds2756.gdb", layer = "ds2756")

terrestrial.gdb <- st_read("ds2721.gdb")
st_layers("ds2721.gdb")

terrestrial_lyr <- sf::st_read(dsn = "ds2721.gdb", layer = "ds2721")

#clear these out of your environment to take up less space
rm(terrestrial.gdb)
rm(aquatic.gdb)

#Read in the census tracts and the DACs from sb535. Create a subset shp of the sb535 DACs.
tracts <- st_read("CES4_Final_Shapefile.shp")
sb535_tracts <- read.csv("Sb535.tracts.csv")
subset_sb535 <- tracts %>% 
  filter(Tract %in% sb535_tracts$Census.Tract)

#this reads in the data set for tribal land within the sb535 gdb.
dacs <- st_read("SB535DACgdb_F_2022.gdb")
#this shows us the layers with their projections of the dataset
st_layers("SB535DACgdb_F_2022.gdb")

#create a spatial layer for tribal boundaries
tribal<- sf::st_read(dsn = "SB535DACgdb_F_2022.gdb", layer = "SB535tribalboundaries2022")

#This makes sure all of the datasets can speak with the leaflet basemap with the same projection and geometry. 
aquatic_lyr <- st_transform(aquatic_lyr, CRS("+proj=longlat +datum=WGS84"))
terrestrial_lyr <- st_transform(terrestrial_lyr, CRS("+proj=longlat +datum=WGS84"))
subset_sb535 <- st_transform(subset_sb535, CRS("+proj=longlat +datum=WGS84"))
tribal <- st_transform(tribal, CRS("+proj=longlat +datum=WGS84"))

#set color palettes for maps.
aq5 <- colorNumeric("viridis", domain = aquatic_lyr$AqHabRank)
tr5 <- colorNumeric("magma", domain = aquatic_lyr$TerrHabRank)
tribe_col <- colorFactor("#de2d26", domain=tribal$GEOID)
dacs_col <- colorFactor("#006837", domain = subset_sb535$Tract)

#labels for polygons
dac_label <- sprintf(
  "<h2>%s</h2>",
  subset_sb535$ApproxLoc) %>% 
  lapply(htmltools::HTML)

tribal_label <- sprintf(
  "<h2>%s</h2>",
  tribal$Name) %>% 
  lapply(htmltools::HTML)


### Create User Interface -------
ui <- fluidPage(
  theme= shinytheme("simplex"),
  #App Title
  headerPanel(title= tags$a(href="https://dtsc.ca.gov/scp/", tags$img(src = "SCP_Logo.png", height= 98.5, width= 128, 
                                                                      style="float:left; margin-left: 5px; margin-right: 5px; margin-top: 5px; margin-bottom: 5px"))),
 
  #Interactive Map Panel -----
  #tabPanel("California Manufacturing Activity Interactive Map"),
    sidebarLayout((
      sidebarPanel(
        #Title of this section of the panel
        titlePanel("Desired Significant Habitat Ranking"),
        #Instructions for reader
          helpText("Explore California's aquatic and terrestrial significant habitats through filters. See the 'Significant Habitats' tab for more information"),
            fluidRow(column(7,
                      #Select which rank(s) to plot
                      checkboxGroupInput("aquatic", 
                                         h4("Aquatic Significant Habitat Rank"), 
                                         choices = list("Rank 5" = 5,
                                                        "Rank 4" = 4,
                                                        "Rank 3" = 3,
                                                        "Rank 2" = 2,
                                                        "Rank 1" = 1,
                                                        "Unranked" = 0),
                                         selected = 5),
                      checkboxGroupInput("terrestrial", 
                                         h4("Terrestrial Significant Habitat Rank"), 
                                         choices = list("Rank 5" = 5,
                                                        "Rank 4" = 4,
                                                        "Rank 3" = 3,
                                                        "Rank 2" = 2,
                                                        "Rank 1" = 1,
                                                        "Unranked" = 0),
                                         selected =5),
      )),
      hr(),
        #New panel for Product Categories
        titlePanel("Desired Potential Product Category"),
        #Instructions for reader
          helpText("Explore potential product categories based on NAICS and SIC codes. See the 'Product Categories' tab for more information"),
            fluidRow(column(8,
                      #Select product categories to show on map
                      checkboxGroupInput("products", 
                                        h4("Potential Product Categories"), 
                                        choices = list("Beauty, Personal Care, and Hygiene Products" = 0,
                                                       "Building Products & Materials Used in Construction and Renovation" = 0,
                                                       "Chemical Manufacturing" = 0,
                                                       "Children's Products" = 0,
                                                       "Cleaning Products" = 0,
                                                       "Electrical Equipment Manufacturing" = 0,
                                                       "Food Packaging" = 0,
                                                       "Household, School, and Workplace Furnishings" = 1,
                                                       "Machinery Manufacturing" = 0,
                                                       "Medical Equipment Manufacturing" = 0,
                                                       "Metal Manufacturing" = 0,
                                                       "Motor Vehicle Tires" = 0,
                                                       "Paper Manufacturing" = 0,
                                                       "Plastics Product Manufacturing" = 0,
                                                       "Textiles" = 0,
                                                       "Tires" = 0,
                                                       "Transportation Manufacturing" = 0),
                                                       selected = 1),
                      )))),
      #Output interactive mapping
    mainPanel( 
      h2("California Manufacturing Activity Interactive Map", align = "center", style = "color:#00819D"),
      h5("by: Jessica DellaRossa & Elena Galkina", align = "center")),
  )
)


# Define server logic 
server <- function(input, output) {}

# Run the application 
shinyApp(ui = ui, server = server)

#  #Navigation Bar at the top:
#navbarPage("SCP Manufacturing Activity Map", shinytheme("lumen"),
           #tabPanel("Interactive Map", fluid = TRUE, icon = icon("compass")),