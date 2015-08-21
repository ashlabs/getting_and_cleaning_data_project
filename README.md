# [Getting and Cleaning data course assignment](https://class.coursera.org/getdata-031/human_grading/view/courses/975115/assessments/3/submissions)

1. Checks if the target data file exists (zip). If not downloads the file.
2. Checks if the extracted folder exists in the current folder. If not, extracts the contents.
3. Loads the activity and feature datasets. 
4. Loads the training and activity datasets and filters out to only the mean and standard deviation columns.
5. Loads the activity and subject data for each dataset, and merges those columns with the dataset.
6. Merges the two datasets
7. Converts the activity and subject columns into factors
8. Creates a tidy dataset that consists of the average (mean) value of each variable for each subject and activity pair.
