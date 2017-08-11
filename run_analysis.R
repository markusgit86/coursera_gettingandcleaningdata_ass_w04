

x_test <- read.table("./test/x_test.txt", header = FALSE)
x_train <- read.table("./train/x_train.txt", header = FALSE)
x_all <- rbind(x_test, x_train)
features <- read.table("./features.txt", header = FALSE)
list_features <- features[,2]
colnames(x_all) <- list_features

x_all_meanAndstd <- subset(x_all, select = grep("mean\\(\\)|std\\(\\)", names(x_all)))
act_test <- read.table("./test/y_test.txt", header = FALSE)

act_train <- read.table("./train/y_train.txt", header = FALSE)

act_all <- rbind(act_test, act_train)
names(act_all) <- "activity"

subj_test <- read.table("./test/subject_test.txt", header = FALSE)
subj_train <- read.table("./train/subject_train.txt", header = FALSE)
subj_all <- rbind(subj_test, subj_train)
names(subj_all) <- "subject"

activities <- read.table("./activity_labels.txt", header = FALSE)
names(activities) <- c("activity", "act_name")

x_complete <- cbind(act_all, subj_all, x_all_meanAndstd)

x_complete_act <- merge(activities, x_complete, by= "activity", all=TRUE)



x_meanBySubjectAndActivity <- aggregate(x_complete_act[, 3:69], list(x_complete_act$act_name, x_complete_act$subject), mean)


write.table(x_meanBySubjectAndActivity, file = "./summary_data.txt", row.names = FALSE)
write.table(x_complete_act, file ="./tidy_data.txt", row.names = FALSE)