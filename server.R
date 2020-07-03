function(input, output, session) {
    
    output$myImage <- renderImage({

        list(src = "www/home_wallpaper.jpg",
             width = "100%"
             )
    }, deleteFile = F)

}

