setwd("C:/Users/ece.o/OneDrive/Coursera/Johns Hopkins University Data Science/03-Getting and Cleaning Data/CourseProject")

filename <- "getdata-projectfiles-UCI HAR Dataset.zip"
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",
              filename, mode = "wb")

files <- unzip(filename, list = TRUE)
unzip(filename)

### Merge the training and the test sets to create one data set

# Read training data
train <- read.table("UCI HAR Dataset/train/X_train.txt")
trainActLabels <- read.table("UCI HAR Dataset/train/y_train.txt")
trainSubjects <- read.table("UCI HAR Dataset/train/subject_train.txt")

# Read test data
test <- read.table("UCI HAR Dataset/test/X_test.txt")
testActLabels <- read.table("UCI HAR Dataset/test/y_test.txt")
testSubjects <- read.table("UCI HAR Dataset/test/subject_test.txt")

# Global info
features <- read.table("UCI HAR Dataset/features.txt")
actLabels <- read.table("UCI HAR Dataset/activity_labels.txt")

# Combine train and test data
all <- rbind(train, test)
allActLabels <- rbind(trainActLabels, testActLabels)
allSubjects <- rbind(trainSubjects, testSubjects)

# Add activity labels and subjects as new columns
all <- cbind(all, allActLabels, allSubjects)

# Add column names
names(all) <- c(as.character(features[,2]), "ActivityLabels", "Subjects")

## Extract only the measurements on the mean and standard deviation for each
## measurement
# Find columns that contain "mean" or "std" in their names
meanCol <- grep("mean", names(all))
stdCol <- grep("std", names(all))
# Keep last two columns for activity labels and subjects
# Use unique just in case there are duplicates
col <- unique(c(meanCol, stdCol, ncol(all)-1, ncol(all))) 

df <- all[,col] # Column order changes, may need to modify c() above

## Use descriptive activity names to name the activities in the data set
# Add activity labels as names and remove activity numbers column
df <- merge(df, actLabels, by.x = "ActivityLabels", by.y="V1")
# Change activity labels column name
names(df)[ncol(df)] <- "ActivityLabels"


# From the data set in step 4, creates a second, independent tidy data set with
# the average of each variable for each activity and each subject
df2 <- df


write.table("df2.txt", row.name=FALSE)