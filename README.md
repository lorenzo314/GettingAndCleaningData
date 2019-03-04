# GettingAndCleaningData

## Respository for the coursera course "Getting and Cleaning Data", course n. 2 of the Data Science JHU specialization.

### Here are the functions used for the project.

All functions are stored in a file "run_analysis.R"; the functions are:

1. `run_analysis(txtfile)`
Performs the main analysis steps by calling in turn other helper
functions:

	1. reads the data (feature files, activity files, subject files)
	both for the train and test sets and merges train and test sets
	together; this is done separately for the feature files, the activity
	files, and the subject files by calling function `read_data()`.
	
	2. Reads the names of the 561 features by calling function
	`get_features()`.
	
	3. Select from the feature file the column reporting mean and STD
	values only.
	
	4. Matches together features, activities and subjects by calling
	function `match_with_volunteers_and_activities()`.

	5. Puts the data in tidy form by calling function `make_tidy()`.
	
	6. Puts the column names in better form by calling function
	`fix_label()`.
	
	7. Groups the rows of the tidy table by subject and activity.

	8. Extract the mean across groups obtaining anotyher tidy table.
	
	9. Writes the final tidy table to txt file.
	
	10. Return the final tidy table

2. `read_data(raindir, trainfile, testdir, testfile)`
Read the files from the train and test directory and binds them together.

3. `get_features()`
Returns the 561 feature names.

4. `match_with_volunteers_and_activities(tbl_y,tbl_s,mean_and_std,lab)`
Join together the files with the features of interest, mean and std only,
the files with the activities, and the file with the subject.
It also replaces the activity labels (1-6) with their names.

5. `bind_columns(tidied_table,untidy_table,lab_x, lab_y, lab_z, with_axis)`
Used by `make_tidy()` to join together the columns pertaining to the X, Y,
Z axis of each variable.

6. `make_tidy(tidied_table, untidy_table, lab_x, lab_y, lab_z)`
Tidies the data.

7. `fix_label(nm)`
Puts the label in more expressive form.

### Data files

The following files are available:

1. `CodeBook.md`
Code book for the final data

2. `run_analysis.R`
R file with the function used.

3. `final_table.txt`
Final txt table.

4. `README.md`
This file.
