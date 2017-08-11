Data description
======================

The original dataset can be downloaded here: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

Find more information about the project which colleceted the data here: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones


Feature description
======================

The features selected for this database come from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ. These time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz. Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. Similarly, the acceleration signal was then separated into body and gravity acceleration signals (tBodyAcc-XYZ and tGravityAcc-XYZ) using another low pass Butterworth filter with a corner frequency of 0.3 Hz. 

Subsequently, the body linear acceleration and angular velocity were derived in time to obtain Jerk signals (tBodyAccJerk-XYZ and tBodyGyroJerk-XYZ). Also the magnitude of these three-dimensional signals were calculated using the Euclidean norm (tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, tBodyGyroJerkMag). 

Finally a Fast Fourier Transform (FFT) was applied to some of these signals producing fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccJerkMag, fBodyGyroMag, fBodyGyroJerkMag. (Note the 'f' to indicate frequency domain signals). 

These signals were used to estimate variables of the feature vector for each pattern:  
'-XYZ' is used to denote 3-axial signals in the X, Y and Z directions.

tBodyAcc-XYZ
tGravityAcc-XYZ
tBodyAccJerk-XYZ
tBodyGyro-XYZ
tBodyGyroJerk-XYZ
tBodyAccMag
tGravityAccMag
tBodyAccJerkMag
tBodyGyroMag
tBodyGyroJerkMag
fBodyAcc-XYZ
fBodyAccJerk-XYZ
fBodyGyro-XYZ
fBodyAccMag
fBodyAccJerkMag
fBodyGyroMag
fBodyGyroJerkMag

The set of variables that were estimated from these signals are: 

mean(): Mean value
std(): Standard deviation

Moreover, both the datasets tidy_data.txt and the dataset summary_data.txt contain the activity during which the data was collected and the anonymized user from which the data was collected.


The dataset summary_data.txt offers mean values for all features grouped by activity and user

Transformations performed by run_analysis.R
============================================

*****
x_test <- read.table("./test/x_test.txt", header = FALSE)
x_train <- read.table("./train/x_train.txt", header = FALSE)
x_all <- rbind(x_test, x_train)
features <- read.table("./features.txt", header = FALSE)
list_features <- features[,2]
colnames(x_all) <- list_features


-> these operations merge the training and the test sets to create one data set called x_all

*****


*****
x_all_meanAndstd <- subset(x_all, select = grep("mean\\(\\)|std\\(\\)", names(x_all)))


-> this operation extracts only the measurements on the mean and standard deviation for each measurement for x_all into a new dataset x_all_meanAndstd

*****




*****
act_test <- read.table("./test/y_test.txt", header = FALSE)

act_train <- read.table("./train/y_train.txt", header = FALSE)

act_all <- rbind(act_test, act_train)
names(act_all) <- "activity"

subj_test <- read.table("./test/subject_test.txt", header = FALSE)
subj_train <- read.table("./train/subject_train.txt", header = FALSE)
subj_all <- rbind(subj_test, subj_train)




-> these operations combine the activities and subjects (users) for each observation into 2 separate datasets act_all.txt and subj_all.txt 
*****


*****
names(subj_all) <- "subject"
activities <- read.table("./activity_labels.txt", header = FALSE)
names(activities) <- c("activity", "act_name")


x_complete <- cbind(act_all, subj_all, x_all_meanAndstd)

-> these operations add names to the 2 datasets created before and merges them into the x_all_meanAndstd dataset created before under the new name x_complete
*****

*****
x_complete_act <- merge(activities, x_complete, by= "activity", all=TRUE)

-> this operation adds descriptive activity names to name the activities in the data set
*****



*****
x_meanBySubjectAndActivity <- aggregate(x_complete_act[, 3:69], list(x_complete_act$act_name, x_complete_act$subject), mean)

-> this operation creates a second, independent tidy data set with the average of each variable for each activity and each subject.
*****

*****
write.table(x_meanBySubjectAndActivity, file = "./summary_data.txt", row.names = FALSE)
write.table(x_complete_act, file ="./tidy_data.txt", row.names = FALSE)

-> these operations save the created datasets x_complete_act and x_meanBySubjectAndActivity into text files
*****
