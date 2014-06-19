library(reshape2)
library(arules)
library(plyr)


#### --> 1. Merges the training and the test sets to create one data set.
## Get common stuffs
# Get features names into a vector
features <- read.csv("./UCI_HAR_Dataset/features.txt", sep="", header=F)[,2]

# Concatenate columns from subject_test, y_test, X_Test files into a single data set
test_x <- read.csv(file="./UCI_HAR_Dataset/test/X_test.txt", sep="", header=F)
test_y <- read.csv(file="./UCI_HAR_Dataset/test/y_test.txt", header=F)
test_dat<-cbind(test_x,test_y)

# Concatenate columns from subject_train, y_train, X_Train files into a single data set
train_x <- read.csv(file="./UCI_HAR_Dataset/train/X_train.txt", sep="", header=F)
train_y <- read.csv(file="./UCI_HAR_Dataset/train/y_train.txt", header=F)
train_dat<-cbind(train_x,train_y)

# Get names of column into vector to put names into dataset
names(test_dat) <- features
names(train_dat) <- features

#### --> 2. Extracts only the measurements on the mean and standard deviation for each measurement.
# Remove unuseful columns
test_dat <- test_dat[,grep("*-mean\\(\\)-*|*-std\\(\\)-*", names(test_dat), ignore.case=F)]
train_dat <- train_dat[,grep("*-mean\\(\\)-*|*-std\\(\\)-*", names(train_dat), ignore.case=F)]

# Now it's time to add the subject and the activity
# For test and train data
test_s <- read.csv(file="./UCI_HAR_Dataset/test/subject_test.txt", header=F)
train_s <- read.csv(file="./UCI_HAR_Dataset/train/subject_train.txt", header=F)

#### --> 4. Appropriately labels the data set with descriptive variable names. 
test_dat$Subject <- test_s[,1]
test_dat$Activity <- test_y[,1]
train_dat$Subject <- train_s[,1]
train_dat$Activity <- train_y[,1]

# Combine the two data sets into one
full_dat <- rbind(test_dat, train_dat)

#### --> 3. Uses descriptive activity names to name the activities in the data set
# Using library "arules"
activities <- read.csv("./UCI_HAR_Dataset/activity_labels.txt", sep="", header=F)[,2]
# Using library "arules"
full_dat$Activity <- decode(full_dat$Activity, activities)


#### --> 5. Creates a second, independent tidy data set with the average of 
#### -->    each variable for each activity and each subject. 

tidy_dat <- ddply(full_dat ,.(Subject,Activity),colwise(mean))

# Write tidy dataset to disk
write.table(tidy_dat, "tidy_dataset.csv", sep = ";", quote = FALSE)

