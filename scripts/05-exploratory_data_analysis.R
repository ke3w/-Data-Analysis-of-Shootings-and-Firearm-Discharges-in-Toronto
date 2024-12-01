#### Preamble ####
# Purpose: Conduct exploratory data analysis and prepare for modeling the combined effect of deaths and injuries in Toronto shooting incidents, assessing impact by date, day of year, hour, time range, and neighbourhood.
# Author: Xinze Wu
# Date: 2024/11/24
# Contact: kerwin.wu@mail.utoronto.ca
# License: MIT
# Pre-requisites: The `tidyverse` for data manipulation and visualization, `rstanarm` for Bayesian modeling.

#### Workspace setup ####
library(tidyverse)
library(gbm)
library(caret)
library(ggplot2)

#### Read data ####
analysis_data <- read_csv("data/02-analysis_data/analysis_data.csv")

#### Data Preparation ####
# Creating a weighted score for deaths and injuries
analysis_data <- analysis_data %>%
  mutate(weighted_score = death * 2 + injuries)  # Adjust the greater importance of 'death' over 'injuries'

#### Exploratory Data Analysis ####
#### Plotting ####

# Relationships by Date
ggplot(analysis_data, aes(x = occ_date, y = weighted_score)) +
  geom_line(group = 1, color = "blue") +
  scale_x_date(date_breaks = "1 year", date_labels = "%Y") +
  labs(title = "Weighted Score Over Time", x = "Date", y = "Weighted Score") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1))

# Relationships by Day of Week
ggplot(analysis_data, aes(x = occ_dow, y = weighted_score)) +
  geom_bar(stat = "identity", fill = "steelblue") +
  labs(title = "Weighted Score by Day of Week", x = "Day of Week", y = "Weighted Score") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

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
  theme(legend.position="none",
        axis.text.x = element_text(angle=90, vjust=0.5, hjust=1, size=5))

# Plotting Weighted Score by Division
ggplot(analysis_data, aes(x = division, y = weighted_score, fill = division)) +
  geom_bar(stat = "identity") +
  labs(title = "Weighted Score by Division", x = "Division", y = "Weighted Score") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 90, hjust = 1))

analysis_data$occ_date <- as.numeric(analysis_data$occ_date)
analysis_data$occ_dow <- as.factor(analysis_data$occ_dow)
analysis_data$occ_time_range <- as.factor(analysis_data$occ_time_range)
analysis_data$neighbourhood_158 <- as.factor(analysis_data$neighbourhood_158)
analysis_data$division <- as.factor(analysis_data$division)

### Model setup
set.seed(123)  # for reproducibility
model <- gbm(weighted_score ~ occ_date + occ_dow + occ_doy + occ_time_range + neighbourhood_158 + division,
                 data = analysis_data,
                 distribution = "gaussian",
                 n.trees = 500,
                 interaction.depth = 4,
                 shrinkage = 0.01,
                 cv.folds = 5,
                 n.minobsinnode = 10)

# Model summary
print(model)
summary(model, n.trees = 500, plotit = TRUE)

# Save model
saveRDS(model, file = "models/first_model.rds")
