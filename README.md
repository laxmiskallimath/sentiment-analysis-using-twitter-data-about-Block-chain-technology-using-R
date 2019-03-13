
Final Project 3:- Twitter sentiment analysis on Block chain technology around the world 
                  Objective:- Find out Opinion about Block chain technology  around the world 
1)	As a part of Certification, my final Project was Sentiment analysis on Block Chain technology using twitter data in R.
2)	Here i created my own app in twitter  web page  got authorisation user id and password to access the tweets  for sentiment analysis( Twitter web scraping) 
3)	Used  twitteR,ROAuth packages to access the tweets
4)	We extracted around 5000 tweets about Block chain technology by giving recent search type 
5)	Saved all these tweets in CSV format thereby we can use same tweets for analysis as it was time consuming to Extract the tweets from twitter 
6)	Cleaned unstructured text data using tm (text mining) package and created term document matrix, in which most frequently occurred words.
7)	For the graphical representation of text data we used  wordcloud package and created word cloud ,words which are very large are frequently occurred words 
8)	After text data cleaning we directly moved to main objective of Project i.e sentiment analysis about the Block chain technology around the world 
9)	For this objective we used syuzhet, ggplot,reshape2,dplyr packages to get sentiment scores for each and every word for different emotions .
10)	At the end we got maximum positive sentiment score about Block chain technology, which means there is a positive view about the block chain technology around the world.
