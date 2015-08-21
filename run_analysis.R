# Check if the required package is available on the machine. If not, install it.
if("reshape2" %in% rownames(installed.packages()) == FALSE){
  install.packages("reshape2")
}

# Use the reshape2 library
library(reshape2)

# Set values for download URL, local file name, and extracted data folder name
downloadUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
localFileName <- "getdata_projectfiles_FUCI_HAR_DataSet.zip"
extractedDataFolder <- "UCI HAR Dataset"

# function to generate path to the data file of interest
generateDataPath <- function(subFolderPath, fileName){
  generatedPath <- paste("./",extractedDataFolder,"/",sep="")
  if(subFolderPath == ""){
    generatedPath <- paste(generatedPath,fileName,sep="")
  }else{
    generatedPath <- paste(generatedPath,subFolderPath,"/",fileName, sep="")
  }

  return (generatedPath)
}

# If the zip file does not exist, download it
if(!file.exists(localFileName)){
  download.file(downloadUrl,localFileName, method="curl")
}

# if the extracted data folder does not exist, extract it
if(!file.exists(extractedDataFolder)){
  unzip(localFileName)
}

# Read in activity labels and features
activityLabels <- read.table(generateDataPath("","activity_labels.txt"))
activityLabels[,2] <- as.character(activityLabels[,2])
features <- read.table(generateDataPath("", "features.txt"))
features[,2] <- as.character(features[,2])

filteredFeatures <- grep(".*mean.*|.*std.*", features[,2])
filteredFeatures.names <- features[filteredFeatures,2]
filteredFeatures.names = gsub('-mean','Mean',filteredFeatures.names)
filteredFeatures.names = gsub('-std','Std',filteredFeatures.names)
filteredFeatures.names <- gsub('[-()]','',filteredFeatures.names)

# Load data
train <- read.table(generateDataPath("train","X_train.txt"))[filteredFeatures]
trainActivities <- read.table(generateDataPath("train","Y_train.txt"))
trainSubjects <- read.table(generateDataPath("train","subject_train.txt"))
train <- cbind(trainSubjects, trainActivities, train)

test <- read.table(generateDataPath("test","X_test.txt"))[filteredFeatures]
testActivities <- read.table(generateDataPath("test","Y_test.txt"))
testSubjects <- read.table(generateDataPath("test","subject_test.txt"))
test <- cbind(testSubjects, testActivities, test)

# Merge datasets
combinedData <- rbind(train, test)
colnames(combinedData) <- c("subject", "activity", filteredFeatures.names)

# Make activities and subjects into factors
combinedData$activity <- factor(combinedData$activity, levels = activityLabels[,1], labels = activityLabels[,2])
combinedData$subject <- as.factor(combinedData$subject)

combinedData.melted <- melt(combinedData, id = c("subject", "activity"))
combinedData.mean <- dcast(combinedData.melted, subject + activity ~ variable, mean)

write.table(combinedData.mean, "tidy.txt", row.names = FALSE, quote = FALSE)

