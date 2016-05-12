
#Computing Robust Statistics for bivariate associations ----------------------

install.packages('quantreg')
library(quantreg)

#will be doing quantile regression

data(engel)

attach(engel)
#attach allows shortcut references to data set columns

plot(income,
     foodexp,
     cex=.5)

points(income,
       foodexp,
       pch=16,
       col='lightgray')


taus<- c(.05,.1,.25,.75,.9,.95)
#quantiles

xx<- seq(min(income),max(income),100) #X values
f<- coef(rq((foodexp)~(income),tau=taus)) #coefficients
yy<-cbind(1,xx)%*%f #y values

for(i in 1:length(taus)){ # for each quantile value
  lines(xx,yy[,i], col='darkgray')     #draw regression line
}

abline(lm(foodexp ~ income), #Standard LS regression
       col='darkred',
       lwd=1)

abline(rq(foodexp ~ income),   #Median regression - much less affected by outlier
       col= 'blue',
       lwd =1)

legend(3000,1000,
       c('meanfit','medianfit'),
       col= c('darkred','blue'),
       lty=1,
       lwd=2)

detach(engel)


x<- c(31,57)
n<- c(72,96)

prop.test(x,n)



#CHAPTER 8: Charts for 3+ Variables #############

#Creating clustered bar chart for frequencies #######################

#load warpbreaks data
str(warpbreaks)

data<- tapply(warpbreaks$breaks,
              list(warpbreaks$wool, warpbreaks$tension),mean)   
#creates a 2x3 matrix 


barplot(data,
        beside=TRUE,
        col=c('steelblue3','thistle3'),
        bor=NA)


# for legend, locator(1) is interactive and lets you click where you want to put the legend.
#run this code and then click on plot to place legend.
legend(locator(1),
       rownames(data),
       fill=c('steelblue3','thistle3'))


#Creating scatterplots for grouped data ####################

str(iris)
install.packages('car')
library(car)



#single scatterplot with groups marked
#fxn can be called with sp or scatterplot
#chart width as a function of length, broken down by species#
sp(Sepal.Width ~ Sepal.Length | Species,
   data = iris,
   main = 'Iris Data',
   labels = row.names(iris))

#good way to show x,y relationship for 3 different groups on THE SAME SCATTER PLOT




#Creating a scatterplot Matrix #############################

data(iris)
str(iris)

attach(iris)

pairs(iris[1:4])
#chart first 4 variables - these are the quantitative variables

#Modified scatterplot matrices

#create palette with RColorBrewer

require('RColorBrewer')
display.brewer.pal(3,'Pastel1')
#displays colors which will be used


#put histograms on the diangol (see 'pairs' for help)
panel.hist<- function(x,...)
{
  usr<- par('usr');on.exit(par(usr))
  par(usr = c(usr[1:2],0,1.5))
  h<- hist(x,plot=FALSE)
  breaks<- h$breaks;nB<- length(breaks)
  y<- h$counts; y<- y/max(y)
  rect(breaks[-nB],0,breaks[-1],y, ...)
  #removed col = cyan from code block
}

pairs(iris[1:4],
      panel= panel.smooth,
      diag.panel = panel.hist,
      pch=16,
      col= brewer.pal(3,'Pastel1')[unclass(iris$Species)]) # this tells it to color according to the species
#looks much better


#similar with 'car' package
#gives kernel density and rugplot for each variable

library(car)
scatterplotMatrix(~Petal.Length + Petal.Width + Sepal.Length + Sepal.Width | Species,
                  data = iris,
                  col = brewer.pal(3,'Dark2'))


#CREATING 3d Scatterplots #########################

#spinning 3d scatterplot
#install and load rgl package
#however this is not compatible with R studio.


#CHAPTER 9: COMPUTING A MULTIPLE REGRESSION ######################


data(USJudgeRatings)

head(USJudgeRatings)

#FIRST IS OUTCOME VARIABLE, and then predictor variables after tilde
reg1<- lm(RTEN ~ CONT + INTG + DMNR+DILG+CFMG+DECI+PREP+FAMI+ORAL+WRIT+PHYS,
          data = USJudgeRatings)

reg1 # gives coeeficients only, join function
#negative coefficient in multiple regression may have a positive association if we tested it individually
#notice the coeficents change
lm(RTEN ~ CFMG + DILG, data = USJudgeRatings)

summary(reg1)
#gives p values with it
#adjusted R squared of .98, if we know the judges scores on these 11,  
#we can predict ninety eight or ninety nine percent of the variants on worthy of retention.
#The F-statistic, highly significant, so we have very, very, very good prediction from this model
  #f stat is calculated by dividing SSBetween (diff between)/SSW (diff within groups). Large number means variation 
  #between groups is due more to difference between groups
  #need to use f-table to find CRITICAL F VALUE. IF F-Value > Critical Value, then SIGNIFICANT
# t-test for single variable, f-test for group of variables


#more detailed summaries
anova(reg1)

#possibility of stepwise variables selection
# (backwards and forwards); exercise caution!

#backwards stepwise regression
regb<- step(reg1,
            direction = 'backward',
            trace= 0) # dont print every step


summary(regb)


#forward stepwise regression
#start with model with constant and add variables


#COMPARING MEANS WITH 2-FACTOR ANOVA ###############
#allows you to use is two categorical predictor variables in a single quantitative outcome

data(warpbreaks)
head(warpbreaks)

#model with interaction
aov1<- aov(breaks ~
             wool + tension + wool:tension,
           # or: wool*tension (interaction of the two)
           data = warpbreaks)

summary(aov1)
model.tables(aov1,type='means')


TukeyHSD(aov1)



#CLUSTER ANALYSIS (KMEANS & HIERARCHICAL ANALYSES) ################

data(mtcars)
head(mtcars)

mtcars1<- mtcars[,c(1:4,6:7,9:11)]
#take a couple columns out

#three major kinds of clustering:
#   1- split into set number of clusters (kmeans)
#   2- hierarchical: start separate and combine
#   3- Dividing: start with single group and split

#we'll use hierarchical method
#Need distance matrix (dissimilarity Matrix)
#   eg. based on all of the variables in the dataset, miles per gallon and so on, 
#   you need to figure out how similar. Or how different each of the cars is from each of the cases. 

d<- dist(mtcars)

c<- hclust(d)
# use distance matrix for clustering , hclust = hier clust

plot(c)

#put observations in groups
#need to specify height = h or groups = k
g3<- cutree(c,k=3)


#or do several levels of groups at once
#'gm' = 'groups/multiple'
# shows which cluster each falls into, depending on k value
gm<- cutree(c,k=2:5) 
gm

#draw boxes around clusters
rect.hclust(c,k=3,border='tomato1')
rect.hclust(c,k=4,border='yellow')


#k-means clustering
km<- kmeans(mtcars1,3)
km

require(cluster)

clusplot(mtcars1,
          km$cluster,
          color=TRUE,
          lines=3,
          labels=2)

