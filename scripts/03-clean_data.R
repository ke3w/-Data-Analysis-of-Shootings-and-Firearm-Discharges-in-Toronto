#### Preamble ####
# Purpose: Cleans the raw data of Shootings and Firearm Discharges recorded in Toronto.
# Author: Xinze Wu
# Date: 2024/11/24
# Contact: kerwin.wu@mail.utoronto.ca
# License: MIT
# Pre-requisites: The `tidyverse`, `janitor`, `lubridate` packages must be installed and loaded

#### Workspace setup ####
library(tidyverse)
library(janitor)
library(lubridate)

#### Clean data ####
# Load the raw shootings data
raw_data <- read_csv("data/01-raw_data/raw_data.csv")

# Clean the data
cleaned_data <-
  raw_data |>
  clean_names() %>%
  mutate(
    occ_date = ymd(occ_date),  # Convert occ_date to date format
    division = as.factor(division),  # Convert police division to factor
    death = as.integer(death),  # Ensure death count is integer
    injuries = as.integer(injuries),  # Ensure injuries count is integer
    occ_dow = as.factor(occ_dow)
  ) %>%
  select(-hood_140, -neighbourhood_140, -long_wgs84, -lat_wgs84, -geometry) %>%
  drop_na()  # Optional: Drop rows with any NA values

#### Save data ####
write_csv(cleaned_data, "data/02-analysis_data/analysis_data.csv")
