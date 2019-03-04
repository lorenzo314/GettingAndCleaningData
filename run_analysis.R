library(dplyr)
library(tidyr)
library(stringr)

run_analysis <- function(final_table_file) {
	# Read the files with the features
	tbl_x <- read_data("train", "X_train.txt",
		"test", "X_test.txt")

	# Read the files with the activity labels
	tbl_y <- read_data("train", "y_train.txt",
		"test", "y_test.txt")
	
	# Read the files with the volunteer ids
	tbl_s <- read_data("train", "subject_train.txt",
		"test", "subject_test.txt")

	# Read the features
	ft <- get_features()

	# Select the columns (features) with the mean and STD only
	sel <- c()	# Columns to select; they have names like "V1,V2,..."
	lab <- c()	# Their names
	lab_x = c() 	# Names of columns pertaining to X axis
	lab_y = c()	# Names of columns pertaining to Y axis
	lab_z = c()	# Names of columns pertaining to Z axis
	lab_e = c()	# Names of other columns
	for (i in 1:length(ft)) {
    	if (grepl("-mean()", ft[i], fixed = TRUE) |
        	grepl("-std()", ft[i], fixed = TRUE)) {
        	sel <- append(sel, paste("V", i, sep=""))
        	lab <- append(lab, ft[i])
        	
        	if (grepl("-X", ft[i], fixed = TRUE)) {
        		lab_x <- append(lab_x, ft[i])
        	} else if (grepl("-Y", ft[i], fixed = TRUE)) {
        		lab_y <- append(lab_y, ft[i])
        	} else if (grepl("-Z", ft[i], fixed = TRUE)) {
        		lab_z <- append(lab_z, ft[i])
        	} else {
        		lab_e <- append(lab_e, ft[i])
			}
    	}
	}

	# This is the table with the columns representing the means and STD only
	mean_and_std <- select(tbl_x, sel)

	# Join the table above with the volunteers and the activities to obtain
	# a first untidy table with volunteers, activity and mean and STD
	# of the different signals measured; each pair volunteer-activity
	# has many different measurements of the same signal
	untidy_table<-match_with_volunteers_and_activities(tbl_y, tbl_s,
		mean_and_std,lab)
	rm("mean_and_std")

	# Start making a tidy table by selecting volunteers and activities
	# from the table above
	tidied_table <- select(untidy_table, subject, activity)

	# Select the columns in the untidy table that do not have values
	# pertaining to X, Y and Z axes.
	# These columns are put in the tidy table as they are
	# lab_e contains their names
	tmp <- select(untidy_table, lab_e)
	tidied_table <- cbind(tidied_table, tmp)
	rm("tmp")

	# This procedure gives a tidy table
	tidied_table <- make_tidy(tidied_table, untidy_table,
		lab_x, lab_y, lab_z)
	
	# Put the column names in a more readable format
	nm <- fix_label(names(tidied_table))
	names(tidied_table) <- nm

	# Tidy table from which we have to select the mean values
	# for each volunteer-activity pair
	tidied_table

	# Group by subject and activity	
	by_volunteer_and_activity <- group_by(tidied_table, subject, activity)

	# Take the mean across groups 
	final_table <- summarise(by_volunteer_and_activity,
		TimeDomainBodyAccMagMean=mean(TimeDomainBodyAccMagMean),
		TimeDomainBodyAccMagSTD=mean(TimeDomainBodyAccMagSTD),
		TimeDomainGravityAccMagMean=mean(TimeDomainGravityAccMagMean),
		TimeDomainGravityAccMagSTD=mean(TimeDomainGravityAccMagSTD),
		TimeDomainBodyAccJerkMagMean=mean(TimeDomainBodyAccJerkMagMean),
		TimeDomainBodyAccJerkMagSTD=mean(TimeDomainBodyAccJerkMagSTD),
		TimeDomainBodyGyroMagMean=mean(TimeDomainBodyGyroMagMean),
		TimeDomainBodyGyroMagSTD=mean(TimeDomainBodyGyroMagSTD),
		TimeDomainBodyGyroJerkMagMean=mean(TimeDomainBodyGyroJerkMagMean),
		TimeDomainBodyGyroJerkMagSTD=mean(TimeDomainBodyGyroJerkMagSTD),
		FreqDomainBodyAccMagMean=mean(FreqDomainBodyAccMagMean),
		FreqDomainBodyAccMagSTD=mean(FreqDomainBodyAccMagSTD),
		FreqDomainBodyAccJerkMagMean=mean(FreqDomainBodyAccJerkMagMean),
		FreqDomainBodyAccJerkMagSTD=mean(FreqDomainBodyAccJerkMagSTD),
		FreqDomainBodyGyroMagMean=mean(FreqDomainBodyGyroMagMean),
		FreqDomainBodyGyroMagSTD=mean(FreqDomainBodyGyroMagSTD),
		FreqDomainBodyGyroJerkMagMean=mean(FreqDomainBodyGyroJerkMagMean),
		FreqDomainBodyGyroJerkMagSTD=mean(FreqDomainBodyGyroJerkMagSTD),
		TimeDomainBodyAccMean=mean(TimeDomainBodyAccMean),
		TimeDomainBodyAccSTD=mean(TimeDomainBodyAccSTD),
		TimeDomainGravityAccMean=mean(TimeDomainGravityAccMean),
		TimeDomainGravityAccSTD=mean(TimeDomainGravityAccSTD),
		TimeDomainBodyAccJerkMean=mean(TimeDomainBodyAccJerkMean),
		TimeDomainBodyAccJerkSTD=mean(TimeDomainBodyAccJerkSTD),
		TimeDomainBodyGyroMean=mean(TimeDomainBodyGyroMean),
		TimeDomainBodyGyroSTD=mean(TimeDomainBodyGyroSTD),
		TimeDomainBodyGyroJerkMean=mean(TimeDomainBodyGyroJerkMean),
		TimeDomainBodyGyroJerkSTD=mean(TimeDomainBodyGyroJerkSTD),
		FreqDomainBodyAccMean=mean(FreqDomainBodyAccMean),
		FreqDomainBodyAccSTD=mean(FreqDomainBodyAccSTD),
		FreqDomainBodyAccJerkMean=mean(FreqDomainBodyAccJerkMean),
		FreqDomainBodyAccJerkSTD=mean(FreqDomainBodyAccJerkSTD),
		FreqDomainBodyGyroMean=mean(FreqDomainBodyGyroMean),
		FreqDomainBodyGyroSTD=mean(FreqDomainBodyGyroSTD),
	)

	write.table(final_table, final_table_file, row.name=FALSE)

	final_table
}

read_data <- function(traindir, trainfile, testdir, testfile) {
	targ <- paste(traindir, trainfile, sep="/")
	df_train <- read.table(targ)

	targ <- paste(testdir, testfile, sep="/")
	df_test <- read.table(targ)

	df <- rbind(df_train, df_test)

	tbl_ret <- tbl_df(df)
	rm(df)

	tbl_ret
}

get_features <- function() {
	ft <- read.table("features.txt")
	ft[,2] <- as.character(ft[,2])
	features <- ft[,2]
}

match_with_volunteers_and_activities <- function(tbl_y, tbl_s, 
	mean_and_std, lab) {
	df_act <- read.table("activity_labels.txt")
	tbl_a <- tbl_df(df_act)
	rm(df_act)

	names(tbl_a) <- c("act_id", "activity")
	names(tbl_y) <- c("act_id")

	# Join activities and activitiy labels
	ya <- inner_join(tbl_y, tbl_a, "act_id")

	untidy_table <- cbind(ya$activity, mean_and_std)

	# Bind activities with volunteer ids
	untidy_table <- cbind(tbl_s, untidy_table)

	tab_names <- c("subject", "activity", lab)
	names(untidy_table) <- tab_names
	untidy_table
}

bind_columns <- function(tidied_table, untidy_table,
	lab_x, lab_y, lab_z, with_axis) {
	tmp <- strsplit(lab_x, "-")
	
	ax_lab <- paste(tmp[[1]][1],tmp[[1]][2],sep="-")
	
	tmp <- gather(untidy_table, "axis", ax_lab,
		lab_x, lab_y, lab_z)

	if (with_axis == TRUE) {
		tmp <- select(tmp, "axis", ax_lab)
		names(tmp) <- c("axis", ax_lab)
		tmp <- mutate(tmp, axis=substr(axis, nchar(axis), nchar(axis)))
		tmp <- mutate(tmp, axis=as.factor(axis))	
	} else {
		tmp <- select(tmp, ax_lab)
		names(tmp) <- c(ax_lab)
	}
	
	tidied_table <- cbind(tidied_table, tmp)
	
	rm("tmp")

	tidied_table
}

make_tidy <- function(tidied_table, untidy_table,
	lab_x, lab_y, lab_z) {

	tidied_table<-bind_columns(tidied_table,untidy_table,
		lab_x[1],lab_y[1],lab_z[1], TRUE)

	for (i in 2:length(lab_x)) {
		tidied_table <- bind_columns(
			tidied_table, untidy_table,
			lab_x[i], lab_y[i], lab_z[i], FALSE)
	}

	tidied_table
}

fix_label <- function(nm) {
	for (i in 1:length(nm)) {
		if (grepl("()", nm[i], fixed = TRUE)) {
			nm[i] <- gsub("()", "", nm[i], fixed = TRUE)
		}
		
		if (grepl("-", nm[i], fixed = TRUE)) {
			nm[i] <- gsub("-", "", nm[i], fixed = TRUE)
		}

		if (grepl("BodyBody", nm[i], fixed = TRUE)) {
			nm[i] <- gsub("BodyBody", "Body", nm[i])
		}

		#nm[i] <- gsub('([[:upper:]])', ' \\1', nm[i])

		initial <- substr(nm[i], 1, 1)
		if (grepl(initial, "f") == TRUE) {
			nm[i] <- substr(nm[i], 2, nchar(nm[i]))
			nm[i] <- paste("FreqDomain", nm[i], sep="")
		} else if (grepl(initial, "t") == TRUE) {
			nm[i] <- substr(nm[i], 2, nchar(nm[i]))
			nm[i] <- paste("TimeDomain", nm[i], sep="")
		}
		
		if (grepl("mean", nm[i], fixed = TRUE)) {
			nm[i] <- gsub("mean", "Mean", nm[i])
		}
		else if (grepl("std", nm[i], fixed = TRUE)) {
			nm[i] <- gsub("std", "STD", nm[i])
		}
	}
	
	nm
}
