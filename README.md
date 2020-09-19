# plandemic
Scripts pertaining to the plandemic subproject

**Task:**


Get a count of tweets per user, broken down by month. Results should range from May to August.  

**Background:**  


Our lab constantly ingests data using twitter's stream API. Due to our collection method, we are only capturing a small fraction of a user's total post count.  

A colleague required a breakdown of tweets per user by month. I explored using rTweet to access historical user data. rTweet is capable of capturing the latest 3,200 tweets per user. I hypothesized that this would return more complete data than relying on our extant dataset.  

**Method & Results:**  


I collected roughly 400,000 tweets from the users on our list. I manipulated the data to show a count of tweets per user, broken down by month. I applied a similar manipulation technique to obtain a breakdown for our extant dataset.  

According to the rTweet results, nearly half of the users tweeted over 3,000 times in September alone. We do not have their complete tweet history starting from May. RTweet found a higher quantity of tweets per user because it "deep dives" into a user's history, but only for regular users. "Power users" are not represented in the results at all (May to August), as they hit the 3,200 tweet cap within the first two weeks of September. Our dataset is more consistent because of the constant data ingestion, but it does not capture the full extent of a person's activity (only a fraction of activity).  

As an example, rTweet found ~40 relevant tweets from a user in May. Our dataset only captured 5 tweets. That said, our dataset found results (even if they are minimal) for all users across all four months. Comparatively, rTweet only an increasing fraction of users over time -- The quantity increases as we get closer to present day, due to the 3,200 limit.  

**Conclusion:**  


For this immediate project, it is best to use our extant dataset. We can assume that the stream API is not introducing systemic differences in the amount of tweets collected per user. While this approach will produce a lower frequency of posts per user, it should not matter for the purposes of our immediate analysis. If we will be interested in approximing the true number of posts per user by month, we should determine a method to scale the results (considering that there may be systemic differences in frequency between users, which may be accounted for using other parameters). 

Using rTweet is only a valid approach if we're interested in casual Twitter users, or if we intend to run this script at regular frequencies. This method does not capture history for "power users" who post thousands of tweets a month, but scheduled API calls should ensure that no data is missed. Using rTweet consistently may help retroactively address the problem of scale.
