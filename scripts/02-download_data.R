#### Preamble ####
# Purpose: Downloads and saves the Shootings and Firearm Discharges data from Open Data Toronto
# Author: Xinze Wu
# Date: 2024/11/24
# Contact: kerwin.wu@mail.utoronto.ca
# License: MIT
# Pre-requisites: opendatatoronto, tidyverse

#### Workspace setup ####
library(opendatatoronto)
library(tidyverse)


### Download data ###

# Show details for the specific package by ID
package <- show_package("4bc5511d-0ecf-487a-9214-7b2359ad8f61")
print(package)

# Get all resources for this package
resources <- list_package_resources("4bc5511d-0ecf-487a-9214-7b2359ad8f61")

# Identify datastore resources; Toronto Open Data sets datastore resource format to CSV for non-geospatial and GeoJSON for geospatial resources
datastore_resources <- filter(resources, tolower(format) %in% c('csv', 'geojson'))

# Load the first datastore resource as a sample
# Ensure to choose the correct resource by examining the 'datastore_resources' dataframe if necessary
data <- get_resource(datastore_resources$id[1])

# Save the data to a CSV file in the specified directory
write_csv(data, "data/01-raw_data/raw_data.csv")
