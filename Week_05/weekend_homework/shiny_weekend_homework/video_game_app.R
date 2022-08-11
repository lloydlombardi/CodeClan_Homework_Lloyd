# read in packages --------------------------------------------------------

library(tidyverse)
library(shiny)
library(CodeClanData)
library(plotly)
library(bslib)

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

all_publishers <- games %>% 
  distinct(publisher) %>% 
  arrange(publisher) %>% 
  pull()

# ui ----------------------------------------------------------------------

ui <- fluidPage(
  
  theme = bs_theme(bootswatch = "superhero"),
  
  sidebarLayout(
    
    sidebarPanel = sidebarPanel(
      
      titlePanel(tags$h1("Video Game Information")),
      
      br(),
      
      radioButtons(inputId = "rating_choice",
                   label = tags$h2("Select a Rating"),
                   choices =  all_ratings
      ),
      
      selectInput(inputId = "genre_choice",
                  label = tags$h2("Choose a Genre"),
                  choices =  all_genres
      ),
      
      sliderInput(inputId = "year_choice",
                  label = tags$h2("Choose a Year"),
                  min = min_year,
                  max = max_year,
                  value = c(min_year, max_year),
                  sep = ""
      )
    ),
    
    mainPanel = mainPanel(
      
      fluidRow(
        
        column(4,
               radioButtons(inputId = "colour_choice",
                            label = tags$h4("Select the point colour"),
                            choices = plot_colour,
                            inline = TRUE
               )
        ),
        
        column(4,
               radioButtons(inputId = "shape_choice",
                            label = tags$h4("Select the point shape"),
                            choices = point_shape,
                            inline = TRUE
               )
        ),
        
        actionButton(inputId = "update_scatt",
                     label = "Update Chart")
      ),
      
      tabsetPanel(
        
        tabPanel("Plots",
                 plotOutput("user_v_critic")
        ),
        
        tabPanel("Data",
                 DT::dataTableOutput("table_output")
        )
      ),
      
      br(),
      
      fluidRow(
        
        column(4,
               radioButtons(inputId = "colour_choice_2",
                            label = tags$h4("Select the line colour"),
                            choices = plot_colour,
                            inline = TRUE
               )
        ),
        
        column(4,
               selectInput(inputId = "publisher_choice",
                           label = tags$h4("Choose the publisher"),
                           choices = all_publishers
               )
        ),
        
        actionButton(inputId = "update_line",
                     label = "Update Chart")
      ),
      
      plotOutput("year_v_sales")
      
    )
  )
)


# server ------------------------------------------------------------------

server <- function(input, output) {
  
  filtered_data_scatter <- reactive({
    games %>% 
      filter(rating == input$rating_choice,
             genre == input$genre_choice)
  })
  
  filtered_data_line <- reactive({
    games %>% 
      filter(year_of_release > input$year_choice[1] & year_of_release < input$year_choice[2])
  })
  
  output$user_v_critic <- renderPlot({
    filtered_data_scatter() %>% 
      ggplot(aes(x = user_score,
                 y = critic_score)) +
      geom_point(shape = as.integer(input$shape_choice), colour = input$colour_choice, show.legend = FALSE, size = 3) +
      labs(x = "User Score",
           y = "Critic Score",
           title = "The Relationship Between the User Score and Critic Score")
  })
  
  output$table_output <- DT::renderDataTable({
    filtered_data_scatter()
  })
  
  output$year_v_sales <- renderPlot({
    filtered_data_line() %>% 
      ggplot(aes(x = year_of_release,
                 y = sales)) +
      geom_line(colour = input$colour_choice_2, size = 1) +
      labs(x = "Year of Release",
           y = "Sales (%)",
           title = "Sales % vs Year of Release")
  })
  
}


# run app -----------------------------------------------------------------

shinyApp(ui = ui, server = server)
