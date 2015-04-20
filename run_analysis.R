if (!require("data.table")) {
  install.packages("data.table")
}
if (!require("reshape2")) {
  install.packages("reshape2")
}
require("data.table")
require("reshape2")
dir.create("./data")
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./data/Dataset.zip")
unzip(zipfile="./data/Dataset.zip",exdir="./data")
path_rf <- file.path("./data" , "UCI HAR Dataset")
activity_labels <- read.table(file.path(path_rf, "activity_labels.txt"))[,2]
features <- read.table(file.path(path_rf, "features.txt"))[,2]
extract_features <- grepl("mean|std", features)
X_test <- read.table(file.path(path_rf, "test" , "X_test.txt"))
y_test <- read.table(file.path(path_rf, "test" , "y_test.txt"))
subject_test <- read.table(file.path(path_rf, "test" , "subject_test.txt"))
names(X_test) = features
X_test = X_test[,extract_features]
y_test[,2] = activity_labels[y_test[,1]]
names(y_test) = c("Activity_ID", "Activity_Label")
names(subject_test) = "subject"
test_data <- cbind(as.data.table(subject_test), y_test, X_test)
X_train <- read.table(file.path(path_rf, "train", "X_train.txt"))
y_train <- read.table(file.path(path_rf, "train", "Y_train.txt"))
subject_train <- read.table(file.path(path_rf, "train", "subject_train.txt"))
names(X_train) = features
X_train = X_train[,extract_features]
y_train[,2] = activity_labels[y_train[,1]]
names(y_train) = c("Activity_ID", "Activity_Label")
names(subject_train) = "subject"
train_data <- cbind(as.data.table(subject_train), y_train, X_train)
data = rbind(test_data, train_data)
id_labels = c("subject", "Activity_ID", "Activity_Label")
data_labels = setdiff(colnames(data), id_labels)
melt_data = melt(data, id = id_labels, measure.vars = data_labels)
tidy_data = dcast(melt_data, subject + Activity_Label ~ variable, mean)
write.table(tidy_data, file = "./tidydata.txt")