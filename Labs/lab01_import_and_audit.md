---
title: "Lab 01: R Basics, Importing Survey Data, and a Data Quality Gate"
lab_code: "lab01"
dataset: "data/open_world_user_testing_survey_data.csv"
estimated_time_minutes: 80
generated_at: "2026-01-29 08:55 GMT"
---

# Lab 01: R Basics, Importing Survey Data, and a Data Quality Gate

## What you’ll learn

- How to run R code confidently (objects, functions, data frames).
- How to import a CSV into a data frame and inspect it using a few “survival” commands.
- How to apply a simple **data quality gate** so our analysis in Lab 2 is trustworthy.
- How to export a clean dataset for later labs.

## Files and outputs

| Item | Path |
| :- | :- |
| Input CSV | `data/open_world_user_testing_survey_data.csv` |
| Shared helpers | `common_helpers.R` |
| Output folder | `output/` |
| Cleaned dataset (you will create) | `output/df_clean_lab01.csv` |
| Rescue file (if you fall behind) | `rescue/df_clean_lab01.csv` |

## Part A: Warm-up (10 minutes)

1. Open `w1_00_scratch.R`
2. Press **Source** (or run top-to-bottom)

✅ **Checkpoint A1:** you see at least one plot (stripchart/hist/boxplot) and no errors.

---

## Part B: Create your Lab 1 script (copy/paste blocks)

### Step B0: Create the file

1. In RStudio: **File → New File → R Script**
2. Save it as: `lab01_import_and_audit.R`

### Step B1: Paste this header + helper setup

```r
# ---------------------------------------------
# Lab 01: Import + Audit + Clean
# ---------------------------------------------

# Load shared helper functions (must exist in your project root).
source("common_helpers.R")

# Start clean and predictable.
clear_workspace_and_console()

# Ensure output folder exists.
create_directory("output")
```

✅ **Checkpoint B1:** run it — no errors.

### Step B2: Install + load packages

```r
load_pkg("readr")
load_pkg("janitor")
```

✅ **Checkpoint B2:** no errors when loading packages.

### Step B3: Import the CSV into `df`

```r
df <- readr::read_csv(
  "data/open_world_user_testing_survey_data.csv",
  show_col_types = FALSE
)

df <- janitor::clean_names(df)
```

✅ **Checkpoint B3:** run:

```r
nrow(df)
ncol(df)
names(df)
```

---

## Part C: Inspect the dataset (15 minutes)

```r
str(df)
head(df, 5)
tail(df, 2)
summary(df)
```

✅ **Checkpoint C1:** you can point at 3 columns and explain what they measure.

### Count missing values (NA) per column

```r
missing_by_column <- colSums(is.na(df))
missing_by_column
```

✅ **Checkpoint C2:** you get one number per column.

---

## Part D: Data quality gate (20 minutes)

### Step D1: Convert key columns to correct types

```r
df$build <- as.factor(df$build)
df$experience_band <- as.factor(df$experience_band)
df$platform <- as.factor(df$platform)

df$task1_complete <- as.integer(df$task1_complete)
df$task2_complete <- as.integer(df$task2_complete)
df$task3_complete <- as.integer(df$task3_complete)
```

✅ **Checkpoint D1:** run:

```r
str(df$build)
str(df$task1_complete)
```

### Step D2: Count violations of the rule “no time if incomplete”

```r
viol_task1 <- sum(df$task1_complete == 0 & !is.na(df$task1_time_sec))
viol_task2 <- sum(df$task2_complete == 0 & !is.na(df$task2_time_sec))
viol_task3 <- sum(df$task3_complete == 0 & !is.na(df$task3_time_sec))

viol_task1
viol_task2
viol_task3
```

✅ **Checkpoint D2:** you see three numbers (often 0).

### Step D3: Enforce the rule (make times NA when incomplete)

```r
df$task1_time_sec[df$task1_complete == 0] <- NA
df$task2_time_sec[df$task2_complete == 0] <- NA
df$task3_time_sec[df$task3_complete == 0] <- NA
```

✅ **Checkpoint D3:** re-run the violation counts; they should now be 0.

---

## Part E: Export the cleaned dataset (5 minutes)

```r
readr::write_csv(df, "output/df_clean_lab01.csv")
```

✅ **Checkpoint E1:** confirm `output/df_clean_lab01.csv` exists.

---

## Reflective questions

1. Which columns are **categorical**, which are **numeric**, and which are **ordinal ratings**?
2. Why does the “time must be NA when incomplete” rule matter for fair comparisons?
3. If you found missing values, what are two sensible ways to handle them (and how would you document the decision)?
