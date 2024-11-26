#### Preamble ####
# Purpose: Conduct exploratory data analysis and prepare for modeling the combined effect of deaths and injuries in Toronto shooting incidents, assessing impact by date, day of year, hour, time range, and neighbourhood.
# Author: Xinze Wu
# Date: 2024/11/24
# Contact: kerwin.wu@mail.utoronto.ca
# License: MIT
# Pre-requisites: The `tidyverse` for data manipulation and visualization, `rstanarm` for Bayesian modeling.

#### Workspace setup ####
library(tidyverse)
library(rstanarm)
library(dplyr)
library(ggplot2)

#### Read data ####
analysis_data <- read_csv("data/02-analysis_data/analysis_data.csv")

#### Data Preparation ####
# Creating a weighted score for deaths and injuries
analysis_data <- analysis_data %>%
  mutate(weighted_score = death * 2 + injuries)  # Adjust the greater importance of 'death' over 'injuries'

#### Exploratory Data Analysis ####

# Prepare a function to reorder factors based on the weighted score
reorder_factors <- function(data, grouping_var) {
  data %>%
    group_by({{ grouping_var }}) %>%
    summarise(avg_score = mean(weighted_score, na.rm = TRUE)) %>%
    arrange(avg_score) %>%
    pull({{ grouping_var }})
}

# Apply the function to various factors
analysis_data$division <- factor(analysis_data$division, levels = reorder_factors(analysis_data, division))
analysis_data$occ_time_range <- factor(analysis_data$occ_time_range, levels = reorder_factors(analysis_data, occ_time_range))
analysis_data$neighbourhood_158 <- factor(analysis_data$neighbourhood_158, levels = reorder_factors(analysis_data, neighbourhood_158))

#### Plotting ####

# Relationships by Date
ggplot(analysis_data, aes(x = occ_date, y = weighted_score)) +
  geom_line(group = 1, color = "blue") +
  scale_x_date(date_breaks = "1 year", date_labels = "%Y") +
  labs(title = "Weighted Score Over Time", x = "Date", y = "Weighted Score") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))

# Relationships by Day of Year
ggplot(analysis_data, aes(x = occ_doy, y = weighted_score)) +
  geom_smooth(method = "loess", colour = "darkgreen") +
  labs(title = "Weighted Score by Day of Year", x = "Day of Year", y = "Weighted Score")

# Plotting Weighted Score by Hour of Day
ggplot(analysis_data, aes(x = occ_hour, y = weighted_score)) +
  geom_bar(stat = "identity", fill = "red") +
  labs(title = "Weighted Score by Hour of Day", x = "Hour", y = "Weighted Score")

# Plotting Weighted Score by Time Range
ggplot(analysis_data, aes(x = occ_time_range, y = weighted_score, fill = occ_time_range)) +
  geom_bar(stat = "identity") +
  labs(title = "Weighted Score by Time Range", x = "Time Range", y = "Weighted Score")

# Plotting Weighted Score by Neighbourhood
ggplot(analysis_data, aes(x = neighbourhood_158, y = weighted_score, fill = neighbourhood_158)) +
  geom_bar(stat = "identity") +
  labs(title = "Weighted Score by Neighbourhood", x = "Neighbourhood", y = "Weighted Score") +
  theme_minimal() +
  theme(axis.text.x = element_blank())

# Plotting Weighted Score by Division
ggplot(analysis_data, aes(x = division, y = weighted_score, fill = division)) +
  geom_bar(stat = "identity") +
  labs(title = "Weighted Score by Division", x = "Division", y = "Weighted Score") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 90, hjust = 1))

#### Model data ####
# Predicting the weighted score based on various factors
score_model <- stan_glm(
  formula = weighted_score ~ occ_hour + occ_doy + neighbourhood_158,
  data = analysis_data,
  family = gaussian(),  # Depending on the distribution of weighted_score, consider other families
  prior = normal(location = 0, scale = 2.5, autoscale = TRUE),
  prior_intercept = normal(location = 0, scale = 2.5, autoscale = TRUE),
  seed = 853
)

#### Save model ####
saveRDS(score_model, file = "models/score_model.rds")