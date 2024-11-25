#### Preamble ####
# Purpose: Tests the structure and validity of the simulated Shootings and Firearm Discharges dataset.
# Author: Xinze Wu
# Date: 2024/11/24
# Contact: kerwin.wu@mail.utoronto.ca
# License: MIT
# Pre-requisites: 
  # - The `tidyverse` package must be installed and loaded
  # - 00-simulate_data.R must have been run


#### Workspace setup ####
library(tidyverse)

# Load the simulated data
shootings_data <- read_csv("data/00-simulated_data/simulated_data.csv")

# Test if the data was successfully loaded
if (exists("shootings_data")) {
  message("Test Passed: The dataset was successfully loaded.")
} else {
  stop("Test Failed: The dataset could not be loaded.")
}

#### Test data ####

# Check if the dataset has the expected number of rows
expected_rows <- 500
if (nrow(shootings_data) == expected_rows) {
  message("Test Passed: The dataset has the expected number of rows.")
} else {
  stop("Test Failed: The dataset does not have the expected number of rows.")
}

# Check if the dataset has 6 columns (Date, Location, IncidentType, Injuries, Fatalities, SuspectArrested)
if (ncol(shootings_data) == 6) {
  message("Test Passed: The dataset has 6 columns.")
} else {
  stop("Test Failed: The dataset does not have 6 columns.")
}

# Check for any missing values in the dataset
if (any(is.na(shootings_data))) {
  stop("Test Failed: The dataset contains missing values.")
} else {
  message("Test Passed: The dataset contains no missing values.")
}

# Check if all locations are within a predefined list of valid locations
valid_locations <- c("North York", "Scarborough", "Downtown", "Etobicoke", "Mississauga")
if (all(shootings_data$Location %in% valid_locations)) {
  message("Test Passed: All locations are valid.")
} else {
  stop("Test Failed: The dataset contains invalid locations.")
}

# Check if 'IncidentType' only contains valid categories
valid_incident_types <- c("Shots Fired", "Shooting with Injuries", "Shooting with Fatalities")
if (all(shootings_data$IncidentType %in% valid_incident_types)) {
  message("Test Passed: 'IncidentType' contains only valid categories.")
} else {
  stop("Test Failed: 'IncidentType' contains invalid categories.")
}
