#### Preamble ####
# Purpose: Load and further analyze the Gradient Boosting Machine model for predicting weighted scores of shootings and firearm discharges in Toronto.
# Author: Xinze Wu
# Date: 2024/11/24
# Contact: kerwin.wu@mail.utoronto.ca
# License: MIT
# Pre-requisites: The `tidyverse`, `gbm`, `caret` packages must be installed and loaded

#### Workspace setup ####
library(tidyverse)
library(gbm)
library(caret)

#### Load saved model ####
model <- readRDS("models/first_model.rds")

#### Load data ####
# Load the cleaned and preprocessed data for further analysis or prediction
analysis_data <- read_csv("data/02-analysis_data/analysis_data.csv")
analysis_data$occ_date <- as.numeric(analysis_data$occ_date)
analysis_data$occ_dow <- as.factor(analysis_data$occ_dow)
analysis_data$occ_time_range <- as.factor(analysis_data$occ_time_range)
analysis_data$neighbourhood_158 <- as.factor(analysis_data$neighbourhood_158)
analysis_data$division <- as.factor(analysis_data$division)
analysis_data <- analysis_data %>%
  mutate(weighted_score = death * 2 + injuries)  # Adjust the greater importance of 'death' over 'injuries'


#### Model diagnostics and performance analysis ####
# Printing model summary
print(model)

# Set graphical parameters
par(cex.axis = 0.4, las = 1)  # Adjust this value to change the size of the axis labels

# Plot variable importance
summary(model, n.trees = 500, plotit = TRUE)

# Reset to default (optional, to avoid affecting other plots)
par(cex.axis = 1)

# Compare predictions with actual data and calculate performance metrics
actual <- analysis_data$weighted_score
rmse <- sqrt(mean((predictions - actual)^2))

#### performance metrics ####
# Show RMSE
print(sprintf("RMSE: %f", rmse))
