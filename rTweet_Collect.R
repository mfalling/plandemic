# Libraries ---------------------------------------------------------------

library(dplyr)
library(rtweet)


# Task --------------------------------------------------------------------

# 1. Load in a list of twitter screen names
# 2. Retrieve maximum amount of tweets per user using rtweet
# 3. Retain only the relevant tweets
# 4. Get a count of tweets per user by month.
# 5. Save results to a csv.

# 1. Load Data ------------------------------------------------------------

# Save the 1 column csv (list of users) as a character vector.
users <- read.csv("data/users.csv") %>%
  pull()


# 2. Get Timelines --------------------------------------------------------

# Get the latest 3,200 tweets from each of the users in the vector.
tmls <- get_timeline(users,
                     n = 3200)

# 3.1 Create Function -----------------------------------------------------

# Create a function.
# This returns a dataframe containing only relevant tweets
# It looks in both the `text` and `retweet_text` columns

get_relevant_tweets <- function(dataset, pattern){
  
  # Define the columns to look in.
  columns <- paste(dataset[, "text"],
                   dataset[, "retweet_text"])
    
  # Get the indices of tweets using the pattern specified.
  indices <- grepl(pattern = pattern,
                   x = columns,
                   ignore.case = TRUE)
  
  # Keep only relevant indices.
  relevant_tweets <- dataset[indices, ]
  
  # Return tweets.
  return(relevant_tweets)
  
}


# 3.2 Get Relevant Tweets -------------------------------------------------

result <- get_relevant_tweets(tmls, "pandemic")

# 4. Get Monthly Breakdown ------------------------------------------------

# Reformat the date column to "month" only
result$created_at <- format(result$created_at, "%B")


# Get a count of tweets by user, by month.
result <- relevant_tweets %>%
  group_by(screen_name, created_at) %>%
  tally()

# 5. Save Results ---------------------------------------------------------

# Save the larger tmls dataframe for record-keeping.
rtweet::write_as_csv(tmls, "output/timelines1.csv")

# Write results.
write.csv(result, "output/rtweetResults.csv")
