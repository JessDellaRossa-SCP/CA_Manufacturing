#### Shiny App for Exploring Manufacturing Activity in California ####

#load packages -----------
library(shiny)
library(shinythemes)

#Load files ---------





# Create User Interface -------
ui <- fluidPage(
  theme= shinytheme("lumen"),
  #App Title
  headerPanel(title= tags$a(href="https://dtsc.ca.gov/scp/", tags$img(src = "SCP_Logo.png", height= 98.5, width= 128, 
                                                                      style="float:left; margin-left: 5px; margin-right: 5px; margin-top: 5px; margin-bottom: 5px"))),
 
  #Interactive Map Panel -----
  #tabPanel("California Manufacturing Activity Interactive Map"),
    sidebarLayout(
    sidebarPanel(
      #Title of this section of the panel
      titlePanel("Desired Significant Habitat Ranking"),
      #Instructions for reader
      helpText("Explore California's aquatic and terrestrial significant habitats through filters. See the 'Significant Habitats' tab for more information"),
      fluidRow(column(5,
                      #Select which rank(s) to plot
      checkboxGroupInput("aquatic", 
                         h5("Aquatic Significant Habitat Rank"), 
                         choices = list("Rank 5" = 5,
                                        "Rank 4" = 4,
                                        "Rank 3" = 3,
                                        "Rank 2" = 2,
                                        "Rank 1" = 1,
                                        "Unranked" = 0),
                         selected = 5),
      checkboxGroupInput("terrestrial", 
                         h5("Terrestrial Significant Habitat Rank"), 
                         choices = list("Rank 5" = 5,
                                        "Rank 4" = 4,
                                        "Rank 3" = 3,
                                        "Rank 2" = 2,
                                        "Rank 1" = 1,
                                        "Unranked" = 0),
                         selected =5),
      ))),
    mainPanel(
      h2("California Manufacturing Activity Interactive Map", align = "center"),
      h5("by: Jessica DellaRossa & Elena Galkina", align = "center")
    )
  )
)


# Define server logic 
server <- function(input, output) {}

# Run the application 
shinyApp(ui = ui, server = server)

#  #Navigation Bar at the top:
#navbarPage("SCP Manufacturing Activity Map", shinytheme("lumen"),
           #tabPanel("Interactive Map", fluid = TRUE, icon = icon("compass")),