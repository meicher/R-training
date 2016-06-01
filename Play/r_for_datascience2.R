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



