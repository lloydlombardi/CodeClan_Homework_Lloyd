# read in packages --------------------------------------------------------

library(tidyverse)
library(shiny)
library(CodeClanData)
library(plotly)

# wrangling ---------------------------------------------------------------

games <- game_sales

all_ratings <- games %>% 
  distinct(rating) %>% 
  pull()

all_genres <- games %>% 
  distinct(genre) %>% 
  arrange(genre) %>% 
  pull()

min_year <- min(games$year_of_release)
max_year <- max(games$year_of_release)

plot_colour <- c("Blue" = "deepskyblue", "Pink" = "deeppink", "Green" = "chartreuse1")

point_shape <- c("Square" = "15", "Circle" = "16", "Triangle" = "17")



# ui ----------------------------------------------------------------------

ui <- fluidPage(
  
  sidebarLayout(
    
    sidebarPanel = sidebarPanel(
      
      titlePanel(tags$h1("Video Game Information")),
      
      br(),
      
      radioButtons(inputId = "rating_choice",
                   label = "Select a Rating",
                   choices =  all_ratings
      ),
      
      selectInput(inputId = "genre_choice",
                  label = "Choose a Genre",
                  choices =  all_genres
      ),
      
      sliderInput(inputId = "year_choice",
                  label = "Choose a Year",
                  min = min_year,
                  max = max_year,
                  value = c(min_year, max_year) 
      ),
      
      fluidRow(
        
        column(2,
               actionButton(inputId = "update_scatt",
                            label = "Update Scatter")
        ),
        
        column(2,
               actionButton(inputId = "update_line",
                            label = "Update Line")
        )
      )
    ),
    
    mainPanel = mainPanel(
      
      fluidRow(
        
        column(4,
               radioButtons(inputId = "colour_choice",
                            label = "Select the point colour",
                            choices = plot_colour
               )
        ),
        
        column(4,
               radioButtons(inputId = "shape_choice",
                            label = "Select the point shape",
                            choices = point_shape
               )
        )
      ),
      
      tabsetPanel(
        
        tabPanel("Plots",
                 plotOutput("user_v_critic")
        ),
        
        tabPanel("Data",
                 DF::dataTableOutput
        )
      ),
      
      fluidRow(
        
        column(4,
               radioButtons(inputId = "",
                            label = "",
                            choices = 
               )
        ),
        
        column(4,
               selectInput(inputId = "",
                           label = "",
                           choices = 
               )
        )
      ),
      
      plotOutput()
      
    )
  )
)


# server ------------------------------------------------------------------

server <- function(input, output) {
  
}


# run app -----------------------------------------------------------------

shinyApp(ui = ui, server = server)