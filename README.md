# getdata_course_project

this repository contains the course project of the "getting and cleaning data course 13" in April 2015.

the script given in this repository "run_analysis.R" has to be run in the directory "UCI HAR Dataset", as created by expanding the
ZIP file downloaded for this project. The script reads the files "features.txt" (containing the descriptive names for the 561 
measured variables) and "activity_labels.txt" (containing descriptive names for the 6 activities performed by the 30 people
taking part in this study). Further the finds the 66 variables/features which contain the strings "mean()" or "std()" in their
name. The script then reads the files "train/subject_train.txt", "train/X_train.txt" and "train/y_train.txt" as well as
"test/subject_test.txt", "test/X_test.txt" and "test/y_test.txt". The files with "subject" in the file name contain the number
of the anonymous person (1-30) for each of the measurements subsequently performed. The measurements are in the files which names
contain "X" and a number corresponding to the activity (1-6) is found in the files which names contain "y".

from the files which names contain "X" the script choses the 66 columns corresponding to the mean() and std() variables.
these are then stored in a data.frame, together with the subject number, activity description and a column indicating if it
was from the "test" or the "train" directory.

In the next step the final data.frame "df_average" is created, which has 4 columns ("Number_Subject","Activity","Variable","Value"),
where the 1st one is the number of the person, 2nd one the descriptive name of the activity, 3rd one the descriptive name of 
the variable and the last one the average value of this variable for the given activity and the given person.

then, using the write.table command a .txt file is created containing the data.frame.
