# Libraries ---------------------------------------------------------------

library(dplyr)



# Task --------------------------------------------------------------------
# Question: Is the rTweet data complete?

# 1. Read in rTweet timeline csv files.
# 2. Locate missing users, if any exist (deleted/private accounts)
# 3. Get a list of "power users" (over 3000 tweets)
# 4. Check for completeness of the data.

# 1. Load Data ------------------------------------------------------------

# Read in the original users file
users <- read_csv("data/users.csv")

# Read in the rTweet timelines
tmls1 <- read_csv("output/timelines1.csv")
tmls2 <- read_csv("output/timelines2.csv")
tmls3 <- read_csv("output/timelines3.csv")

# Combine the timelines into a single dataframe
tmls <- rbind(tmls1, tmls2, tmls3)

# 2. Locate Missing Users -------------------------------------------------

# Which accounts did we get info on?
captured <- tmls %>%
  distinct(screen_name) %>%
  pull()

# Reformat the captured usernames to match the `users` file
captured <- paste("@", captured, sep = "")

# Get list of missing users(deleted and private accounts)
missing <- setdiff(users, captured)


# 3. Get Power Users ------------------------------------------------------

# Get a list of users who tweeted over 3,000 times.
power_users <- tmls %>%
  group_by(screen_name) %>%
  tally() %>%
  filter(n > 3000) %>%
  arrange(desc(n))

# Get their tweets.
power_user_tweets <- tmls %>%
  filter(screen_name %in% power_users$screen_name)


# 4. Check for Completeness -----------------------------------------------

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
