#### Shiny App for Exploring Manufacturing Activity in California ####

#load packages -----------
library(shiny)
library(shinythemes)

#Load files ---------





# Create User Interface -------
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
      )),
      hr(),
        #New panel for Product Categories
        titlePanel("Desired Potential Product Category"),
        #Instructions for reader
          helpText("Explore potential product categories based on NAICS and SIC codes. See the 'Product Categories' tab for more information"),
            fluidRow(column(8,
                      #Select product categories to show on map
                      checkboxGroupInput("products", 
                                        h5("Potential Product Categories"), 
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
      h2("California Manufacturing Activity Interactive Map", align = "center"),
      h5("by: Jessica DellaRossa & Elena Galkina", align = "center"),
      plotOutput(outputId = "ca_map")
    )
  )
)


# Define server logic 
server <- function(input, output, session) {
  output$ca_map <- renderPlot({
    
  })
  )
}

# Run the application 
shinyApp(ui = ui, server = server)

#  #Navigation Bar at the top:
#navbarPage("SCP Manufacturing Activity Map", shinytheme("lumen"),
           #tabPanel("Interactive Map", fluid = TRUE, icon = icon("compass")),