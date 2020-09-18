navbarPage("Shiny-Box",
           
           #tab1
           tabPanel("Home", 
                    imageOutput("myImage", width = "100%", height = "100%"),
                    fluidPage(br(),
                              h3("<ON DEVELOPMENT>"),
                              "Shiny-Box is a personal project that bundles up 
                              frequently asked (and more advanced) shiny features in a box.", 
                              br(),
                              "This is an example of Navigation Bar and 
                              adding image to enhance a Shiny home page.")
                    ),
                    
           tabPanel("Interactive Leaflet",
                    fluidPage(  
                            "More text here"
                            )
                    )
          )
          
