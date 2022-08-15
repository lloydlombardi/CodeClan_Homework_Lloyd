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


plot_choice <- c("Bar", "Horizontal Bar")

# ui ----------------------------------------------------------------------

ui <- fluidPage(
  
  theme = bs_theme(bootswatch = "superhero"),
  
  sidebarLayout(
    
    sidebarPanel = sidebarPanel(
      
      titlePanel(tags$h1("Video Games")),
      
      titlePanel(tags$h2("Scatter Plot Settings")),
      
      radioButtons(inputId = "rating_choice",
                   label = tags$h3("Rating"),
                   choices =  all_ratings,
                   inline = TRUE
      ),
      
      selectInput(inputId = "genre_choice",
                  label = tags$h3("Genre"),
                  choices =  all_genres
      ),
      
      br(),
      
      titlePanel(tags$h2("Bar Graph Settings")),
      
      sliderInput(inputId = "year_choice",
                  label = tags$h3("Year Released"),
                  min = min_year,
                  max = max_year,
                  value = c(min_year, max_year),
                  sep = ""
      ),
      
      selectInput(inputId = "publisher_choice",
                  label = tags$h4("Choose the publisher"),
                  choices = all_publishers
      ),
      
      numericInput(inputId = "number_input",
                   label = tags$h4("Video Game Fund ($)"),
                   value = 10000
      ),
      
      actionButton(inputId = "donate_button",
                   label = "Click to donate $100"
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
                     label = "Update Scatter Chart")
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
               radioButtons(inputId = "bar_choice",
                            label = tags$h4("Select the type of bar chart"),
                            choices = plot_choice,
                            inline = TRUE
               )
        ),
        
        actionButton(inputId = "update_line",
                     label = "Update Bar Chart")
      ),
      
      plotOutput("year_v_sales")
      
    )
  )
)


# server ------------------------------------------------------------------

server <- function(input, output, session) {
  
  filtered_data_scatter <- reactive({
    games %>% 
      filter(rating == input$rating_choice,
             genre == input$genre_choice)
  })
  
  filtered_data_bar <- reactive({
    games %>% 
      filter(year_of_release > input$year_choice[1] & year_of_release < input$year_choice[2],
             publisher == input$publisher_choice)
  })
  
  scatter_colour_update <- eventReactive(input$update_scatt, {
    input$colour_choice
  })
  
  scatter_shape_update <- eventReactive(input$update_scatt, {
    as.integer(input$shape_choice)
  })
  
  
  bar_colour_update <- eventReactive(input$update_line, {
    input$colour_choice_2
  })
  
  bar_type_update <- eventReactive(input$update_line, {
    input$bar_choice
  })
  
  output$user_v_critic <- renderPlot({
    filtered_data_scatter() %>% 
      ggplot(aes(x = user_score,
                 y = critic_score)) +
      geom_point(shape = scatter_shape_update(), colour = scatter_colour_update(), show.legend = FALSE, size = 3) +
      labs(x = "User Score",
           y = "Critic Score",
           title = "The Relationship Between the User Score and Critic Score",
           subtitle = paste("Genre: ", input$genre_choice, "  Rating ", input$rating_choice, "\n")) +
      theme(axis.title = element_text(size = 16),
            plot.title = element_text(size = 24),
            plot.subtitle = element_text(size = 16),
            panel.background = element_rect(fill = "aliceblue",
                                            colour = "aliceblue",
                                            size = 0.5, linetype = "solid"),
            panel.grid.major = element_line(size = 0.5, linetype = 'solid',
                                            colour = "white"), 
            panel.grid.minor = element_line(size = 0.25, linetype = 'solid',
                                            colour = "white")
      )
  })
  
  output$table_output <- DT::renderDataTable({
    filtered_data_scatter()
  })
  
  output$year_v_sales <- renderPlot({
    if (bar_type_update() == "Bar") {
      p1 <- filtered_data_bar() %>% 
        ggplot(aes(x = year_of_release,
                   y = sales)) +
        geom_col(fill = bar_colour_update()) +
        scale_y_continuous(expand = c(0, 0)) +
        labs(x = "Year of Release",
             y = "Sales (m$)",
             title = "Year of Release vs Sales",
             subtitle = paste("Publisher: ", input$publisher_choice, "  Year of release: ", input$year_choice[1], " - ", input$year_choice[2], "\n")) +
        theme(axis.title = element_text(size = 16),
              plot.title = element_text(size = 24),
              plot.subtitle = element_text(size = 16), 
              panel.background = element_rect(fill = "aliceblue",
                                              colour = "aliceblue",
                                              size = 0.5, linetype = "solid"),
              panel.grid.major = element_line(size = 0.5, linetype = 'solid',
                                              colour = "white"), 
              panel.grid.minor = element_line(size = 0.25, linetype = 'solid',
                                              colour = "white")
        )
    }
    if (bar_type_update() == "Horizontal Bar") {
      p1 <- filtered_data_bar() %>% 
        ggplot(aes(x = year_of_release,
                   y = sales)) +
        geom_col(fill = bar_colour_update()) +
        scale_y_continuous(expand = c(0, 0)) +
        coord_flip() +
        labs(x = "Year of Release",
             y = "Sales (m$)",
             title = "Year of Release vs Sales",
             subtitle = paste("Publisher: ", input$publisher_choice, "  Year of release: ", input$year_choice[1], " - ", input$year_choice[2], "\n"))
      theme(axis.title = element_text(size = 16),
            plot.title = element_text(size = 24),
            plot.subtitle = element_text(size = 16),
            panel.background = element_rect(fill = "aliceblue",
                                            colour = "aliceblue",
                                            size = 0.5, linetype = "solid"),
            panel.grid.major = element_line(size = 0.5, linetype = 'solid',
                                            colour = "white"), 
            panel.grid.minor = element_line(size = 0.25, linetype = 'solid',
                                            colour = "white")
      )
    }
    p1
  })
  
  counter <- reactiveValues(counter_value = 10000)
  
  observeEvent(input$donate_button, {
    counter$counter_value <- counter$counter_value + 100
  })
  
  observeEvent(input$donate_button, {
    updateNumericInput(session, "number_input", value = counter$counter_value)
  })
}


# run app -----------------------------------------------------------------

shinyApp(ui = ui, server = server)
