navbarPage("Shiny-Box",
           
           #tab1
           tabPanel("Home", 
                    imageOutput("myImage", width = "100%", height = "100%"),
                    fluidPage(br(),
                              "more text here")),
                    
           tabPanel("Description",
                    fluidPage(  
                            "This is an example of Navigation Bar 
                            for Shiny and adding image to enhance a Shiny home page."
                            )
                    )
          )
          
