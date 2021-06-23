function(input, output) {
  
# TAB 1 -------------------------------------------------------------------

  output$home_img <- renderImage({
    
    list(src = "www/header_img.png",
         width = "100%"
         # height = 300
         )
    
  }, deleteFile = F)


# TAB 2 --------------------------------------------------------------------

## SALES ANALYSIS - INITIAL STATE

### prepare data (non-reactive)
  
trend_data <- retail_clean %>%
    filter(status %in% "Purchased",
           invoice_date >= min(invoice_date),
           invoice_date <= max(invoice_date)) %>%
    mutate(invoice_dt = floor_date(invoice_date, unit = "week"))
    
### create output

output$unique_purchases <- renderText({
  
  overview <- trend_data
  scales::comma(length(unique(overview$invoice)))
  
})

output$total_sales <- renderText({
  
  overview <- trend_data
  scales::comma(sum(overview$sales))
  
})

output$trend_line <- renderPlotly({
  
  plot_line <- trend_data %>%
    group_by(invoice_dt) %>%
    summarise(n_purchase = n()) %>%
    mutate(text = glue("Date: {invoice_dt}
                     Number of Purchases: {n_purchase}")
    ) %>%
    ggplot(aes(x = invoice_dt, y = n_purchase)) +
    geom_line(lwd = 0.5) +
    geom_point(aes(text = text), color = "salmon", size = 3) +
    scale_y_continuous(labels = scales::comma) +
    labs(x = NULL, y = NULL,
         title = "Trend of Weekly Purchases") +
    theme_minimal()
  
  ggplotly(plot_line, tooltip = "text") %>%
    layout(title = list(x = 0.5)) %>% # adjust title to the center
    config(displayModeBar = F) # removing menu bar
  
})

## SALES ANALYSIS - REACTIVE TO `ACTION1`

### prepare data (reactive)

temp <- eventReactive(input$action1, { 
  
  validate(
    need(input$status != "", "Please fill all inputs provided.")
  )

  retail_clean %>%
    filter(status %in% input$status,
           invoice_date >= input$date[1],
           invoice_date <= input$date[2]) %>%
    mutate(invoice_dt = floor_date(invoice_date, unit = "week"))

})

### create output

observeEvent(input$action1,{ # start observe event

  output$unique_purchases <- renderText({
    
    overview <- temp() 
    scales::comma(length(unique(overview$invoice)))
  
  })
  
  output$total_sales <- renderText({

    overview <- temp()
    scales::comma(sum(overview$sales))

  })

  output$trend_line <- renderPlotly({

    plot_line <- temp() %>%
      group_by(invoice_dt) %>%
      summarise(n_purchase = n()) %>%
      mutate(text = glue("Date: {invoice_dt}
                     Number of Purchases: {n_purchase}")
      ) %>%
      ggplot(aes(x = invoice_dt, y = n_purchase)) +
        geom_line(lwd = 0.5) +
        geom_point(aes(text = text), color = "salmon", size = 3) +
        scale_y_continuous(labels = scales::comma) +
        labs(x = NULL, y = NULL,
             title = "Trend of Weekly Purchases") +
        theme_minimal()

    ggplotly(plot_line, tooltip = "text") %>%
      layout(title = list(x = 0.5)) %>% # adjust title to the center
      config(displayModeBar = F) # removing menu bar

  })
  
}) # end observe event

## TOP PRODUCT ANALYSIS

output$select_category <- renderUI({
  
  selectInput("category_id", label = "Select Category ID:",
              choices = retail_clean %>% 
                filter(country == input$country) %>% 
                pull(category_id) %>% unique()
              )
  
})

output$top_product <- renderTable({
  
  retail_clean %>% 
    filter(country == input$country,
           category_id == input$category_id) %>% 
    group_by(description) %>% 
    summarize(quantity = sum(quantity),
              sales = sum(sales),
              stock_code = unique(stock_code)) %>% 
    arrange(desc(quantity)) %>% 
    rename(Product = description,
           'Quantity Purchased' = quantity,
           Sales = sales,
           'Stock Code' = stock_code) %>%
    head(10)

})

}
