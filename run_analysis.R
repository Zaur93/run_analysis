fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, destfile="C:\Users\mzaur\OneDrive\Documents\Data")
unzip("UCIdata.zip", files = NULL, exdir=".")
sbj_test <- read.table("UCI HAR Dataset/test/subject_test.txt")
sbj_train <- read.table("UCI HAR Dataset/train/subject_train.txt")
X_test <- read.table("UCI HAR Dataset/test/X_test.txt")
X_train <- read.table("UCI HAR Dataset/train/X_train.txt")
y_test <- read.table("UCI HAR Dataset/test/y_test.txt")
y_train <- read.table("UCI HAR Dataset/train/y_train.txt")
actlabels <- read.table("UCI HAR Dataset/activity_labels.txt")
features <- read.table("UCI HAR Dataset/features.txt") 
dataSet <- rbind(X_train,X_test)
MeanStdOnly <- grep("mean()|std()", features[, 2]) 
dataSet <- dataSet[,MeanStdOnly]
CleanFeatureNames <- sapply(features[, 2], function(x) {gsub("[()]", "",x)})
names(dataSet) <- CleanFeatureNames[MeanStdOnly]
subject <- rbind(sbj_train, sbj_test)
names(sbj) <- 'subject'
activity <- rbind(y_train, y_test)
names(act) <- 'activity'
dataSet <- cbind(subject,activity, dataSet)
act_group <- factor(dataSet$activity)
levels(act_group) <- activity_labels[,2]
dataSet$activity <- act_group
if (!"reshape2" %in% installed.packages()) {
  install.packages("reshape2")
}
library("reshape2")

  baseData <- melt(dataSet,(id.vars=c("subject","activity")))
  secondDataSet <- dcast(baseData, subject + activity ~ variable, mean)
  names(secondDataSet)[-c(1:2)] <- paste("[mean of]" , names(secondDataSet)[-c(1:2)] )
  write.table(secondDataSet, "tidy_data.txt", sep = ",")