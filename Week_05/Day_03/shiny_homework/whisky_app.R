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
      tags$h2("Whisky Information"),
      p(strong("Types of Whisky")),
      radioButtons(inputId = "region_input",
                   label = strong("Whisky Region"),
                   choices = all_regions
                   ),
      
      selectInput(inputId = "distillery_input",
                  label = strong("Whisky Distillery"),
                  choices = all_distilleries
                  ),
      
      dateRangeInput(inputId = "year_input",
                     label = strong("Year Distillery Founded"),
                     format = "yyyy",
                     min = 1600,
                     max = 2022)
    ),
    
    mainPanel = mainPanel(
      br(),
      plotOutput("whisky_plot"),
      br(),
      plotOutput("year_plot"),
      
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
      scale_y_continuous(expand = c(0, 0)) +
      scale_y_continuous(limits = c(0, 4)) +
      theme(axis.text.x = element_text(angle = 45, vjust = 1, hjust=1, size = 14),
            axis.text.y = element_text(size = 14),
            axis.title.x = element_text(size = 20),
            axis.title.y = element_text(size = 20),
            legend.title = element_text(size = 20),
            legend.text = element_text(size = 14),
            plot.title = element_text(size = 48)) +
      labs(x = "Notes",
           y = "Score",
           fill = "Whisky Region",
           title = "Scotch Whisky Tasting Notes\n")
  })

  output$year_plot <- renderPlot({
    whisky %>%
      group_by(owner) %>% 
      mutate(count = n()/12) %>% 
      ungroup() %>% 
      filter(count > 1) %>%
      filter(year_found == input$year_input) %>% 
      ggplot(aes(x = year_found,
                 y = capacity,
                 colour = owner)) +
      geom_point(aes(shape = region)) +
      theme(axis.text.x = element_text(size = 14),
            axis.text.y = element_text(size = 14),
            axis.title.x = element_text(size = 20),
            axis.title.y = element_text(size = 20),
            legend.title = element_text(size = 20),
            legend.text = element_text(size = 14),
            plot.title = element_text(size = 48)) +
      scale_y_continuous(labels = scales::comma) +
      labs(x = "Year Founded",
           y = "Capacity",
           colour = "Distillery Owner",
           title = "Distillery Capacity by Year Founed\n")
  })
}

# Run the application 
shinyApp(ui = ui, server = server)
