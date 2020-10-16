navbarPage("Shiny-Box",
           
           #tab1
           tabPanel("Home", 
                    fluidPage(imageOutput("header_img", width = "100%", height = "100%")),
                    hr(),
                    fluidPage(column(width = 9, 
                                     p(style="text-align: justify; font-size = 16px", 
                                       br(),
                                       strong("Shiny-Box"), "is a Shiny application made with the purpose of", 
                                       em("demonstrating various use of shiny features"), 
                                       "that are frequently asked by students/users but rarely discussed in 
                                        a beginner or formal class environment. With an example app and its code, 
                                        Shiny-Box hopefully will ease you understanding 
                                        on the mechanism of various more engaging Shiny features."),
                                     br()
                                     ),
                              column(width = 3,
                                     tags$blockquote("You can go to", 
                                                      a(href = "https://github.com/NabiilahArdini/Shiny-Box",
                                                      "Shiny-Box GitHub Page"), 
                                                      "to find more details on the source code.")
                                     ),
                              column(width = 12,
                                     h3(style="text-align: center; font-style: italic",
                                        hr(),
                                        "Shiny-Box is still under continuous development.
                                        Please look forward for future updates!",
                                        hr()
                                        )
                                     )
                    )
           ),
           
           # tab 2
           tabPanel("Sales Overview",
                      
                    fluidPage(
                      column(width = 12,
                             h1("Sales Overview of Online Purchases"),
                             br()
                      )
                    ), 
                    
                    fluidPage(
                        sidebarPanel(width = 4,
                                     p("The chart on the right presents the trend of 
                                     purchases made from online platform. You can provide inputs for analysis."),
                                     dateRangeInput("date", label = "Range of Time:",
                                                    min = min(retail_clean$invoice_date), 
                                                    max = max(retail_clean$invoice_date),
                                                    start = min(retail_clean$invoice_date),
                                                    end = max(retail_clean$invoice_date)),
                                     selectizeInput("status", label = "Status of Purchase:",
                                                 choices = unique(retail_clean$status),
                                                 selected = "Purchased", 
                                                 multiple = T),
                                     selectInput("floor_date", label = "Round your time:",
                                                 choices = c("hour", "day", "week", "month"),
                                                 selected = "week"),
                                     p("Click the button below for further analyis on 
                                     the product being purchased during the period."),
                                     br(),
                                     actionButton("action1", "Product Analysis")
                                     ),
                        column(plotlyOutput("trend_line", height = "350px"), width = 8),
                        column(width = 2,
                               h2(strong(textOutput("total_item"))),
                               h5("Total Item Purchased")),
                        column(width = 2,
                               h2(strong(textOutput("unique_purchases"))),
                               h5("Total Unique Purchases")),
                        column(width = 2,
                               h2(strong(textOutput("total_sales"))),
                               h5("Total Sales")),
                        column(width = 2,
                               h2(strong(textOutput("countries_reached"))),
                               h5("Countries Reached"))
                                 ),
                    
                    fluidPage(
                        
                        column(width = 6,
                                   plotlyOutput("trend_col", height = "630px")),
                        
                        column(width = 6,
                                   uiOutput("ui_text"),
                                   uiOutput("ui_product"),
                                   uiOutput("ui_button"),
                                   br(),
                                   dataTableOutput("trend_table")
                                   )
                              ),
                      hr()
           ),
           
           # tab 3
           tabPanel("Interactive Map",
                    
                    fluidPage(
                      column(width = 12,
                             h1(style="text-align: center", 
                                "World Market Overview"),
                             h4(style="text-align: center",
                                "Click each country to find out its contribution 
                                and its top 10 most purchased item."),
                             br()
                      )
                    ),
                    
                    fluidPage(
                      
                      column(width = 8,
                             leafletOutput("map")),
                      
                      column(width = 4,
                             loadEChartsLibrary(),
                             
                             tags$div(id="gauge", 
                                      style="width:400px; height:400px;"
                             ),
                             deliverChart(div_id = "gauge")
                      )),
                    
                    fluidPage(
                      br(),
                      column(width = 6,
                             plotlyOutput("top10_con")),
                      column(width = 6,
                             DT::dataTableOutput("con_product"))
                      )
                    ),

           # tab 4
           navbarMenu("More Info",
                      tabPanel("GitHub Page",
                               p("Visit ",
                                 a(href = "https://github.com/NabiilahArdini/Shiny-Box",
                                 "Shiny-Box GitHub Page")))
           )
)
