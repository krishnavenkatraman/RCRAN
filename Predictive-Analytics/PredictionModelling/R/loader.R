# installing a package
# install.packages("readr")
# Installing the Caret Package
#install.packages("caret", dependencies = c("Depends", "Suggests"))
# Calling on a Package
library(readr)
#library(caret)
#DatasetName<- read.csv("/Users/krishnav/Desktop/Workbench/Cisco_Lenovo_Laptop/misc/personal/UT-Data-Analytics/Study-Materials/Chapter-2/Task-1/R-Tutorial-Data-Sets/cars.csv")
IrisDataset<- read.csv("/Users/krishnav/Desktop/Workbench/Cisco_Lenovo_Laptop/misc/personal/UT-Data-Analytics/Study-Materials/Chapter-2/Task-1/R-Tutorial-Data-Sets/iris.csv")
attributes(IrisDataset) #List your attributes within your data set.

summary(IrisDataset) #Prints the min, max, mean, median, and quartiles of each attribute.

str(IrisDataset) #Displays the structure of your data set.

names(IrisDataset) #Names your attributes within your data set.

IrisDataset$Petal.Width #Will print out the instances within that particular column in your data set.

#hist(IrisDataset$Species) # Histogram Plot

plot(IrisDataset$Species,IrisDataset$Petal.Length) # Scatter (Box) Plot

#qqnorm(IrisDataset$Species)  # Normal Quantile Plot

IrisDataset$Petal.Length<- as.numeric(IrisDataset$Petal.Length) #  convert data types


names(IrisDataset)<-c("SepalLength","SepalWidth","PetalLength" ,"PetalWidth", "Species") #  rename the attributes/columns in your dataset

summary(IrisDataset) #Will count how many NA’s you have.

is.na(IrisDataset) #Will show your NA’s through logical data. (TRUE if it’s missing, FALSE if it’s not.)

na.omit(IrisDataset$Petal.Length) #Drops any rows with missing values and omits them forever.

na.exclude(IrisDataset$Petal.Length) #Drops any rows with missing values, but keeps track of where they were.

#DatasetName$speed.of.car[is.na(DatasetName$Petal.Width)]<-mean(DatasetName$Petal.Width,na.rm = TRUE)

set.seed(405)

trainSize<-round(nrow(IrisDataset)*0.20)

testSize<-nrow(IrisDataset)-trainSize

trainSize

testSize

#create the training and test sets
training_indices<-sample(seq_len(nrow(IrisDataset)),size =trainSize)

trainSet<-IrisDataset[training_indices,]

testSet<-IrisDataset[-training_indices,]


LinearModel<-lm(trainSet$PetalWidth~ trainSet$PetalLength) # create  model for linear model function

summary(LinearModel)

PredictionsName<-predict(LinearModel, testSet)

PredictionsName










