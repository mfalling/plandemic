# Libraries ---------------------------------------------------------------

library(tidyverse)
library(openxlsx)

# About -------------------------------------------------------------------

# The requester wants a different CSV file for each month.
# Each of the users should be present in each of the CSV files.
# Not all users tweeted each month; NA values will need to be introduced.

# Loads in the user file and the results file (generated in another script)
# Adds an ID column and joins the user/result files together by screen_name
# Filters by month and fills the dataframe with the missing users.


# Load in Data ------------------------------------------------------------

# Load in users and results.
users <- read_csv("data/users.csv", col_names = FALSE)
results <- read_csv("output/rtweetResults.csv")


# Wrangle the data --------------------------------------------------------

# Ensure the `screen_name` column in results matches the format in users.
results$screen_name <- paste("@", results$screen_name, sep = "")
# Remove the default ID column.
results <- results[, -1]

# Create a new ID column, based on the order in the users file.
users$id <- 1:nrow(users)

# Rename first column to match `results`
colnames(users)[1] <- "screen_name"

# Join users and results together, to attach the User ID.
resultsWithID <- full_join(results, users, by = "screen_name")

# Move the user ID to the front.
results_with_id <- resultsWithID %>%
  select(id, everything())


# Function ---------------------------------------------------------------------

# Function to create a subset for a single month.

monthly_results <- function(month){
  # Collect only a single month.
  monthly_results <- results_with_id %>%
    filter(created_at == month)
  
  # Which users didn't post that month?
  missing_user_ids <- setdiff(users$id, monthly_results$id)
  
  # Find their usernames and create a dataframe.
  missing_users <- cbind(users[missing_user_ids,], month, NA) %>%
    select(id, everything())
  
  # Update this temporary dataframe with appropriate column names.
  colnames(missing_users) <- colnames(monthly_results)
  
  # Add the missing users to the monthly dataframe.
  saturated_month <- rbind(monthly_results, missing_users) %>%
    arrange(id)
  
  return(saturated_month)
}


# Generate monthly results ------------------------------------------------

May <- monthly_results("May")
June <- monthly_results("June")
July <- monthly_results("July")
August <- monthly_results("August")


# Save output -------------------------------------------------------------

list_of_months <-list(May, June, July, August)
write.xlsx(list_of_months, "rtweetResults.xlsx")
