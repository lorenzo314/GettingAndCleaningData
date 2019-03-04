# Code book for the **Human Activity Recognition Using Smartphones Data Set** dataset

## Data description

The dataset was downloaded on 2019/02/26 at 01:56pm ECT from the
[UCI Machine Learning Repository]
(http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones)

The dataset is described in this publication:

Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and
Jorge L. Reyes-Ortiz.
Human Activity Recognition on Smartphones using a Multiclass
Hardware-Friendly Support Vector Machine.
International Workshop of Ambient Assisted Living (IWAAL 2012).
Vitoria-Gasteiz, Spain. Dec 2012

The dataset contains data from 30 subjects who were recorded performing
6 activities while carrying a waist-mounted smartphone with embedded
inertial sensors (accelerometer and gyroscope).

Each subject was recorded many times while doing each activity; the
total number of observations is 10299; the dataset was split in 7352
observations for the training set and 2497 for the test set.

For each observation the value of 561 features was computed from the signals
recorded by the smartphones, each feature consisting of some statistic
(mean, std, mad, min, max etc) from the signals.

The values of the 561 features were recorded on separate files from the
values of the corresponding activity (coded from 1 to 6) and the subject
doing it (coded from 1 to 30); subject and activity were recorded on
different files and were split in a test and training set in the same
way as the feature files.

Features are normalized and bounded within [-1,1].

Signals from the sensors are in the time domain: for each subject-activity
pair multiple values for each signal were measured at different times;
the names of these variables begin with a "t".

To some of those signals a Fast Fourier Transform was applied;
the FFT transformed signal have names prefixed by "f".

Most of the variables are vector in nature and the values along each of the
X, Y, Z axes were recorded and stored in columns with names ending in
"-X", "Y", "-Z": for example "tBodyAcc-XYZ" indicates values of the
body acceleration along the X, Y, Z axis, with a separate column
for each axis.

## Data processing

First the train and set files were grouped together; this was done
separately  for the feature files, the subject files, and the activity
files, obtaining three files 10299 lines long.

These three files were joined together to obtain a single, 10299 lines
long file with subject, activity and values of the 561 features; the
coding of the activities, from 1 to 6, was replaced by their names
using a provided "activity code->activity name" matching file.   

From this file we extracted the features that express a mean or a std
of a signal; the names of these variables are:

1. tBodyAcc-XYZ
2. tGravityAcc-XYZ
3. tBodyAccJerk-XYZ
4. tBodyGyro-XYZ
5. tBodyGyroJerk-XYZ
6. tBodyAccMag
7. tGravityAccMag
8. tBodyAccJerkMag
9. tBodyGyroMag
10. tBodyGyroJerkMag
11. fBodyAcc-XYZ
12. fBodyAccJerk-XYZ
13. fBodyGyro-XYZ
14. fBodyAccMag
15. fBodyAccJerkMag
16. fBodyGyroMag
17. fBodyGyroJerkMag

In this form the data is not tidy as there should be a single column for
each of the variables ending in "-X", "-Y", "-Z", with an additional column
"axis" reporting the axis to which the values refers to.

The data was therefore tidied by introducing an "axis" factor column,
with values X, Y, Z and grouping together each group of
three columns (for X, Y, Z), in a single column reporting the values
along X, Y, Z on 3 different lines, with the appropriate axis labels.

The columns for which the tidying was done are:

1. tBodyAcc-XYZ (6 columns, 3 for mean and 3 for STD)
2. tGravityAcc-XYZ (6 columns, 3 for mean and 3 for STD)
3. tBodyAccJerk-XYZ (6 columns, 3 for mean and 3 for STD)
4. tBodyGyro-XYZ (6 columns, 3 for mean and 3 for STD)
5. tBodyGyroJerk-XYZ (6 columns, 3 for mean and 3 for STD)
6. fBodyAcc-XYZ (6 columns, 3 for mean and 3 for STD)
7. fBodyAccJerk-XYZ (6 columns, 3 for mean and 3 for STD)
8. fBodyGyro-XYZ (6 columns, 3 for mean and 3 for STD)

The magnitude of these vectors was also computed by euclidean norm and the
values stored variables with the same name plus "Mag"; therefore we have:

1. tBodyAccMag (1 column for mean, 1 for STD)
2. tGravityAccMag (1 column for mean, 1 for STD)
3. tBodyAccJerkMag (1 column for mean, 1 for STD)
4. tBodyGyroMag (1 column for mean, 1 for STD)
5. tBodyGyroJerkMag (1 column for mean, 1 for STD)
6. fBodyAccMag (1 column for mean, 1 for STD)
7. fBodyAccJerkMag (1 column for mean, 1 for STD)
8. fBodyGyroMag (1 column for mean, 1 for STD)

An additional variable
9. fBodyGyroJerkMag (1 column for mean, 1 for STD)
is also present; these last 9 variables do not need to be tidied.

More expressive names were given to these variables: names beginning with
"t" (time domain values) begin instead with "TimeDomain"; names beginning
with "f" (frequency domain values) begin with "FrequencyDomain"; the
suffixes "X", "Y", "Z", when present, were dropped from the final columns.

The procedure gave a tidy dataset with 30897 (10299 observations times
3 values of the factor variable "axis" = 30897) reporting the values of
the 17 variables above; for each variable the mean and the STD are reported.

We summarized all the observations for a subject-activity pair,
180 pairs in all, in a single value, the mean of all the observations,
of each variable for that pair.

The final dataset thus consists of 180 observations; for each of the 17
variables there are two columns (mean and std) plus one column for subject
and activity.

A script is available that:

1. Returns a final, tidy table.
2. Writes the data on a txt file; the file name is specified by an argument
to the main function in the script. 

## Variables in the final table

Except for `subject` and `activity` values are normalized and bounded
within [-1,1].

1. subject: 1-30
2. activity:
	1. WALKING
	2. WALKING_UPSTAIRS
	3. WALKING_DOWNSTAIRS
	4. SITTING,
	5. STANDING
	6. LAYING
3. TimeDomainBodyAccMagMean: Mean of the body acc. magnitude measured by accelermeter
4. TimeDomainBodyAccMagSTD: STD od the above
5. TimeDomainGravityAccMagMean: Mean of the gravity acc. magnitude measured by accelermeter
6. TimeDomainGravityAccMagSTD STD of the above
7. TimeDomainBodyAccJerkMagMean: Time derivative of column 3
8. TimeDomainBodyAccJerkMagSTD: STD of the above
9. TimeDomainBodyGyroMagMean: Mean of the angular velocity mag. measured by gyroscope
10. TimeDomainBodyGyroMagSTD: STD of the above
11. TimeDomainBodyGyroJerkMagMean: Time derivative of column 9
12. TimeDomainBodyGyroJerkMagSTD: STD of the above
13. FreqDomainBodyAccMagMean: FFT of column 3
14. FreqDomainBodyAccMagSTD: STD of the above
15. FreqDomainBodyAccJerkMagMean: FFT of column 7
16. FreqDomainBodyAccJerkMagSTD: STD of the above
17. FreqDomainBodyGyroMagMean: FFT of column 9
18. FreqDomainBodyGyroMagSTD: STD of the above
19. FreqDomainBodyGyroJerkMagMean: FFT of column 11
20. FreqDomainBodyGyroJerkMagSTD: STD of the above
21. TimeDomainBodyAccMean: Mean of the body acc. values along the 3 axes
22. TimeDomainBodyAccSTD: STD of the above
23. TimeDomainGravityAccMean: Mean of the gravity acc. values along the 3 axes 
24. TimeDomainGravityAccSTD: STD of the above
25. TimeDomainBodyAccJerkMean: Time derivative of column 21
26. TimeDomainBodyAccJerkSTD: STD of the above
27. TimeDomainBodyGyroMean: Mean of the angular velocity values along the 3 axes
28. TimeDomainBodyGyroSTD: STD of the above
29. TimeDomainBodyGyroJerkMean: Time derivative of column 27
30. TimeDomainBodyGyroJerkSTD: STD of the above
31. FreqDomainBodyAccMean: FFT of column 21
32. FreqDomainBodyAccSTD: STD of the above
33. FreqDomainBodyAccJerkMean: 25
34. FreqDomainBodyAccJerkSTD: STD of the above
35. FreqDomainBodyGyroMean: FFT of column 27
36. FreqDomainBodyGyroSTD: STD of the above
