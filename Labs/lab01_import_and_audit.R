#' @title lab01_import_and_audit.R
#' @description Import the open-world user test survey CSV, inspect it, apply a simple data quality gate, and export a cleaned CSV for later labs.
#' @author NMCG
#' @bugs None
#' @keywords readr, janitor, csv, data quality, missing values, factors
#' @seealso https://readr.tidyverse.org/
#' @generated_at 2026-01-29 07:56 GMT

# -----------------------------
# Lab 01: Import + Audit + Clean
# -----------------------------

# loads utility functions into the session
source("../common/common_helpers.R")        

# Clear the console in RStudio (safe to ignore elsewhere).
clear_workspace_and_console()            

# Set working directory
set_wd_to_this_file(verbose = TRUE)                         

# Create output folder.
create_directory("output", verbose = TRUE)                                  

# Load required packages for Lab 1.
load_pkg("readr")                                        # Used for read_csv() and write_csv().
load_pkg("janitor")                                      # Used for clean_names().

# Read the CSV file into a data frame called df.
df <- readr::read_csv(                                   # Read a CSV file.
  "data/open_world_user_testing_survey_data.csv",         # Relative path to the dataset.
  show_col_types = FALSE                                 # Keep the console clean for beginners.
)                                                        # End read_csv call.

# Clean column names to snake_case (consistent naming for later labs).
df <- janitor::clean_names(df)                           # Convert column names to snake_case.

# Inspect the data using "survival commands".
str(df)                                                  # Show structure: column types + a preview of values.
head(df, 5)                                              # Show the first 5 rows.
tail(df, 2)                                              # Show the last 2 rows.
summary(df)                                              # Show quick numeric summaries and factor counts.

# Print the dataset dimensions (rows, columns).
print(paste("Rows:", nrow(df)))                          # Print number of rows.
print(paste("Columns:", ncol(df)))                       # Print number of columns.

# Count missing values (NA) per column.
missing_by_column <- colSums(is.na(df))                  # Count NA values for each column.
print("Missing values per column:")                      # Print a label to the console.
print(missing_by_column)                                 # Print the NA counts.

# Convert key categorical columns to factors (helps grouping + plotting later).
df$build <- as.factor(df$build)                          # Convert build to factor.
df$experience_band <- as.factor(df$experience_band)      # Convert experience_band to factor.
df$platform <- as.factor(df$platform)                    # Convert platform to factor.

# Convert task completion flags to integer 0/1 (ensures mean() works as completion proportion).
df$task1_complete <- as.integer(df$task1_complete)       # Convert task1_complete to integer.
df$task2_complete <- as.integer(df$task2_complete)       # Convert task2_complete to integer.
df$task3_complete <- as.integer(df$task3_complete)       # Convert task3_complete to integer.

# Data quality gate rule:
# If taskX_complete == 0 then taskX_time_sec should be NA.
# Count rule violations (time exists even though task not completed).
viol_task1 <- sum(df$task1_complete == 0 & !is.na(df$task1_time_sec))  # Count violations for task 1.
viol_task2 <- sum(df$task2_complete == 0 & !is.na(df$task2_time_sec))  # Count violations for task 2.
viol_task3 <- sum(df$task3_complete == 0 & !is.na(df$task3_time_sec))  # Count violations for task 3.

print(paste("Violations (Task 1):", viol_task1))         # Print task 1 violations.
print(paste("Violations (Task 2):", viol_task2))         # Print task 2 violations.
print(paste("Violations (Task 3):", viol_task3))         # Print task 3 violations.

# Enforce the rule (make times NA whenever a task is incomplete).
df$task1_time_sec[df$task1_complete == 0] <- NA          # Set task 1 time to NA when incomplete.
df$task2_time_sec[df$task2_complete == 0] <- NA          # Set task 2 time to NA when incomplete.
df$task3_time_sec[df$task3_complete == 0] <- NA          # Set task 3 time to NA when incomplete.

# Re-count violations after enforcement (should now be 0).
viol_task1_after <- sum(df$task1_complete == 0 & !is.na(df$task1_time_sec))  # Re-check task 1.
viol_task2_after <- sum(df$task2_complete == 0 & !is.na(df$task2_time_sec))  # Re-check task 2.
viol_task3_after <- sum(df$task3_complete == 0 & !is.na(df$task3_time_sec))  # Re-check task 3.

print(paste("Violations after fix (Task 1):", viol_task1_after))        # Print post-fix task 1.
print(paste("Violations after fix (Task 2):", viol_task2_after))        # Print post-fix task 2.
print(paste("Violations after fix (Task 3):", viol_task3_after))        # Print post-fix task 3.

# Export the cleaned dataset for Lab 2 and Lab 3.
readr::write_csv(df, "output/df_clean_lab01.csv")        # Write cleaned CSV.

print("Saved cleaned dataset to: output/df_clean_lab01.csv")            # Print confirmation.
