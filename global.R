# dashboard library
library(shiny)
library(bslib)
library(DT)
library(ECharts2Shiny) 

# data wrangling
library(dplyr)
library(lubridate)
library(stringr)
library(glue)

# data visualization
library(ggplot2)
library(plotly)
library(leaflet)

options(scipen = 999)

# DATA --------------------------------------------------------------------

retail <- read.csv("data/online_retail.csv")
retail_clean <- retail %>% 
  mutate(invoice_date = ymd_hms(invoice_date),
         country = as.factor(country),
         status = as.factor(status),
         sales = quantity*price,
         category_id = str_sub(stock_code, end = 3))
