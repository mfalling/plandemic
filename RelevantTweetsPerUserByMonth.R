# Libraries ---------------------------------------------------------------

library(tidyverse)
library(rtweet)


# About -------------------------------------------------------------------

# Retrieves maximum amount of tweets per user within a given time-period.
# Filters the tweets by a query term, looking in text and retweet_text.
# Gets a count of relevant tweets, per user, per month.
# Saves to a CSV.


# Data Prep ---------------------------------------------------------------

# Load in users
users <- read.csv("users.csv") %>%
  pull()


# Get timelines
timelines <- get_timeline(users,
                          n = 3200,
                          since = '2020-05-01',
                          until = '2020-08-31')

# Reformat the date column to "month" only.
# Note: Reconsider the format if querying across multiple years.
timelines$created_at <- format(timelines$created_at, "%B")

# Getting Relevant Tweets -------------------------------------------------

# Get the indices
relevant_tweets_indices <- grepl(pattern = "plandemic",
                                 x = paste(timelines$text, 
                                           timelines$retweet_text),
                                 ignore.case = TRUE)

# Keep only relevant indices.
relevant_tweets <- timelines[relevant_tweets_indices, ]



# Filter and Save. ---------------------------------------------------------

# Group relevant tweets by user, by month.
user_tweets_per_month <- relevant_tweets %>%
  group_by(screen_name, created_at) %>%
  tally()

# Write results.
write.csv(user_tweets_per_month, "rtweetResults.csv")



# Find missing results ----------------------------------------------------

# Which accounts did we get info on?
captured <- timelines %>%
  distinct(screen_name) %>%
  pull()

# Add the "@" back, to match `users`.
captured <- paste("@", captured, sep = "")

# Get list of missing users (deleted and private accounts)
missing <- setdiff(users, captured)
