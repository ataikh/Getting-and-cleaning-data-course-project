Description of experiment and data collection
=============================================

Source:
[link](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones)

The experiments have been carried out with a group of 30 volunteers
within an age bracket of 19-48 years. Each person performed six
activities (WALKING, `WALKING_UPSTAIRS`, `WALKING_DOWNSTAIRS`, SITTING,
STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the
waist. Using its embedded accelerometer and gyroscope, we captured
3-axial linear acceleration and 3-axial angular velocity at a constant
rate of 50Hz. The experiments have been video-recorded to label the data
manually. The obtained dataset has been randomly partitioned into two
sets, where 70% of the volunteers was selected for generating the
training data and 30% the test data.

The sensor signals (accelerometer and gyroscope) were pre-processed by
applying noise filters and then sampled in fixed-width sliding windows
of 2.56 sec and 50% overlap (128 readings/window). The sensor
acceleration signal, which has gravitational and body motion components,
was separated using a Butterworth low-pass filter into body acceleration
and gravity. The gravitational force is assumed to have only low
frequency components, therefore a filter with 0.3 Hz cutoff frequency
was used. From each window, a vector of features was obtained by
calculating variables from the time and frequency domain.

Description of UCI HAR Dataset
==============================

Downloaded from:
[link](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip)

Pertinent files included in dataset
-----------------------------------

The following files are included in the downloaded folder and were used
to compile the complete dataset used in this project:

-   `README.txt`
-   `features_info.txt`: Shows information about the variables used on
    the feature vector.
-   `features.txt`: List of all features.
-   `activity_labels.txt`: Links the class labels with their
    activity name.
-   `train/X_train.txt`: Training set.
-   `train/y_train.txt`: Training labels.
-   `test/X_test.txt`: Test set.
-   `test/y_test.txt`: Test labels.

Abbreviations of key measures
-----------------------------

The following abbreviations in the dataset which pertain to the
variables that are focused on and summarized in this project:

-   std(): Standard deviation of measurement
-   mean(): Mean of measurement
-   leading t: Time measurement
-   leading f: Frequency measurement
-   Acc: Accelermeter measurement
-   Gyro: Gyroscopic measurement
-   Mag: Magnitude of movement
-   Body: Measurement of body movement

Description of run\_analysis.R script
=====================================

The following is a description of the sequential actions performed by
the `run_analysis.R` script which result in `tidy_UCI` datafile.

Loading pertinent packages
--------------------------

    library(RCurl)
    library(dplyr)

Obtaining the raw UCI HAR dataset
---------------------------------

    #Creating the directory if it does not exist
    if(!file.exists("C:\\Directory\\Getting and Cleaning Data")){ 
        dir.create("C:\\Directory\\Getting and Cleaning Data")   
    }
    #Downloading the file
    file.url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
    download.file(file.url, destfile = "C:\\Directory\\Getting and Cleaning Data\\Data.zip", method = "libcurl") 
    #unzipping the file
    unzip(zipfile="C:\\Directory\\Getting and Cleaning Data\\Data.zip",
          exdir="C:\\Directory\\Getting and Cleaning Data")

Reading files which will make up the complete dataset
-----------------------------------------------------

    #Creating filepath to the common folder containing the data
    Dataset_path <- "C:/Directory/Getting and Cleaning Data/UCI HAR Dataset"
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

Merging files to compile the compile the complete dataset
---------------------------------------------------------

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
    write.table(UCI, "C:/Directory/Getting and Cleaning Data/UCI.txt", sep="\t")

Extracting the mean and standard deviation of each measure
----------------------------------------------------------

    sub_UCI <- subset(UCI, select = c(Subject, Activity, grep("mean\\(\\)|std\\(\\)", names(UCI))))

Labelling dataset with appropriate variable names
-------------------------------------------------

    names(sub_UCI)<-gsub("std()", "SD", names(sub_UCI))
    names(sub_UCI)<-gsub("mean()", "MEAN", names(sub_UCI))
    names(sub_UCI)<-gsub("^t", "Time", names(sub_UCI))
    names(sub_UCI)<-gsub("^f", "Frequency", names(sub_UCI))
    names(sub_UCI)<-gsub("Acc", "Accelerometer", names(sub_UCI))
    names(sub_UCI)<-gsub("Gyro", "Gyroscope", names(sub_UCI))
    names(sub_UCI)<-gsub("Mag", "Magnitude", names(sub_UCI))
    names(sub_UCI)<-gsub("BodyBody", "Body", names(sub_UCI))

Extracting the mean and standard deviation of each measure
----------------------------------------------------------

    sub_UCI <- subset(UCI, select = c(Subject, Activity, grep("mean\\(\\)|std\\(\\)", names(UCI))))

Creating tidy data set with the average of each variable for each activity and each subject.
--------------------------------------------------------------------------------------------

    str(sub_UCI)
    sub_UCI$Subject <- as.factor(sub_UCI$Subject)
    tidy_UCI <- sub_UCI %>% group_by(Subject,Activity) %>% summarize_each(funs(mean))
    write.table(tidy_UCI, "C:/Directory/Getting and Cleaning Data/tidy_UCI.txt", sep="\t")
