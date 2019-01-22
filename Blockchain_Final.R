setwd("E:/Laxmi/Others/blockchain")
require(twitteR)
require(RCurl)
require(ROAuth)
consumerkey <- "FUo0LCZZHgv36cblEWFW0iwoL"
consumersecret <-"TRqLqWTDcmP1mmV9bGzJ1F1F8fjUrvVWX1UeB1Axjz42ap6QiH"
accesstoken <-"1017110339362611200-F6muIjWSd7qsEskksnL3R3OPbgK7QR"
accesstokensecret <-"ZxI7xyOXy8GH3Lb7sMmYAtbMwBOGwiSDpDemTg9wiYvQ1"
setup_twitter_oauth(consumerkey,consumersecret,accesstoken,accesstokensecret)

# Getting tweets 
Blockchain_tweets <- searchTwitter("BlockChain",n=5000,lang = "en",resultType = 'recent')
Blockchain_tweets
class(Blockchain_tweets)

# save it in data frame 
tweetsdf <- twListToDF(Blockchain_tweets)
write.csv(tweetsdf,file = "Blockchain.csv")

# Read file 
Blockchain <- read.csv("Blockchain.csv")
str(Blockchain)

# Build Corpus 
# Corpus is collection of Documents in which each tweet will be treated as Document 
library(tm)
corpus <- iconv(Blockchain$text,to="utf-8")
corpus <- Corpus(VectorSource(corpus))
inspect(corpus[1:5])

# Data Cleaning / Clean Text 

# Convert to Lower case
corpus <- tm_map(corpus,tolower)
inspect(corpus[1:5])

# Remove punctuation
corpus <- tm_map(corpus,removePunctuation)
inspect(corpus[1:5])

# Remove numbers 
corpus <- tm_map(corpus,removeNumbers)
inspect(corpus[1:5])

# Take out some english words which are so common that not adding much value 
# i.e remove stopwords
Cleanset <- tm_map(corpus,removeWords,stopwords('english'))
stopwords('english')
inspect(Cleanset[1:5])

# Get rid of urls like https
removeURL <- function(x)gsub('http[[:alnum:]]*','',x)
Cleanset <- tm_map(Cleanset,content_transformer(removeURL))
inspect((Cleanset[1:5]))

# As an when something is removed it leaves a white space to get rid of that
Cleanset <- tm_map(Cleanset,stripWhitespace)
inspect((Cleanset[1:5]))


# Text data like tweets is unstructured data  and to do any 
# further analysis we have to convert this unstructured data in to structured 
# data that is in rows and columns which is achived by term document matrix 

# TermDocumentMatrix
tdm <- TermDocumentMatrix(Cleanset)
tdm
#  In tdm there are words /terms No = 8582
#  no of Documents = 5000
#  here saprsity is 100% which means 100% of times will see '0' in this matrix

# If we convert tdm in to matrix 
tdm <- as.matrix(tdm)

# To get an idea how it looks ,select 1:10 words and 1:20columns
tdm[1:10,1:20]
# we can see here fintechweek appears in 1st tweet for two times 
# similarly fintechâ??? appears in 15th tweet for 1 time 

# we can get rid off frequently occuring words to get rid off them 
Cleanset <- tm_map(Cleanset,removeWords,c('blockchain ','can','bitcoin','technology','will'))

# # Barplot:- we can find how aften each word apears in this data set by doing 
# rowsum of tdm# Here we get each word frequency in the dataset

w <- rowSums(tdm)
w

w <- subset(w,w>=50)# Whenever the frequency is more than 50 we store it as w 
w
barplot(w,
        las=2,
        col=rainbow(50))

barplot(w,
        las=3,#make labels parpendicular to axis
        col=rainbow(50))
# Highest is Blocchain and industries 

# Word cloud
library(wordcloud)
w <- sort(rowSums(tdm),decreasing = T)

# For repeativity 
set.seed(222)
wordcloud(words = names(w),freq = w)


wordcloud(words = names(w),freq = w,col=rainbow(50))

# biggerword means that is the frequent word and all the discussion abt technology

# We can play with wordcloud
wordcloud(words = names(w),freq = w,max.words = 150,random.order = F,
          min.freq = 5,colors = brewer.pal(8,"Dark2"),scale = c(7,0.3),rot.per = 0.3)


# max.words = 150 in no's
# min.freq = any word that apears more than 5 times will be included in wordcloud 
#  scale(max frequent word,min frequent word )
#  rot.per = 30 % of words should be rotated

wordcloud(words = names(w),freq = w,max.words = 50,random.order = F,
          min.freq = 2,colors = brewer.pal(4,"Dark2"),scale = c(5,0.2),rot.per = 0.7)#China

wordcloud(words = names(w),freq = w,max.words = 600,random.order = F,
          min.freq = 15,col=rainbow(50))
          

# Wordcloud2
library(wordcloud2)

w <- data.frame(names(w),w)

colnames(w) <- c('word','freq')

head(w)

wordcloud2(w,size = 0.8 ,shape='circle')

wordcloud2(w,size = 0.1,shape = 'star')

wordcloud2(w,size = 0.5,shape = 'triangle')


# sentiment analysis 
library(syuzhet)
library(lubridate)
library(ggplot2)
library(scales)
library(reshape2)
library(dplyr)

# Read file
Blockchain <- read.csv("Blockchain.csv")

tweets <- iconv(Blockchain$text,to="utf-8")

# Obtain sentimentscore(tweets)
sentiments <- get_nrc_sentiment(tweets)#nrc will call sentiment score for each
                              #and every word for different emotions

# Will see  head of sentiments 
head(sentiments)
#here sentiments ranges from anger to negative and positive 
# For example first tweet has o scores for all columns except trust and positive 

# Lets check 1st tweet
tweets[1]

# Lets check 4th tweet
tweets[6]
# lets see wahat is the sentiment for thank
get_nrc_sentiment('interactions')

# Positive words
get_nrc_sentiment('loans')
get_nrc_sentiment('bank')
get_nrc_sentiment('blockchain')
get_nrc_sentiment('land')
twitter
# Negative words
head(sentiments,10)
tweets[7]
get_nrc_sentiment('blast')
get_nrc_sentiment('thanks')

# Bar plot
barplot(colSums(sentiments),las=3
        ,col=rainbow(10),ylab = 'count',main = 'Sentiment scores for blockchain')
# highest bar is for positive so sentiment is positive so people are thinking 
# that blochain tecnology is good ,people also thinking trust and anticipation
# and joy towards the blocchaintechnology


