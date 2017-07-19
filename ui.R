

### ui.R ###


shinyUI(navbarPage("NYC Housing Prices", id="nav", # dashboardPage
                   theme = shinytheme("flatly"),
                   
  navbarMenu("Maps", 
             tabPanel("Value Per Square Foot", 
              div(class="outer",
               
                   tags$head(
                    # Include our custom CSS
                    includeCSS("styles.css"),
                    includeScript("gomap.js")
                    ),
               
                   leafletOutput("valuemap", 
                                 width="100%", 
                                 height="100%"), 
               
                   absolutePanel(id = "controls", 
                                 class = "panel panel-default", 
                                 fixed = TRUE, draggable = TRUE, 
                                 top = 415, left = 20, 
                                 right = "auto", bottom = "auto",
                                 width = "auto", height = "auto",
                             
                                 h4("Value per Sq. Ft."),
                             
                                 selectizeInput(inputId = "year",
                                                label = "Select Year",
                                                choices = c(
                                                  "2016" = "X2016", "2015" = "X2015",
                                                  "2014" = "X2014", "2013" = "X2013",
                                                  "2012" = "X2012", "2011" = "X2011", 
                                                  "2010" = "X2010", "2009" = "X2009",
                                                  "2008" = "X2008"), 
                                                selected = "2016")
                             
                                 ), 
                   absolutePanel(id = "x1", 
                                 class = "panel panel-default", 
                                 fixed = TRUE, draggable = TRUE, 
                                 top = 125, left = 20, 
                                 right = "auto", bottom = "auto",
                                 width = 450, height = 275,
                             
                                 h4("Value by Borough"),
                               
                                 plotlyOutput("line", height = 200)
                             
                                )
                  )
              ),
  
      tabPanel("Percentage Change", 
               div(class="outer",
               
                   tags$head(
                     # Include our custom CSS
                     includeCSS("styles.css"),
                     includeScript("gomap.js")
                   ),
               
                   leafletOutput("pctmap", 
                                 width="100%", 
                                 height="100%"), 
               
                   absolutePanel(id = "control2", 
                                 class = "panel panel-default", 
                                 fixed = TRUE, draggable = TRUE, 
                                 top = 250, left = 20, 
                                 right = "auto", bottom = "auto",
                                 width = "auto", height = "auto",
                             
                                 #h4("Select Year"),
                             
                                 selectizeInput(inputId = "pct",
                                                label = "Select Time Frame",
                                                choices = c(
                                                  "One Year % Change" = "pct_1", 
                                                  "Two Year CAGR" = "CAGR_2", 
                                                  "Three Year CAGR" = "CAGR_3", 
                                                  "Five Year CAGR" = "CAGR_5", 
                                                  "Ten Year CAGR" = "CAGR_10"), 
                                                selected = "CAGR_5")
                             
                                ), 
                   absolutePanel(id = "x2", 
                                 class = "panel panel-default", 
                                 fixed = TRUE, draggable = TRUE, 
                                 top = 125, left = 20, 
                                 right = "auto", bottom = "auto",
                                 width = "auto", height = "auto",
                                 
                                 h4("Percentage Change"),
                                 
                                 checkboxInput("topzips", 
                                               "Top Five Zip Codes", 
                                               value = FALSE), 
                                 checkboxInput("bottomzips", 
                                               "Bottom Five Zip Codes", 
                                               value = FALSE),
                                 
                                 tags$div(id="cite", '')
                                 
                   )
                   
               )
      ),
  
      tabPanel("Population Density", 
               div(class="outer",
               
                   tags$head(
                     # Include our custom CSS
                     includeCSS("styles.css"),
                     includeScript("gomap.js")
                   ),
               
                   leafletOutput("popmap", 
                                 width="100%", 
                                 height="100%")
               
              )
      )
  ),
  
  navbarMenu("Charts",
             tabPanel("Scatter Plot: Population vs. VPSF", 
                fluidRow(
                  
                  column(width = 6, 
                         h4("Population vs. Value/Sq. Ft."),
                         title = "Population vs. VPSF", 
                         #solidHeader = TRUE, 
                         #status = "primary", 
                         #width = NULL, height = "auto", 
                         plotlyOutput("scatter")
                         
                  ),
             
                  column(width = 6, 
                         h4("Population Density vs. Value/Sq. Ft."),
                         title = "Population vs. VPSF", 
                         #solidHeader = TRUE, 
                         #status = "primary", 
                         #width = NULL, height = "auto", 
                         plotlyOutput("scatter2")
                         )
                        )
             ), 
             tabPanel("Box Plot: VPSF by Borough", 
                fluidRow(
                  
                  column(width = 3 
                         
                  ),
                      
                  column(width = 6,
                         h4("Value/Sq. Ft. by Borough"),
                         title = "VPSF by Borough", 
                         #solidHeader = TRUE, 
                         #status = "primary", 
                         #width = NULL, height = "auto", 
                         plotlyOutput("box")
                         ) 
                        )
             )
            )
  )
)
  
  



















