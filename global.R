library(shiny)
library(DT)

# data wrangling
library(readr)
library(dplyr)
library(lubridate)
library(stringr)
library(glue)

# data visualization
library(ggplot2)
library(plotly)

retail <- read_csv("data/online_retail.csv")
retail_clean <- retail %>% 
  mutate(country = as.factor(country),
         status = as.factor(status),
         sales = quantity*price)