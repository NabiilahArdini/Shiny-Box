navbarPage("Shiny-Box",
           
           #tab1
           tabPanel("Home", 
                    fluidPage(imageOutput("header_img", width = "100%", height = "100%")),
                    br(),
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
           
           # tab2
           navbarMenu("Examples",
                      tabPanel("Sales Overview",
                      
                      fluidPage(column(width = 12,
                                       p("a text here.."))),         
                      sidebarLayout(
                        sidebarPanel(width = 3,
                                     dateRangeInput("date", label = "Range of Time:",
                                                    min = min(retail_clean$invoice_date), 
                                                    max = max(retail_clean$invoice_date),
                                                    start = min(retail_clean$invoice_date),
                                                    end = max(retail_clean$invoice_date)),
                                     selectInput("status", label = "Status of Purchase:",
                                                 choices = unique(retail_clean$status),
                                                 selected = "Purchased", 
                                                 multiple = T),
                                     selectInput("floor_date", label = "Round your time:",
                                                 choices = c("hour", "day", "week", "month"),
                                                 selected = "week"),
                                     actionButton("action1", label = "Submit")
                                     ),
                        mainPanel(
                          column(plotlyOutput("trend_line"), width = 6),
                          column(width = 3,
                                    valueBoxOutput("total_item"),
                                    valueBoxOutput("unique_purchases"),
                                    valueBoxOutput("total_sales"),
                                    valueBoxOutput("countries_reached"))
                                 )),
                          fluidPage(
                            column(width = 6),
                            column(width = 6,
                                   # reactive input
                                   # selectInput("product", label = "Choose Product:",
                                   #             choices = unique(retail_clean$description),
                                   #             selected = "15CM CHRISTMAS GLASS BALL 20 LIGHTS")
                                   
                                   # dataTableOutput("purchasing_con")
                                   )
                                )
                               ),
                      tabPanel("Interactive Map")
                    
           ),
           
           # tab2
           tabPanel("Documentation")
           
)
