cancer<- read.csv('https://archive.ics.uci.edu/ml/machine-learning-databases/breast-cancer-wisconsin/breast-cancer-wisconsin.data')

str(cancer)

names(cancer) <- c("id", "clumpThickness", "uniformityOfCellSize",
                       "uniformityOfCellShape", "marginalAdhesion", "singleEpithelialCellSize",
                       "bareNuclei", "blandChromatin", "normalNucleoli", "mitoses", "class")

cancer$id <- NULL
#removes id variable, don't need for analysis

cancer$bareNuclei <- as.numeric(cancer$bareNuclei)

cancer <- cancer[complete.cases(cancer),]
#We can then use the complete.cases function to identify the rows without missing data:

cancer$class <- factor(ifelse(cancer$class == 2, "benign", "malignant"))

trainingSet <- cancer[1:477, 1:9]
testSet <- cancer[478:698, 1:9]
#split to training and test set, 70/30 split

trainingOutcomes <- cancer[1:477, 10]
testOutcomes <- cancer[478:698, 10]
#outcome vectors (value to predict)

#We choose the number of neighboring data points to be considered in the analysis (i.e. k) 
#to be 21 as that's the square root of the number of training examples (477). 
#k should be an odd number to avoid "tie-breaker" situations.


library(class)
predictions <- knn(train = trainingSet, cl = trainingOutcomes, k = 21,
                   test = testSet)
#includes fit step, plus prediction step ("test =" is the prediction step)


table(testOutcomes, predictions)
#mismatches are false predictions (top right and bottom left)


#ABOUT KNN ################
#The labels of these neighbors are gathered and a majority vote or weighted vote is used for classification or regression purposes. 
#In other words, the higher the score for a certain data point that was already stored, the more likely that the new instance 
#will receive the same classification as that of the neighbor. In the case of regression, the value that will be assigned to 
#the new data point is the mean of its k nearest neighbors. (datacamp.com)


