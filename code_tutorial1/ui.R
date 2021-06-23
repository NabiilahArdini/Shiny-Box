navbarPage(title = "Shiny-Box", 
           theme = bs_theme(bootswatch = "lux"),
           # theme = bs_theme(bg = "white",
           #                  fg = "black",
           #                  primary = "maroon",
           #                  base_font = font_google("Montserrat")),
           
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
           
           tabPanel(title = "Sales Overview",
                    fluidPage(
                      sidebarLayout(
                          sidebarPanel(
                            selectInput("status", label = "Status of Purchase:",
                                        choices = c("Purchased", "Cancelled")),
                            ),
                            mainPanel(
                              p("There will be plot here")
                            )
                          )
                        )
                  ),
           
           tabPanel(title = "Interactive Map",
                    "content 3"),
           
           inverse = T
)
