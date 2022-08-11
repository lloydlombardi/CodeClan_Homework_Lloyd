#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(tidyverse)
library(bslib)
library(CodeClanData)
library(janitor)

whisky <- CodeClanData::whisky %>% clean_names()

whisky <- whisky %>% 
  pivot_longer(cols = body:floral,
               names_to = "notes",
               values_to = "score")

all_regions <- unique(whisky$region)

all_distilleries <- unique(whisky$distillery)

ui <- fluidPage(
  
  theme = bs_theme(bootswatch = "superhero"),
  
  titlePanel(tags$h1("Whisky Notes")),
  
  sidebarLayout(
    sidebarPanel = sidebarPanel(
      p(strong("Whisky Information")),
      p("Types of Whisky"),
      radioButtons(inputId = "region_input",
                   label = strong("Whisky Region"),
                   choices = all_regions
                   ),
      
      selectInput(inputId = "distillery_input",
                  label = strong("Whisky Distillery"),
                  choices = all_distilleries
                  )
    ),
    
    mainPanel = mainPanel(
      "Main Panel",
      br(),
      plotOutput("whisky_plot"),
      
      tags$a("The Whisky Association website", href = "https://www.scotch-whisky.org.uk/")
    )
  )
)
server <- function(input, output) {
  
  output$whisky_plot <- renderPlot({
    whisky %>%
      filter(distillery == input$distillery_input,
             region == input$region_input) %>% 
      ggplot(aes(x = notes,
                 y = score,
                 fill = region)) +
      geom_col() +
      scale_y_continuous(expand = c(0,0)) +
      scale_y_continuous(limits = c(0, 4)) +
      coord_flip() +
      labs(x = "Notes",
           y = "\nScore",
           fill = "Whisky Region")
  })
}

# Run the application 
shinyApp(ui = ui, server = server)
