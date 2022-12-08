#unzip the download file
zipFile <- "../datacleaning/Dataset.zip"
outDir <- "../datacleaning"
unzip(zipFile, exdir = outDir)

# read file from the txt data
train_X <- read.table("../datacleaning/UCI HAR Dataset/train/X_train.txt", header = F)
str(train_X)
test_X <- read.table("../datacleaning/UCI HAR Dataset/test/X_test.txt", header = F)
str(test_X)

#combine both the train and test set data
allData <- rbind(train_X, test_X)


#read the feature data to extract the column names
feature_names <- read.table("../datacleaning/UCI HAR Dataset/features.txt", header = F)

#assign column names to data and set all at lower case
colnames(allData) <- tolower(feature_names$V2)

#to identify each subject for analysis, extract the subject code
subject_train <- read.table("../datacleaning/UCI HAR Dataset/train/subject_train.txt", header = F)
subject_test <- read.table("../datacleaning/UCI HAR Dataset/test/subject_test.txt", header = F)

#subset dataset with column names that contains mean and std
dfmean <- allData[ , grepl("mean", names( allData ), perl = TRUE)]
dfstd <- allData[ , grepl("std", names( allData ), perl = TRUE)]

#combine the train and test subject identifier and then rename the column
subject_all <- rbind(subject_train, subject_test)
colnames(subject_all) <- "subject"

#combine the subject and dfmean and dfstd
df <- cbind(subject_all, dfmean, dfstd)
str(df)

#tidy the table headers/column names
names(df) <- gsub("[()]","",names(df),)
names(df) <- gsub("-","",names(df),)
names(df) <- gsub("body","",names(df),)
names(df) <- sub("^t","",names(df),)
names(df) <- sub("^f","",names(df),)

#Storing the new features in a text file
features <- names(df)
sink(file = "new_features.txt")
print(features)
sink(NULL)
