#Packages Used
library(RCurl)
options(RCurlOptions = list(cainfo = system.file("CurlSSL", "cacert.pem", package = "RCurl")))
library(dplyr)

#Downloading and unzipping the data
###################################

#Creating the directory if it does not exist
if(!file.exists("C:\\Users\\Owner\\Desktop\\Getting and Cleaning Data")){ 
    dir.create("C:\\Users\\Owner\\Desktop\\Getting and Cleaning Data")   
}
#Downloading the file
file.url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(file.url, destfile = "C:\\Users\\Owner\\Desktop\\Getting and Cleaning Data\\Data.zip", method = "libcurl") 
#unzipping the file
unzip(zipfile="C:\\Users\\Owner\\Desktop\\Getting and Cleaning Data\\Data.zip",
      exdir="C:\\Users\\Owner\\Desktop\\Getting and Cleaning Data")

#Reading files which make up complete dataset
#############################################

#Creating filepath to the common folder containing the data
Dataset_path <- "C:/Users/Owner/Desktop/Getting and Cleaning Data/UCI HAR Dataset"
#Examining Contents of Dataset
file_list <- list.files(path= Dataset_path, recursive = TRUE)
file_list

##Read file with names of variables in dataset##
Features  <- read.table(file.path(Dataset_path, "features.txt" ),header = FALSE)

##Read the files with labels used in the datase##

#Read file with levels of the Activity variable
Activities  <- read.table(file.path(Dataset_path, "activity_labels.txt" ),header = FALSE)
#Read the labels of the subjects who provided the training data
subject_train <- read.table(file.path(Dataset_path,"train", "subject_train.txt" ),header = FALSE)
#Read the labels of the subjects who provided the test data
subject_test <- read.table(file.path(Dataset_path,"test", "subject_test.txt" ),header = FALSE)
#Read the labels of activities performed by subjects during training
activities_train <- read.table(file.path(Dataset_path,"train", "y_train.txt" ),header = FALSE)
#Read the labels of activities performed by subjects during test
activities_test <- read.table(file.path(Dataset_path,"test", "y_test.txt" ),header = FALSE)

##Read the actual data##

#Read the training data
data_train <- read.table(file.path(Dataset_path,"train", "X_train.txt" ),header = FALSE)
#Read the test data
data_test <- read.table(file.path(Dataset_path,"test", "X_test.txt" ),header = FALSE)

#Merging files for complete dataset with labels
###############################################

##Combining training and test component files by rows##

#Combining training and test subject labels
Subject_labels <- rbind(subject_train, subject_test)
#Combining training and test activity labels
Activity_labels <- rbind(activities_train, activities_test )
#Combining training ad test data
Combined_Data <- rbind(data_train, data_test)

##Assigning column names to the combined component files##

#Naming the subject label column
names(Subject_labels) <- c("Subject")
#Naming the activity label column
names(Activity_labels) <-c("ActivityCode")
   #Providing activity labels for activity code
Activity_Tested <- merge(Activity_labels, Activities, by.x = "ActivityCode", by.y = "V1")
Activity_Tested$Activity <- Activity_Tested$V2
Activity_Tested$V2 <-NULL
#Naming the columns of the actual dataset using the labels provided in Features
names(Combined_Data) <- Features$V2

##Merging labels and data for complete data frame##

UCI <- cbind(Subject_labels, Activity_Tested, Combined_Data)
#Saving complete dataset
write.table(UCI, "C:/Users/Owner/Desktop/Getting and Cleaning Data/UCI.txt", sep="\t")

##Extracting only the measurements on the mean and standard deviation for each measurement.
###########################################################################################

sub_UCI <- subset(UCI, select = c(Subject, Activity, grep("mean\\(\\)|std\\(\\)", names(UCI))))

##Appropriately labeling the data set with descriptive variable names.
######################################################################

names(sub_UCI)<-gsub("std()", "SD", names(sub_UCI))
names(sub_UCI)<-gsub("mean()", "MEAN", names(sub_UCI))
names(sub_UCI)<-gsub("^t", "Time", names(sub_UCI))
names(sub_UCI)<-gsub("^f", "Frequency", names(sub_UCI))
names(sub_UCI)<-gsub("Acc", "Accelerometer", names(sub_UCI))
names(sub_UCI)<-gsub("Gyro", "Gyroscope", names(sub_UCI))
names(sub_UCI)<-gsub("Mag", "Magnitude", names(sub_UCI))
names(sub_UCI)<-gsub("BodyBody", "Body", names(sub_UCI))

names(sub_UCI)

##Tidy data set with the average of each variable for each activity and each subject.
#####################################################################################
str(sub_UCI)
sub_UCI$Subject <- as.factor(sub_UCI$Subject)
tidy_UCI <- sub_UCI %>% group_by(Subject,Activity) %>% summarize_each(funs(mean))
write.table(tidy_UCI, "C:/Users/Owner/Desktop/Getting and Cleaning Data/tidy_UCI.txt", sep="\t")


