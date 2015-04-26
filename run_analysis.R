## this code is intended for being sourced in the directory "UCI HAR Dataset" as created by unpacking 
## the ZIP file.
## it combines the train and test datasets, choses the variables which have
## "mean()" or "std()" in their name, add descriptive names for the activities, add descriptive
## variable names and creates an independent data set including only the average of the
## variables from the former data set (the one before the last step) for each activity

features <- readLines("features.txt")
n_var_tot <- length(features)

activities <- readLines("activity_labels.txt")
ac_labels <- matrix(rep("a"),ncol = 2, nrow = 6)
for (a in 1:6){
  ac_labels[a,] <- unlist(strsplit(activities[a]," "))
}
ac_labels <- ac_labels[,2]

ind_var_mean <- grep("mean()",features,fixed = T)
ind_var_std <- grep("std()",features,fixed = T)
ind_selected_var <- sort(c(ind_var_mean,ind_var_std))

selected_var <- rep("",length(ind_selected_var))
for (l in 1:length(ind_selected_var)){
  dummy <- unlist(strsplit(features[ind_selected_var[l]]," "))
  dummy <- dummy[2]
  selected_var[l] <- dummy
}

X_train <- readLines("train/X_train.txt") ## observed values for features
y_train <- readLines("train/y_train.txt") ## number of activity
y_train_label <- ac_labels[as.integer(y_train)]
subj_num_train <- readLines("train/subject_train.txt") ## number of person

X_test <- readLines("test/X_test.txt")
y_test <- readLines("test/y_test.txt") ## number of activity
y_test_label <- ac_labels[as.integer(y_test)]
subj_num_test <- readLines("test/subject_test.txt") ## number of person

num_obs_train <- length(X_train)
num_obs_test <- length(X_test)

split_X_test <- matrix(rep(-999.,num_obs_test * n_var_tot),nrow = num_obs_test,ncol = n_var_tot)
for (l in 1:num_obs_test)
  {prelim_row <- unlist(strsplit(X_test[l]," "))
   if (length(prelim_row[prelim_row != ""]) == n_var_tot)
     {split_X_test[l,] <- as.numeric(prelim_row[prelim_row != ""])
     } else {
       print("ERROR")
       stop
     }
  }

### reduce columns from matrix to the "mean()" and "std()" ones
split_X_test <- split_X_test[,ind_selected_var]

split_X_train <- matrix(rep(-999.,num_obs_train * n_var_tot),nrow = num_obs_train,ncol = n_var_tot)
for (l in 1:num_obs_train)
{prelim_row <- unlist(strsplit(X_train[l]," "))
 if (length(prelim_row[prelim_row != ""]) == n_var_tot)
 {split_X_train[l,] <- as.numeric(prelim_row[prelim_row != ""])
 } else {
   print("ERROR")
   stop
 }
}

### reduce columns from matrix to the "mean()" and "std()" ones
split_X_train <- split_X_train[,ind_selected_var]

## merge the 2 matrices
merged_X <- rbind(split_X_train,split_X_test)
subj_num <- c(subj_num_train,subj_num_test)
y_label <- c(y_train_label, y_test_label)
train_test <- c(rep("train",num_obs_train),rep("test",num_obs_test))

## preliminary un-averaged data.frame created here
df_no_average <- data.frame(subj_num,y_label,train_test,merged_X,stringsAsFactors = F)
colnames(df_no_average) <- c("Number_Subject","Activity_description","train_or_test",selected_var)

### new "tidy" data.frame created below here
dummy_char_vector <- rep("a",30 * 6 * length(ind_selected_var))
dummy_numeric_vector <- rep(-999.,30 * 6 * length(ind_selected_var))
df_average <- data.frame(dummy_numeric_vector,dummy_char_vector,dummy_char_vector,dummy_numeric_vector,stringsAsFactors = FALSE)
colnames(df_average) <- c("Number_Subject","Activity","Variable","Value")

count <- 0
for (sub in 1:30){
  for (act in 1:6){
    r_index <- which(df_no_average$Number_Subject == sub & df_no_average$Activity_description == ac_labels[act])
    for (var in 4:(length(ind_selected_var) + 3)){
      count <- count + 1
      df_average$Number_Subject[count] <- sub
      df_average$Activity[count] <- ac_labels[act]
      df_average$Variable[count] <- selected_var[var-3]
      df_average$Value[count] <- mean(df_no_average[r_index,var])
    }
  }
}
write.table(df_average, file = "df_average.txt", sep = "\t", row.name = FALSE)
