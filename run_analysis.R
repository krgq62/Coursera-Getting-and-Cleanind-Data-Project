

## Project Class 3


library(data.table)
library(tidyverse)



features <- read.table('./UCI HAR Dataset/features.txt')
features <- as.character(features[,2])
labels_act <- read.table('./UCI HAR Dataset/activity_labels.txt', header = FALSE)
labels_act <- as.character(labels_act[,2])

d_train_x <- read.table('./UCI HAR Dataset/train/X_train.txt')
d_train_act <- read.table('./UCI HAR Dataset/train/y_train.txt', header = FALSE, sep = ' ')
d_train_sub <- read.table('./UCI HAR Dataset/train/subject_train.txt', header = FALSE, sep = ' ')

d_train <- data.frame(d_train_sub, d_train_act, d_train_x)
names(d_train) <- c(c('subject', 'activity'), features)

d_test_x <- read.table('./UCI HAR Dataset/test/X_test.txt')
d_test_act <- read.csv('./UCI HAR Dataset/test/y_test.txt', header = FALSE, sep = ' ')
d_test_sub <- read.csv('./UCI HAR Dataset/test/subject_test.txt', header = FALSE, sep = ' ')

d_test <- data.frame(d_test_sub, d_test_act, d_test_x)
names(d_test) <- c(c('subject', 'activity'), features)

alldata <- rbind(d_train, d_test)

std_mean_select <- grep('mean|std', features)
d_sub <- alldata[,c(1,2,std_mean_select +2)]

d_sub$activity <- labels_act[d_sub$activity]

name_new <- names(d_sub)
name_new <- gsub("[(][)]", "", name_new)
name_new <- gsub("^t", "TimeDomain_", name_new)
name_new <- gsub("^f", "FrequencyDomain_", name_new)
name_new <- gsub("Acc", "Accelerometer", name_new)
name_new <- gsub("Gyro", "Gyroscope", name_new)
name_new <- gsub("Mag", "Magnitude", name_new)
name_new <- gsub("-mean-", "_Mean_", name_new)
name_new <- gsub("-std-", "_StandardDeviation_", name_new)
name_new <- gsub("-", "_", name_new)
names(d_sub) <- name_new

d_tidy <- aggregate(d_sub[,3:81], by = list(activity = d_sub$activity, subject = d_sub$subject), FUN = mean)
write.table(x = d_tidy, file = "data_tidy.txt", row.names = FALSE)




