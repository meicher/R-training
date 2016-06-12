# Chapter 5: Exploratory Data Analysis ##################

#2 important questions to ask:
#   What type of variation occurs within my variables?
#   What type of covariation occurs between my variables?

library(ggplot2)
ggplot(data = diamonds) +
  geom_bar(mapping = aes(x = cut))

#visualizing covariance in two categorical variables: use geom_count or table ###########

ggplot(diamonds) + 
  geom_count(aes(x = cut, y= color))
table(diamonds$cut,diamonds$color)

#visualizing covariance between a categorical and continuous variable: boxplotting #############

ggplot(mpg) +
  geom_boxplot(aes(x = class,y=hwy, fill = class))

#use reoorder and pass the median as function to sort the boxplots and make the trend easier to see
ggplot(data = mpg) +
  geom_boxplot(aes(x = reorder(class, hwy, FUN = median), y = hwy, fill = class)) +
  xlab('class') +
  coord_flip()


#visualizing 2 continuous variables: scatterplot/geom_point ##############
ggplot(data = diamonds) +
  geom_point(aes(x = carat, y = price))

#hard for scatterplot to effectively visualize when data set becomes large.
#geom_hex and geom_density2d help
ggplot(diamonds) +
  geom_hex(aes(x = carat, y = price))

ggplot(diamonds, aes(x = carat, y = price)) +
  geom_point() +
  geom_density2d()


ggplot(iris, aes(x = Sepal.Width, y = Sepal.Length, color = Species)) +
  geom_point() +
  geom_density2d()

#Clustering #################

#hierarchical clustering ############
#Heirarchical clustering uses a simple algorithm to locate groups of points that are near each other in n-dimensional space:
  
  #Identify the two points that are closest to each other
  #Combine these points into a cluster
  #Treat the new cluster as a point
  #Repeat until all of the points are grouped into a single cluster

small_iris <- sample_n(iris,50)

iris_hclust <- small_iris %>%
  select(Sepal.Length, Sepal.Width, Petal.Length, Petal.Width) %>%
  dist() %>%
  hclust(method = "complete")

#K-Means clustering ############

  #Randomly assign each data point to one of  kk  groups
  #Compute the centroid of each group
  #Reassign each point to the group whose centroid it is nearest to
  #Repeat steps 2 and 3 until group memberships cease to change

iris_kmeans <- small_iris %>% 
  select(Sepal.Length, Sepal.Width, Petal.Length, Petal.Width) %>% 
  kmeans(centers = 3, nstart = 20, iter.max = 50)

ggplot(small_iris, aes(x = Sepal.Width, y = Sepal.Length)) +
  geom_point(aes(color = factor(iris_kmeans$cluster)))


small_iris %>% 
  group_by(iris_kmeans$cluster) %>% 
  summarise(n_obs = n(), avg_width = mean(Sepal.Width), avg_length = mean(Sepal.Length))

# Chapter 6: Intro to Data Wrangling/tibbles ######################

#tibbles are like data frames but have some different properties - to convert a frame, list or table to tibble
#simply use as_data_frame()
# tibbles don't add row names, don't change any column names, and will not convert strings to factors
# just to name a few
library(dplyr)
iris_tbl<-as_data_frame(iris)

#[] subsetting will return a tbl df, and [[]] will always return a vector: key difference between
#   data frame subsetting and tibble subsetting
#if need be: as.data.frame() will return a tibble -> dataframe

#Chapter 7: Importing Data/readr package #############

# chapter 7 mainly explores using functions from the readr package as an alternative to
#   using base functions like read.csv(). Again, functions like read_csv() are similar to 
#   as_data_frame() in that it produces tibbles, doesn't alter column names, and will NOT convert
#   strings to factors. Although useful, I will skip this chapter and just be aware of readr as a useful package.


#Chapter 8: Tidy Data ##############################
#   "Tidy data sets are all alike but every messy dataset is messy in its own way". - Hadley Wickham

library(tidyr)

# 3 Principles of tidy data:
#   1. Each variable has its own column
#   2. Each observation is placed in its own row
#   3. Each value is placed in its own cell

#four functions: spread, gather, separate and unite

#spread turns key/value pair columns into tidy columns
#simple: pass name of df, name of key column, name of value column

spread(df, keycol, valuecol)

#gather does the reverse of spread(), condenses columns so that variables are in their own column
#pass dataframe, pass the name of the key column to create, followed by name of value column to create,
#finally specific which columns to collapse with integer notation

#>       country   1999   2000
#> 1 Afghanistan    745   2666
#> 2      Brazil  37737  80488
#> 3       China 212258 213766
gather(df, 'year','cases',2:3)

#separate and unite help you split and combine cells to place a single value in each cell
#separate is very similar to delimiting or parsing - will split a chr column to multiple based on
# a separator character.

#pass df, column to split, and then the columns to name, add "sep =" arg to specify the delimiter.
# it will try to auto split wherever it encounters a non-alphanumeric character, such as slashes
separate(table3, rate, into = c("cases", "population"))

#finally, you can pass numeric data to sep. This will then operate as position based delimiting
separate(table3, year, into = c("century", "year"), sep = 2)

# unite() is the inverse of separate(). Will combine.
unite(table6, "new", century, year, sep = "")

#by default, both separate and unite remove the columns which were used in creation.
# however you can set remove = FALSE to get rid of this behavior.

#Chapter 9: Working with Relational Data: JOINS##################

library(nycflights13)
airlines
#airlines, flights, weather, planes, airports are 5 different tables about the same information.
# can combine and answer questions using identifiers.

weather
airports
planes
airlines

library(dplyr)
library(tidyr)

#check for unique values
planes %>% count(tailnum) %>% filter(n > 1)

weather %>% count(year, month, day, hour, origin) %>% filter(n > 1)

#if a table has no primary key and no way to reliably create one based on the data:
# use row_number() to create an arbitrary PKEY. AKA: SURROGATE KEY

flights['flight_ID']<- row_number(flights[[1]])

batting<- Lahman::Batting

batting <- as_data_frame(batting)
unique_IDS<-batting %>% count(playerID, yearID, teamID,stint) %>% filter(n>1)
unique_IDS<- arrange(unique_IDS, playerID)

batting %>% count(playerID) %>% filter(n>1)
unique_IDS
filter(batting,playerID == 'clarkni01')

new<- inner_join(flights,planes, by = 'tailnum')
#notice we lost some observations from flights using inner_join because of missing values: tailnums.

#outer join will keep observations found in 1 of the tables, inner join keeps only those found in both.
# left join: keeps obs in x
# right join: keeps obvs in y
# full join: keeps obvs in both x and y (filled with NA if no matching observation for that key)
#another way to think about left and right joins - they are simply matching by key and 
#dropping those keys that are in y, but not x (in the case of a left join)

new<- full_join(flights,planes, by = 'tailnum')
#now we have full data set, but the tailnum is simply NA.


#the left join should be your default join, just because its so common to want to maintain observation in your
# 'x' dataset even when there isn't a match.

#To match by diff named variables: by = c("a" = "b"). This will match variable a in table x to 
#variable b in table y. The variables from x will be used in the output.
flights2 %>% left_join(airports, c("dest" = "faa"))

#filtering joins ##############

#filtering joins match observations in the same way as convential joins, but they affect 
# observations instead of the variables. (They limit results returned, not adding columns)

#semi_join(x, y) keeps all observations in x that have a match in y.
#anti_join(x, y) drops all observations in x that have a match in y.


#Set operations ##########

#these operations assume that your x and y have the same variables

#intersect(x, y): return only observations in both x and y.
#union(x, y): return unique observations in x and y.
#setdiff(x, y): return observations in x, but not in y.

#CHAPTER 10: STRINGS + REGEX ################

library(stringr)

x <- c("Apple", "Banana", "Pear")
str_sub(x, 1, 3)

#regular expressions
str_match_all(x,'a.')

x <- "a\\b"
writeLines(x)
str_match(x,'\\\\')
str_detect(x,'\\\\')
#\\. to find a single '.' via regex. This is because backslash escapes for STRINGS and REGULAR EXPRESSION.
# so really, you are escaping the backslash, which is escaping the period.
# \\. simplifies to string \. which is the string we want to pass as the regular expression.
writeLines('\\.')

#valuable to ANCHOR our regex, or match from start/end of strings
# ^ matches from start of string
# $ matches from end of string

#to force a regex to match a complete string, anchor with ^ and $
x <- c("apple pie", "apple", "apple cake")
str_match(x, "apple")
str_match(x, "^apple$")

#.: any character apart from a newline.
#\d: any digit.
#\s: any whitespace (space, tab, newline).
#[abc]: match a, b, or c.
#[!abc]: match anything except a, b, or c.

#REPETITION FACTORS
#?: 0 or 1
#+: 1 or more
#*: 0 or more
#{n}: exactly n
#{n,}: n or more
#{,m}: at most m
#{n,m}: between n and m

str_match(fruit, "(..)\\1")
#this regex finds all fruit that has two characters that are repeated.
#parenthesis act as forming groups, which can be referenced with backreferences '\1','\2' and so on

x<- c('strrraab','bananana','mangogo','maango')
str_match(x,"(..)\\1")
#will find a pair of letters that are repeated


#Keep in mind, TRUE evals to 1 and False to 0, so you can use things like sum/mean in combo
# with str_detect to answer some questions.
# How many common words start with t?
sum(str_detect(common, "^t"))
#> [1] 65


#str_subset will return the actual matches, not just the logical vector
#str_count will return the number of matches within each string

#if we wanted to find all sentences/strings that contains a color, we can do this
colours <- c("red", "orange", "yellow", "green", "blue", "purple")
colour_match <- str_c(colours, collapse = "|")


#10.3.4 grouped matches
