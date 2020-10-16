
# dashboard library
library(shiny)
library(DT)
library(ECharts2Shiny)

# data wrangling
library(readr)
library(dplyr)
library(lubridate)
library(stringr)
library(glue)

# data visualization
library(ggplot2)
library(plotly)
library(leaflet)

# ----------------------------------------------- BASE DATA

retail <- read_csv("data/online_retail.csv")
retail_clean <- retail %>% 
  mutate(country = as.factor(country),
         status = as.factor(status),
         sales = quantity*price)

# ----------------------------------------------- DATA FOR LEAFLET

# base

leaf_data <- retail_clean %>% 
  filter(status == "Purchased") %>% 
  group_by(country, lon, lat, description) %>% 
  summarise(quantity = sum(quantity)) %>% 
  ungroup()

# mapping

leaf_mapping <- leaf_data %>% 
  group_by(country, lon, lat) %>% 
  summarise(quantity = sum(quantity)) %>% 
  arrange(desc(quantity)) %>%
  ungroup() %>% 
  mutate(rel_quan = case_when(quantity < 10000 ~ 4,
                              quantity < 100000 ~ 8,
                              quantity < 1000000 ~ 16,
                              quantity > 1000000 ~ 32))

# click events

leaf_click <- leaf_data %>%
  mutate(total_q = sum(quantity)) %>% 
  group_by(country) %>%
  mutate(con_contrib = round(sum(quantity)/total_q*100,2),
         prop_purchase = round(quantity/sum(quantity)*100,2)) %>% 
  arrange(desc(quantity)) %>% 
  slice_head(n = 10) %>% 
  select(country, description, quantity, prop_purchase, con_contrib, lon, lat) %>% 
  ungroup()

