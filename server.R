function(input, output, session) {
    
    output$header_img <- renderImage({

        list(src = "www/header_img.png",
             width = "100%"
             )
    }, deleteFile = F)

    output$total_item <- renderValueBox({
      
      valueBox(value = scales::comma(sum(retail_clean$quantity)), 
               subtitle = "Total Item", 
               color = "green", icon = icon("flag"),
               width = 3)
      
    })
    
    output$unique_purchases <- renderValueBox({
      
      valueBox(value = scales::comma(length(unique(retail_clean$invoice))), 
               subtitle = "Unique Purchases", 
               color = "green", icon = icon("flag"), 
               width = 3)
      
    })
    
    output$total_sales <- renderValueBox({
      
      valueBox(value = scales::comma(sum(retail_clean$sales)), 
               subtitle = "Total Sales", 
               color = "green", icon = icon("flag"),
               width = 3)
      
    })
    
    output$countries_reached <- renderValueBox({
      
      valueBox(value = scales::comma(length(unique(retail_clean$country))), 
               subtitle = "Countries Reached", 
               color = "green", icon = icon("flag"),
               width = 3)
      
    })
    
    # default
    trend_data <- retail_clean %>% 
        filter(status == "Purchased",
               invoice_date >= "2009-12-01" & invoice_date <= "2010-12-09") %>% 
        mutate(invoice_dt = floor_date(invoice_date, unit = "week"))
    
    output$trend_line <- renderPlotly({
      
      # data
      trend_dat1 <- trend_data %>% 
        group_by(invoice_dt) %>% 
        summarise(n_purchase = n()) %>% 
        mutate(text = glue("Date: {invoice_dt}
                     Number of Purchase: {n_purchase}")
        )
      
      # visualize
      trend_line <- trend_dat1 %>% 
        ggplot(aes(x = invoice_dt, y = n_purchase)) + 
        geom_line(lwd = 0.5) + 
        geom_point(aes(text = text), color = "#65c6f4", size = 3) + 
        scale_y_continuous(labels = scales::comma) +
        labs(x = NULL, 
             y = NULL,
             title = paste0("number of purchase per ", "week") %>% str_to_title(),
             subtitle = paste("From", min(retail_clean$invoice_dt), 
                              "to", max(retail_clean$invoice_dt))) +
        theme_minimal()
      
      ggplotly(trend_line, tooltip = "text")
      
    })
    
    # reactive
    
    trend_data2 <- eventReactive(input$action1, {
      
    retail_clean %>% 
        filter(status == input$status,
               invoice_date >= input$date[1] & invoice_date <= input$date[2]) %>% 
        mutate(invoice_dt = floor_date(invoice_date, unit = input$floor_date))
      
    })
    
    observeEvent(input$action1, {

      output$trend_line <- renderPlotly({
        
        plot_line <- trend_data2() %>%
          group_by(invoice_dt) %>%
          summarise(n_purchase = n()) %>%
          mutate(text = glue("Date: {invoice_dt}
                     Number of Purchase: {n_purchase}")
          ) %>%
          ggplot(aes(x = invoice_dt, y = n_purchase)) +
          geom_line(lwd = 0.5) +
          geom_point(aes(text = text), color = "#65c6f4", size = 3) +
          scale_y_continuous(labels = scales::comma) +
          labs(x = NULL,
               y = NULL,
               title = paste0("number of purchase per ", input$floor_date) %>% str_to_title(),
               subtitle = paste("From", input$date[1],
                                "to", input$date[2])) +
          theme_minimal()
        
        
        ggplotly(plot_line, tooltip = "text")
        
      })
      
    })
    
    
    
        
}

