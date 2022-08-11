
# packages ----------------------------------------------------------------

library(shiny)
library(tidyverse)
library(bslib)
library(CodeClanData)
library(janitor)
library(plotly)
library(shinyWidgets)


# wrangling ---------------------------------------------------------------

whisky <- CodeClanData::whisky %>% clean_names()

whisky <- whisky %>% 
  pivot_longer(cols = body:floral,
               names_to = "notes",
               values_to = "score")

all_regions <- unique(whisky$region)

all_distilleries <- unique(whisky$distillery)

min_year <- min(whisky$year_found)
max_year <- max(whisky$year_found)



# ui ----------------------------------------------------------------------

ui <- fluidPage(
  
  theme = bs_theme(bootswatch = "superhero"),
  
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
      
      numericRangeInput(inputId = "year_input",
                        label = strong("Year Distillery Founded"),
                        value = c(min_year, max_year)),
      
      titlePanel(tags$h1("Whisky Notes"))
    ),
    
    mainPanel = mainPanel(
      
      br(),
      
      plotOutput("whisky_plot"),
      
      br(),
      
      plotOutput("year_plot"),
      
      
      # verbatimTextOutput("info"),
      # 
      # plotOutput("info", hover = "year_input"),
      
      tags$a("The Whisky Association website", href = "https://www.scotch-whisky.org.uk/")
    )
  )
)



# server ------------------------------------------------------------------

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
            axis.title.x = element_text(size = 16),
            axis.title.y = element_text(size = 16),
            legend.title = element_text(size = 16),
            legend.text = element_text(size = 14),
            plot.title = element_text(size = 32)) +
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
      filter(year_found > input$year_input[1] & year_found < input$year_input[2]) %>% 
      ggplot(aes(x = year_found,
                 y = capacity,
                 colour = owner)) +
      geom_point(aes(shape = region), size = 3) +
      theme(axis.text.x = element_text(size = 14),
            axis.text.y = element_text(size = 14),
            axis.title.x = element_text(size = 16),
            axis.title.y = element_text(size = 16),
            legend.title = element_text(size = 16),
            legend.text = element_text(size = 14),
            plot.title = element_text(size = 32)) +
      scale_y_continuous(labels = scales::comma) +
      labs(x = "Year Founded",
           y = "Capacity",
           colour = "Distillery Owner",
           title = "Distillery Capacity by Year Founed\n",
           shape = "Region")
  })
  
  # output$info <- renderPrint({
  #   
  #   nearPoints(year_plot, input$year_input, xvar = "Year Founded", yvar = "Capacity")
    
  # })
}


# run ---------------------------------------------------------------------

# Run the application 
shinyApp(ui = ui, server = server)
