#### Preamble ####
# Purpose: Tests the cleaned data of Shootings and Firearm Discharges to ensure quality and consistency.
# Author: Xinze Wu
# Date: 2024/11/24
# Contact: kerwin.wu@mail.utoronto.ca
# License: MIT
# Pre-requisites: The `tidyverse` and `testthat` packages must be installed
# Any other information needed? Run these tests to ensure data integrity before analysis.

#### Workspace setup ####
library(tidyverse)
library(testthat)

# Load the cleaned data
analysis_data <- read_csv("../data/02-analysis_data/analysis_data.csv")

#### Define tests ####
tests <- test_that("Data integrity and structure tests", {
  # Test that the dataset has the expected number of rows
  expect_true(nrow(analysis_data) > 0)  # Adjust according to your expected row count
  
  # Test that the dataset has expected number of columns after cleaning and removing some
  expect_equal(ncol(analysis_data), 15)  # Adjust based on actual columns you retained
  
  # Test that 'division' is a factor type, which replaced police divisions
  expect_type(analysis_data$division, "integer")  # Factors are internally stored as integers
  
  # Test that the 'death' column is integer type
  expect_type(analysis_data$death, "integer")
  
  # Test that the 'injuries' column is integer type
  expect_type(analysis_data$injuries, "integer")
  
  # Test that there are no missing values in the dataset
  expect_true(all(!is.na(analysis_data)))
  
  # Test that there are no empty strings in significant columns (adjust as necessary)
  expect_false(any(analysis_data$division == "" | analysis_data$death == "" | analysis_data$injuries == ""))
})

# Print results of the tests
print(tests)