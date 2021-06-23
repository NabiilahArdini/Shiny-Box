navbarPage(title = "Shiny-Box", 
           theme = bs_theme(bootswatch = "lux"),
           # theme = bs_theme(bg = "white",
           #                  fg = "black",
           #                  primary = "maroon",
           #                  base_font = font_google("Montserrat")),
           

# TAB 1 -------------------------------------------------------------------

           tabPanel(title = "Home",
                    imageOutput("home_img", 
                                height = "320px"
                                ),
                    br(),
                    hr(),
                    h4(strong("Project Description")),
                    p(style="text-align: justify; font-size = 25px",
                      "Shiny-Box is a Shiny application made with the purpose of", 
                      em("demonstrating various use of shiny features"), "that are frequently asked by users but rarely discussed in 
                      a beginner or formal class environment. With an example app and its code, Shiny-Box hopefully will ease your 
                      understanding on the mechanism of various Shiny features. Go to",
                      a(href = "https://github.com/NabiilahArdini/Shiny-Box",
                        "Shiny-Box GitHub Page"),
                      "to find more details on the source code."),
                    
                    tags$blockquote("Shiny-Box is still under continuous development. 
                      Please look forward to future updates!"),
                    hr()
                ),


# TAB 2 -------------------------------------------------------------------


           tabPanel(title = "Sales Overview",
                    fluidPage(
                      sidebarLayout(
                          sidebarPanel(
                            dateRangeInput("date", label = "Sales Period:",
                                           min = min(retail_clean$invoice_date), 
                                           max = max(retail_clean$invoice_date),
                                           start = min(retail_clean$invoice_date),
                                           end = max(retail_clean$invoice_date)),
                            selectInput("status", label = "Status of Purchase:",
                                        choices = c("Purchased", "Cancelled"),
                                        selected = "Purchased",
                                        multiple = T),
                            actionButton("action1", label = "Submit"),
                            h2(strong(textOutput("unique_purchases"))),
                                   h5("Total Unique Purchases"),
                            h2(strong(textOutput("total_sales"))),
                                  h5("Total Sales")
                            ),
                          
                          mainPanel(
                            plotlyOutput("trend_line", height = "450px")
                            )
                          )
                        ),
                    
                    br(), br(),
                    
                    fluidPage(
                      sidebarLayout(
                        
                        sidebarPanel(
                          
                          h3("Top Product Analysis"),
                          selectInput("country", label = "Select Country:",
                                      choices = unique(retail_clean$country), 
                                      selected = unique(retail_clean$country)[1]),
                         
                          uiOutput("select_category")
                         
                        ),
                        
                        mainPanel(tableOutput("top_product"))
                      
                      )
                    )
                  
                  ),
           


# TAB 3 -------------------------------------------------------------------


           tabPanel(title = "Interactive Map",
                    "content 3"),
           
           inverse = T
)
