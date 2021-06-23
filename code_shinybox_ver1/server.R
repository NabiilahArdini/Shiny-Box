function(input, output, session) {
    
    output$header_img <- renderImage({

        list(src = "www/header_img.png",
             width = "100%"
             )
    }, deleteFile = F)

# ----------------------------------------------- TAB 1
    
    # prepare data tab 1
    
    trend_data <- reactive({
      
      validate(
        need(input$status != "", "Please fill all inputs provided.")
      )
      
    retail_clean %>% 
        filter(status %in% input$status,
               invoice_date >= input$date[1] & invoice_date <= input$date[2]) %>% 
        mutate(invoice_dt = floor_date(invoice_date, unit = input$floor_date))
      
    })
    
    # outputs tab 1
    
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
    
# ----------------------------------------------- REACTIVE TO 'PRODUCT ANALYSIS'
    
    # prepare data
    
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
    
    # outputs
    
    observeEvent(input$action1, {
    
    # plotly
      
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
    
    # add description
    
    output$ui_text <- renderUI({
    
      p("The table below shows each country purchases from", strong("All Product"),
        ". You can choose a product to display its country purchase distribution:")
    
      })
    
    # selectInput based on previous inputs
    
    output$ui_product <- renderUI({
      
      product <- trend_data2() 
      p <- unique(product$description)
      
      selectInput("product", label = NULL, choices = p, selected = p[1], 
                  width = "100%")
      
    })
    
    # add submit button
    
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
    
    })

# ----------------------------------------------- REACTIVE TO 'SUBMIT'
    
    observeEvent(input$action2, {
      
      # add reset button
      
      insertUI(
        selector = "#action2",
        where = "afterEnd",
        ui <- actionButton("action3", label = "Reset to All Product")
      )
      
      # clear submit button
      
      removeUI("#action2")
      
      # update table
      
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
    
# ----------------------------------------------- REACTIVE TO 'RESET'
    
    observeEvent(input$action3, {
      
      # clear reset
      
      removeUI("#action3")
      
      # add submit button (again)
      
      output$ui_button <- renderUI({
        
        actionButton("action2", label = "Submit")
        
      })
      
      # reset to original table 
      
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

# ----------------------------------------------- TAB 2    
    
    # map
    
    output$map <- renderLeaflet(
      
      leaflet(leaf_mapping) %>%
        addProviderTiles(providers$Esri.WorldStreetMap) %>%  
        addCircleMarkers(lng = ~lon, lat = ~lat, label = ~country, 
                         radius = ~rel_quan, color = "teal")
    
    )

    # gauge 
    
    renderGauge(
      
      div_id = "gauge", rate = 0, gauge_name = "Contribution"
      
    )
    
    # plotly
    
    output$top10_con <- renderPlotly({
      
      dat <- data.frame(x = c(1:10),
                 y = c(1:100))
      
      click_col <- ggplot(data = dat, aes(x = x, y = y)) + 
        scale_x_continuous(breaks = seq(1,10,1)) +
        labs(x = NULL, y = NULL, 
             title = paste0("Please Choose Country")) + 
        theme_minimal()
      
      ggplotly(click_col)
      
    })
    
    
# ----------------------------------------------- REACTIVE TO LEAFLET CLICK

    # prepare data
    
    temp <- eventReactive(input$map_marker_click, {
      
      leaf_click %>% 
        filter(lon == input$map_marker_click$lng, lat == input$map_marker_click$lat) %>% 
        mutate(text = glue("{description}
                     Number of Purchase: {quantity}
                     Proportion: {prop_purchase}% of total country purchase "))
      
    })
    
    # outputs
    
    observeEvent(input$map_marker_click,{
      
      # update gauge
      
      temp_dat <- temp() 
      value <- temp_dat[1, "con_contrib"]
      
      renderGauge(
        
        div_id = "gauge", rate = value, gauge_name = "Contribution"
        
      )
      
      # update plotly
      
      output$top10_con <- renderPlotly({
        
        click_col <- temp() %>% 
          ggplot(aes(x = c(1:10), y = quantity, text = text)) + 
          geom_col(aes(fill = quantity), show.legend = F) + 
          scale_fill_gradient(low = "#ffd700", high = "#65c6f4") +
          scale_y_continuous(labels = scales::comma) + 
          scale_x_continuous(breaks = seq(1,10,1)) +
          labs(x = NULL, y = NULL, 
               title = paste0("Top 10 Most Purchased Items")) + 
          theme_minimal()
        
        ggplotly(click_col, tooltip = "text")
        
      })
      
      # table (scrollable, costumized page length)
      
      output$con_product <- DT::renderDataTable({
        
        dat <- leaf_data %>%
          filter(lon == input$map_marker_click$lng, lat == input$map_marker_click$lat) %>%
          mutate(prop_purchase = paste(round(quantity/sum(quantity)*100,2), "%")) %>% 
          arrange(desc(quantity)) %>% 
          select(description, quantity, prop_purchase) %>%
          rename(Product = description,
                 'Number of Purchase'= quantity,
                 'Proportion of Purchase' = prop_purchase) %>% 
          ungroup()
        
        DT::datatable(dat, options = list(lengthMenu = c(5, 10, 15), 
                                          pageLength = 5, scrollX = T))
        
      })
      
    })
      
}

