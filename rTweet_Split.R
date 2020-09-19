# Libraries ---------------------------------------------------------------

library(readr)
library(dplyr)
library(openxlsx)

# About -------------------------------------------------------------------

# The requester wants each month as its own excel sheet in a single book.
# Each of the users should be present in each of the sheets.
# Not all users tweeted each month; NA values will need to be introduced.

# 1. Load in the results and the original user list.
# 2. Retroactively add an ID column to the results, to match the user list.
# 3. Split the results into seperate dataframes (one for each month)
# 4. Save the results in an excel book, as requested.


# 1. Load the Data --------------------------------------------------------

# Load in the original user list. 
users <- read_csv("data/users.csv", col_names = FALSE)

# Load in the results (generated in rtweet_Collect.R)
# This contains columns for user, month, and frequency of posts
results <- read_csv("output/rtweetResults.csv")


# 2. Add an ID column -----------------------------------------------------

# Prep: Reformat the `results` screen_name values, add a column name to `users`
results$screen_name <- paste("@", results$screen_name, sep = "")
colnames(users)[1] <- "screen_name"


# Prep: Remove default ID column in `results`, add an ID column to `users` 
results <- results[, -1]
users$id <- 1:nrow(users)

# Saturate the results: Add the ID column and introduce users with NA results.
results_with_id <- full_join(x = results, 
                             y = users, 
                             by = "screen_name")

# Move the user ID to the front.
results_with_id <- results_with_id %>%
  select(id, everything())


# 3.1 Create Function -----------------------------------------------------

# Create a function.
# This creates a subset of the results, broken down by month

monthly_results <- function(month){
  
  # Filter to a single month.
  monthly_results <- results_with_id %>%
    filter(created_at == month)
  
  # Which users didn't post that month?
  missing_user_ids <- setdiff(users$id, monthly_results$id)
  
  # Find their screen names and create a dataframe.
  missing_users <- cbind(users[missing_user_ids,], month, NA) %>%
    select(id, everything())
  
  # Update this temporary dataframe with appropriate column names.
  colnames(missing_users) <- colnames(monthly_results)
  
  # Add the missing users to the monthly dataframe.
  saturated_month <- rbind(monthly_results, missing_users) %>%
    arrange(id)
  
  return(saturated_month)
}


# 3.2 Generate Monthly Results --------------------------------------------

# Split the results by month.
May <- monthly_results("May")
June <- monthly_results("June")
July <- monthly_results("July")
August <- monthly_results("August")


# 4. Save the results -----------------------------------------------------

list_of_months <-list(May, June, July, August)
write.xlsx(list_of_months, "rtweetResults.xlsx")
