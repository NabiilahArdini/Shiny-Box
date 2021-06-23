function(input, output) {
  
# TAB 1 -------------------------------------------------------------------

  output$home_img <- renderImage({
    
    list(src = "www/header_img.png",
         width = "100%"
         # height = 300
         )
    
  }, deleteFile = F)
  
}
