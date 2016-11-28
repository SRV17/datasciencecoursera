library(dplyr)
library(data.table)
library(tidyr)
library(stringr)
#Subject files
setwd("/Users/raghuvamsysirasala/Desktop/data/UCI HAR Dataset/train")
#subject train data
Subject_train <- tbl_df(read.table("subject_train.txt"))
activity_train <- tbl_df(read.table("Y_train.txt"))
train_data <- tbl_df(read.table("X_train.txt"))
#subject test data
setwd("/Users/raghuvamsysirasala/Desktop/data//UCI HAR Dataset/test")
Subject_test <- tbl_df(read.table("subject_test.txt"))
activity_test <- tbl_df(read.table("Y_test.txt"))
test_data <- tbl_df(read.table("X_test.txt"))


subjectdata <- rbind(Subject_train, Subject_test)
setnames(subjectdata, "V1", "subject")

#Acitvity data
Activty_data <- rbind(activity_train, activity_test)
setnames(Activty_data, "V1", "Activity_num")

data_table <- rbind(train_data, test_data)


setwd("/Users/raghuvamsysirasala/Desktop/data//UCI HAR Dataset")
Features_data <- tbl_df(read.table("features.txt"))
setnames(Features_data, names(Features_data), c("Feature_num", "Feature_name"))
colnames(data_table) <- Features_data$Feature_name
#data_table <- rbind(train_data, test_data)

Activity_labels <- tbl_df(read.table("activity_labels.txt"))
setnames(Activity_labels, names(Activity_labels), c("Activity_num", "Activity_name"))
#setnames(Activty_data, "V1", "Activity")

SubjectActivitydata_final <- cbind(subjectdata, Activty_data)
data_table <- cbind(SubjectActivitydata_final, data_table)


feature_Mean_Std <- grep("mean\\(\\)|std\\(\\)", Features_data$Feature_name, value = TRUE)
feature_Mean_Std <- union(c("subject","Activitynum"), feature_Mean_Std)
data_table <- subset(data_table,select = feature_Mean_Std)

#Mean_Std <- subset(data_table, select = Mean_Std)

data_table <- merge(Activity_labels, data_table, by.x = 'Activity_num',  all.x = TRUE)
data_table$ActivityName <- as.character(data_table$ActivityName)
data_ag <- aggregate(.~subject ~ Activity_name, data = data_table, mean)
head(str(data_table),2)
names(data_table)<-gsub("std()", "SD", names(data_table))
names(data_table)<-gsub("mean()", "MEAN", names(data_table))
names(data_table)<-gsub("^t", "time", names(data_table))
names(data_table)<-gsub("^f", "frequency", names(data_table))
names(data_table)<-gsub("Acc", "Accelerometer", names(data_table))
names(data_table)<-gsub("Gyro", "Gyroscope", names(data_table))
names(data_table)<-gsub("Mag", "Magnitude", names(data_table))
names(data_table)<-gsub("BodyBody", "Body", names(data_table))


write.csv(data_table, "Tidy.csv", row.names = FALSE)
