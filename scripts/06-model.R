#### Preamble ####
# Purpose: Validate and check the model built on Toronto shootings data
# Author: Xinze Wu
# Date: 2024/11/28
# Contact: kerwin.wu@mail.utoronto.ca
# License: MIT
# Pre-requisites: tidyverse, rstanarm, caret

#### Workspace setup ####
library(tidyverse)
library(rstanarm)
library(caret)

#### Load data ####
analysis_data <- read_csv("data/02-analysis_data/analysis_data.csv")

#### Prepare Data ####
# Creating a weighted score for deaths and injuries
analysis_data <- analysis_data %>%
  mutate(weighted_score = death * 2 + injuries)

#### Split Data into Training and Testing Sets ####
set.seed(123)  # Ensure reproducibility
split <- createDataPartition(analysis_data$weighted_score, p = 0.7, list = FALSE)
training_data <- analysis_data[split, ]
testing_data <- analysis_data[-split, ]

#### Model Fitting ####
# Fit the model on training data
model_validation_train <- stan_glm(
  formula = weighted_score ~ occ_date + occ_doy + occ_time_range + neighbourhood_158 + division,
  data = training_data,
  family = gaussian(),
  prior = normal(0, 2.5, autoscale = TRUE),
  prior_intercept = normal(0, 2.5, autoscale = TRUE),
  seed = 853
)

#### Posterior Predictive Checks ####
# Performing posterior predictive checks to assess how well the model predictions align with the actual data.
pp_check(model_validation_train)

#### Predictions on Test Data ####
# Predicting on testing data
testing_data <- testing_data %>%
  mutate(predicted_scores = posterior_predict(model_validation_train, newdata = testing_data, type = "response") |> colMeans())

#### Model Performance Evaluation ####
# Calculate Root Mean Squared Error (RMSE) and R-squared to quantify prediction accuracy.
rmse_value <- rmse(testing_data$weighted_score, testing_data$predicted_scores)
r_squared_value <- rsquared(testing_data$weighted_score, testing_data$predicted_scores)

# Print performance metrics
cat("RMSE:", rmse_value, "\n")
cat("R-squared:", r_squared_value, "\n")

#### Save model for future use ####
saveRDS(model_validation_train, file = "models/model_validation_train.rds")