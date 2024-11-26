#### Preamble ####
# Purpose: Build and save a model predicting the weighted score of shootings and firearm discharges in Toronto, based on time and location factors.
# Author: Xinze Wu
# Date: 2024/11/24
# Contact: kerwin.wu@mail.utoronto.ca
# License: MIT
# Pre-requisites: tidyverse for data manipulation, rstanarm for Bayesian modeling

#### Workspace setup ####
library(tidyverse)
library(rstanarm)

#### Read data ####
analysis_data <- read_csv("data/02-analysis_data/analysis_data.csv")

#### Data Preparation ####
# Ensure categorical variables are treated as factors
analysis_data <- analysis_data %>%
  mutate(
    division = as.factor(division),
    neighbourhood_158 = as.factor(neighbourhood_158),
    occ_hour = as.factor(occ_hour)
  )

### Model data ####
# Building a Bayesian generalized linear model
weighted_score_model <- stan_glm(
  formula = weighted_score ~ occ_date + occ_doy + occ_hour + neighbourhood_158 + division,
  data = analysis_data,
  family = poisson(),
  prior = normal(0, 2.5, autoscale = TRUE),
  prior_intercept = normal(0, 2.5, autoscale = TRUE),
  seed = 853
)

#### Save model ####
saveRDS(
  weighted_score_model,
  file = "models/weighted_score_model.rds"
)

# Optionally, print model summary
print(summary(weighted_score_model))