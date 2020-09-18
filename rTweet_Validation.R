# Libraries ---------------------------------------------------------------

library(tidyverse)


# About -------------------------------------------------------------------

# Did I actually capture tweet history stemming back to May 2020?
# How many "power users" are there, and did they hit the 3,200 RTweet limit?

# I read in the timelines and get a count.

# Data Prep ---------------------------------------------------------------

# Read in the timelines
x <- read_csv("output/timelines1.csv")
y <- read_csv("output/timelines2.csv")
z <- read_csv("output/timelines3.csv")

# Combine into a dataframe.
df <- rbind(x, y, z)

# Get Power Users ---------------------------------------------------------

# Get a list of users who tweeted over 3,000 times.
power_users <- df %>%
  group_by(screen_name) %>%
  tally() %>%
  arrange(desc(n)) %>%
  filter(n > 3000)

# Filter the dataframe by these `hicount` users.
power_user_tweets <- df %>%
  filter(screen_name %in% power_users$screen_name)

# Check for Completeness --------------------------------------------------

# Reformat the date column, for ease of manipulation.
power_user_tweets$created_at <- format(power_user_tweets$created_at, "%B")

# How many of their 3000 tweets came from September?
september_tweets <- power_user_tweets %>%
  group_by(screen_name, created_at) %>%
  tally() %>%
  filter(created_at == "September")

# And how many tweeted mostly this last month, indicating data is missing?
incomplete_timelines <- september_tweets %>%
  filter(n > 3000)

# Total number of users with over 3,000 tweets in this last month.
nrow(incomplete_timelines)
