# Data-Analysis-Projects
Hello, this folder is full of my Data Analysis Projects. I'll be updating it as I come up with new ones.

# WALS project (being updated)

Technologies used: Python (Sci-kit, Pandas)

This was an exploratory project where I implemented machine learning clustering methods to categorize languages with common linguistic features. Ultimately I wanted to see if this would have any correspondence with areal groupings, as in if they were in a similar area, or genealogical families, if they shared a common ancestor language. Ultimately it was rather unrelated to either, as I had not properly cleaned and pre-processed the data. Many of the variables were categorical but had been assigned numerical values, and at the time, I did not understand how this could impact the results.

Right now I am working on cleaning the data. Since it the data points are all linguistic features, I have sufficient domain knowledge to feature engineer the categorical data, hopefully leading to a better result.

# California Census Project
Technologies used: SQL, Python (Pandas)

This is a project where I tried to predict some possible upcoming, at the time, changes to the delineations of Metropolitan Statistical Areas in California. Specifically, I wanted to know if the Inland Empire would be joined with the Los Angeles MSA and if San Jose would be joined with the San Francisco MSA. Both of these regions have a Combined Statistical Area, a grouping for multiple Metros with a high degree of overlap, with the MSA they could be joined to, but also had completely contiguous urbanized areas with them. So I wanted to know if the past 10 years has caused them to become more blended.

I used Pandas to do some light aggregation, since much of the data was by census block but the ultimate result needed to be by county, and exported it to MySQL. I then ran some complex SQL queries using Windows and Cases to create tables to convey the specific measurements needed to determine this.

My ultimate conclusion for the Inland Empire was that it would likely be included in the Los Angeles MSA, especially San Bernardino County,. Riverside County is on the borderline as it has met the threshold in my data, but could be just under in more complete data.

My ultimate conclusion for San Jose was the opposite, Santa Clara County would definitely not be included in the San Francisco MSA, as it has its own economic pull despite crossover with the rest of the Bay Area.
