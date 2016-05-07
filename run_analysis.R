if ("plyr" %in% rownames(installed.packages()) == FALSE) {
  install.packages("plyr")
}

if ("reshape2" %in% rownames(installed.packages()) == FALSE) {
  install.packages("reshape2")
}

library(plyr)
# 1. Merges the training and the test sets to create one data set.
merge <- function(x,y) {
   data <- read.table(x)
   test <- read.table(y)
   data_set <- rbind(data, test)
}

# create 'x' data set
x_data <- merge("train/X_train.txt","test/X_test.txt")

# create 'y' data set
y_data <- merge("train/y_train.txt","test/y_test.txt")

# create 'subject' data set
subject_data <- merge("train/subject_train.txt","test/subject_test.txt")

# 2. Extracts only the measurements on the mean and standard deviation for each measurement. 

features <- read.table("features.txt")

# get mean and std columns
mean_and_std_features <- grep("-(mean|std)\\(\\)", features[, 2])

# subset mean and std columns
x_data <- x_data[, mean_and_std_features]

# correct the column names
names(x_data) <- features[mean_and_std_features, 2]

# 3. Uses descriptive activity names to name the activities in the data set
activities <- read.table("activity_labels.txt")

# update values with correct activity names
y_data[, 1] <- activities[y_data[, 1], 2]

# correct column name
names(y_data) <- "activity"

# Appropriately labels the data set with descriptive variable names

# correct column name
names(subject_data) <- "subject"

# bind all the data in a single data set
all_data <- cbind(x_data, y_data, subject_data)

# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

# split data frame and apply the function
mean_data <- ddply(all_data, .(subject, activity), function(x) colMeans(x[, 1:66]))

options(width=1000)
head(mean_data)

# write to a file
write.table(mean_data, "mean_data.txt", row.name=FALSE)

