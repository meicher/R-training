
library(ggvis)

iris %>% 
  ggvis(~Sepal.Length, ~Sepal.Width, fill = ~Species) %>%
  layer_points() %>%
  layer_smooths()

iris %>%
  ggvis(~Petal.Length,~Petal.Width,fill=~Species)

table(iris$Species)
#shows the different values by count

library(class)

#check for needed normalization by looking at the min/max of different predictor variables.
#doesn't need normalization: all b/w 1 and 7.9
#FOLLOWING EXAMPLE OF NORMALIZATION-------------------
summary(iris)

normalize<- function(x){
  num<- x-min(x)
  denom<- max(x) - min(x)
  return (num/denom)
}

iris_norm<- as.data.frame(lapply(iris[1:4],normalize))
iris_norm
summary(iris_norm)
#numeric variables now range 0 to 1.

#set seed to make model reproduce on same training/test sets
set.seed(1234)

#2/3 to 1/3 split
ind<-sample(2,nrow(iris),replace=TRUE,prob=c(.67,.33))

iris.training<- iris[ind==1,1:4]
iris.test<- iris[ind==2,1:4]

iris.trainLabels<- iris[ind==1,5]
iris.testLabels<- iris[ind==2,5]

iris_pred<- knn(train= iris.training, test = iris.test, cl = iris.trainLabels, k =3)
iris_pred

#cbind.data.frame prevents factors from being converted to their numeric equivalent
acc<- (cbind.data.frame(iris_pred,iris.testLabels))
acc['correct']<- acc[1] == acc[2]
acc

library(gmodels)
#make a cross tabulation or contingency table

CrossTable(x= iris.testLabels,y= iris_pred,prop.chisq=FALSE)
#this graph is confusing AF, and I wouldn't use it again
#shows by top row, 20/22 for versicolor, mislabeld as virginica



