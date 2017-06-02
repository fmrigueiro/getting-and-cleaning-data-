if(!file.exists("./W")){dir.create("./W")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./W/wearable.zip")

unzip(zipfile="./W/wearable.zip",exdir="./W")

# Reading trainings data:
x_train <- read.table("./data/UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./data/UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")

# Reading testing data:
x_test <- read.table("./data/UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./data/UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")

# Reading feature vector:
features <- read.table('./data/UCI HAR Dataset/features.txt')

# Reading activity labels:
activityLabels <- read.table('./data/UCI HAR Dataset/activity_labels.txt')

# giving collums names
colnames(x_train) <- features[,2] 
colnames(y_train) <-"activityId"
colnames(subject_train) <- "subjectId"

colnames(x_test) <- features[,2] 
colnames(y_test) <- "activityId"
colnames(subject_test) <- "subjectId"

colnames(activityLabels) <- c('activityId','activityType')

# merging data in one untidy set

mrg_train <- cbind(y_train, subject_train, x_train)
mrg_test <- cbind(y_test, subject_test, x_test)
setAllInOne <- rbind(mrg_train, mrg_test)

# getting the mean and Sd
colNames <- colnames(setAllInOne) # reads collums names 

mean_and_std <- (grepl("activityId" , colNames) | 
                          grepl("subjectId" , colNames) | 
                          grepl("mean.." , colNames) | 
                          grepl("std.." , colNames) 
)
setForMeanAndStd <- setAllInOne[ , mean_and_std == TRUE]

# changing the activity to descriptive

setWithActivityNames <- merge(setForMeanAndStd, activityLabels,
                              by='activityId',
                              all.x=TRUE)
# making tidy data
secTidySet <- aggregate(. ~subjectId + activityId, setWithActivityNames, mean)
secTidySet <- secTidySet[order(secTidySet$subjectId, secTidySet$activityId),]


# second table of tidy data
write.table(secTidySet, "secTidySet.txt", row.name=FALSE)
tidy <- read.table("secTidySet.txt")
head(tidy)
