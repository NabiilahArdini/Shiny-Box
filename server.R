function(input, output, session) {
    
    output$header_img <- renderImage({

        list(src = "www/header_img.png",
             width = "100%"
             )
    }, deleteFile = F)
   
# ----------------------------------------------- REACTIVE
    
    trend_data <- reactive({
      
      validate(
        need(input$status != "", "Please fill all inputs provided.")
      )
      
    retail_clean %>% 
        filter(status %in% input$status,
               invoice_date >= input$date[1] & invoice_date <= input$date[2]) %>% 
        mutate(invoice_dt = floor_date(invoice_date, unit = input$floor_date))
      
    })
    
    output$total_item <- renderText({
      
        overview <- trend_data()
        scales::comma(sum(overview$quantity))
        
      })
      
    output$unique_purchases <- renderText({
        
        overview <- trend_data()
        scales::comma(length(unique(overview$invoice)))
        
      })
      
    output$total_sales <- renderText({
        
        overview <- trend_data()
        scales::comma(sum(overview$sales))
        
      })
      
    output$countries_reached <- renderText({
        
        overview <- trend_data()
        scales::comma(length(unique(overview$country)))
        
      })
      
    output$trend_line <- renderPlotly({
        
        plot_line <- trend_data() %>%
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
        
        
        ggplotly(plot_line, tooltip = "text") %>% 
          layout(title = list(x = 0.5)) 
      
      })
    
    trend_data2 <- eventReactive(input$action1, {
      
      trend_data() %>% 
        group_by(stock_code, description) %>% 
        summarise(n_purchase = sum(quantity)) %>%
        mutate(n_purchase = abs(n_purchase)) %>%
        arrange(desc(n_purchase)) %>% 
        head(10) %>% 
        mutate(text = glue("{description}
                      Stock Code: {stock_code}
                      Number of puchase: {n_purchase}")
        ) 
      
    })
    
    observeEvent(input$action1, {
    
    output$trend_col <- renderPlotly({
      
      trend_col <- trend_data2() %>% 
        ggplot(aes(x = n_purchase, y = reorder(stock_code, n_purchase), text = text)) + 
        geom_col(aes(fill = n_purchase), show.legend = F) +
        scale_fill_gradient(low = "#ffd700", high = "#65c6f4") +
        labs(x = "Number of Purchase", y = "Stock Code", 
             title = paste0("Top 10 Product Purchases")) + 
        theme_minimal()
      
      ggplotly(trend_col, tooltip = "text")
      
    })
    
    output$ui_text <- renderUI({
    
      p("The table below shows each country purchases from", strong("All Product"),
        "You can choose a product to display its country purchase distribution:")
    
      })
    
    output$ui_product <- renderUI({
      
      product <- trend_data2() 
      p <- unique(product$description)
      
      selectInput("product", label = NULL, choices = p, selected = p[1], 
                  width = "100%")
      
    })
    
    output$ui_button <- renderUI({
      
      actionButton("action2", label = "Submit")
    
    })
    
    output$trend_table <- renderDataTable(
      
      trend_data() %>% 
        group_by(country) %>% 
        summarise(quantity = sum(quantity)) %>%
        ungroup() %>% 
        mutate(quantity = abs(quantity),
               prop_purchase = paste(round(quantity/sum(quantity)*100,2),"%")) %>% 
        arrange(desc(quantity)) %>% 
        rename(Country = country,
               Quantity = quantity,
               Proportion = prop_purchase)
      
    )
    
    })
    
    observeEvent(input$action2, {
      
      # add reset
      insertUI(
        selector = "#action2",
        where = "afterEnd",
        ui <- actionButton("action3", label = "Reset to All Product")
      )
      
      # clear ui
      removeUI("#action2")
      
      # add table
      output$trend_table <- renderDataTable({
        
        trend_data() %>% 
          group_by(country) %>% 
          filter(description == input$product) %>%
          summarise(quantity = sum(quantity)) %>%
          ungroup() %>% 
          mutate(quantity = abs(quantity),
                 prop_purchase = paste(round(quantity/sum(quantity)*100,2),"%")) %>% 
          arrange(desc(quantity)) %>% 
          rename(Country = country,
                 Quantity = quantity,
                 Proportion = prop_purchase)
        
      }) 
      
    })
    
    observeEvent(input$action3, {
      
      # clear ui
      removeUI("#action3")
      
      # add ui
      output$ui_button <- renderUI({
        
        actionButton("action2", label = "Submit")
        
      })
      
      # table
      output$trend_table <- renderDataTable(
          
          trend_data() %>% 
            group_by(country) %>% 
            summarise(quantity = sum(quantity)) %>%
            ungroup() %>% 
            mutate(quantity = abs(quantity),
                   prop_purchase = paste(round(quantity/sum(quantity)*100,2),"%")) %>% 
            arrange(desc(quantity)) %>% 
            rename(Country = country,
                   Quantity = quantity,
                   Proportion = prop_purchase)
          
        ) 
    
    
      }, ignoreInit = TRUE)
    
      
}

