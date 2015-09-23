---
title: "README"
---

The following section describes the work that has been performed to clean up the raw data.

1. Training and test data sets have been combined using `rbind`. Similarly, labels and subjects of training and test data have been combined.

```r
# Read training data
train <- read.table("UCI HAR Dataset/train/X_train.txt")
trainActLabels <- read.table("UCI HAR Dataset/train/y_train.txt")
trainSubjects <- read.table("UCI HAR Dataset/train/subject_train.txt")

# Read test data
test <- read.table("UCI HAR Dataset/test/X_test.txt")
testActLabels <- read.table("UCI HAR Dataset/test/y_test.txt")
testSubjects <- read.table("UCI HAR Dataset/test/subject_test.txt")

# Combine train and test data
all <- rbind(train, test)
allActLabels <- rbind(trainActLabels, testActLabels)
allSubjects <- rbind(trainSubjects, testSubjects)
```

The resulting three data sets have been combined with `cbind` to create one data set.

```r
all <- cbind(all, allActLabels, allSubjects)
```


2. Names of the features have been added as column names

```r
# Get feature names from features.txt
features <- read.table("UCI HAR Dataset/features.txt")
# Add column names
names(all) <- c(as.character(features[,2]), "ActivityLabels", "Subjects")
```


3. Columns that have the words "mean" or "std" were identified using `grep` and the remaining measurements have been removed.

```r
# Find columns that contain "mean" or "std" in their names
meanCol <- grep("mean", names(all))
stdCol <- grep("std", names(all))
# Use unique just in case there are duplicates. Keep last two columns for activity labels and subjects
col <- unique(c(meanCol, stdCol, ncol(all)-1, ncol(all))) 

df <- all[,col]
```

4. Activity numbers have been replaced with names by merging the data frame from the previous step with "activity_labels.txt".

```r
actLabels <- read.table("UCI HAR Dataset/activity_labels.txt")
df <- merge(df, actLabels, by.x = "ActivityLabels", by.y="V1")
# Matched columns (w/ activity numbers) becomes the first column, delete it
df <- df[,-1]
# Change the new activity labels column name
names(df)[ncol(df)] <- "ActivityLabels"
```

5. Using `reshape2` library the data frame has been `melt`ed to have rows by subject and activity. Then `dcast`ed to take average of each variable for each activity and each subject. Last, the final data frame has been written to .txt file.

```r
library(reshape2)
allMelted <- melt(df, id=c("Subjects", "ActivityLabels"))
# Taking the average of all values for each activity and subject combination.
df2 <- dcast(allMelted, Subjects + ActivityLabels ~ variable, mean)

write.table(df2, "df2.txt", row.name=FALSE)
```
