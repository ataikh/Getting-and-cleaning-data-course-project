# Getting-and-cleaning-data-course-project
The Getting-and-cleaning-data-course-project repository contains files which pertain to compiling
the UCI HAR dataset and creating the tidy_UCI dataset: run_analysis.R; tidy_UCI; CodeBook.

The run_analysis.R file contains the script which creates a directory for the data, then downloads
and uncompresses the file. The separate files are then used to compile the overall data file. 
The means and standard deviations are then extracted and aggregated over subjects and activities.
The following is a brief description of the separate files used to compile the entire UCI HAR dataset:
subject_train.txt contains the labels of the subjects who provided data for the training phase of the experiment.
subject_test.txt contains the labels of subjects who provided data for the test phase of the experiment.
y_train.txt provides the numerical labels of the activities performed by subjects during training.
y_test.txt provides the numerical labels of the activities performed by subjects during test.
activity_labels.txt then allows for the translation of the numerical activity labels into meaningul verbal descriptions.
The X_train.txt and X_test.txt are the raw data containing the accelerometer and gyroscope measurements (see CodeBook for 
more detail on the data collected).
Compiling all these files creates a dataset which shows the raw data contained in X_train.txt and X_test.txt for each subject
for each activity. The script in run_analysis.R then extracts the mean and standard deviations for each measure and aggregates these per subject and per activity to create the tidy_UCI dataset. Thus, the tidy_UCI dataset contains the summary mean and standard deviation
of each accelerometer and gyroscope measurement for each subject for each activity.

The CodeBook contains detailed annotations of the run_analysis.R script as well as greater detail about the nature of the data collected.



