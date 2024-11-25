#### Preamble ####
# Purpose: Simulates a dataset of shootings and firearms discharges in Toronto.
# Author: Xinze Wu
# Date: 2024/11/24
# Contact: kerwin.wu@mail.utoronto.ca
# License: MIT
# Pre-requisites: The `tidyverse` package must be installed

#### Workspace setup ####
library(tidyverse)
library(lubridate)
set.seed(853)


#### Simulate data ####
# Define the simulation parameters
num_entries <- 500  # number of records to generate
start_date <- ymd("2020-01-01")
end_date <- ymd("2023-12-31")
locations <- c("North York", "Scarborough", "Downtown", "Etobicoke", "Mississauga")
incident_types <- c("Shots Fired", "Shooting with Injuries", "Shooting with Fatalities")

# Generate the data
simulated_data <- tibble(
  Date = sample(seq(from = start_date, to = end_date, by = "day"), num_entries, replace = TRUE),
  Location = sample(locations, num_entries, replace = TRUE),
  IncidentType = sample(incident_types, num_entries, replace = TRUE),
  Injuries = rpois(num_entries, lambda = 0.5),  # Poisson distribution, average 0.5 injuries
  Fatalities = rbinom(num_entries, size = 1, prob = 0.05),  # Binomial distribution, 5% chance
  SuspectArrested = sample(c("Yes", "No"), num_entries, replace = TRUE, prob = c(0.3, 0.7))
)


#### Save data ####
write_csv(simulated_data, "data/00-simulated_data/simulated_data.csv")
