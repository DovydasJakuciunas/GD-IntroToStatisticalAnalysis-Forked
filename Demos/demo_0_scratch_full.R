#' @title w1_00_scratch.R
#' @description A hscratchpad introducing core R concepts (data types, control flow, functions, packages, vectors, data frames) and basic plotting for game user-test analysis.
#' @author NMCG
#' @bugs None
#' @keywords data types, conditionals, loops, functions, packages, vectors, data frames, str, head, summary, stripchart, hist, boxplot
#' @seealso https://www.w3schools.com/r/default.asp
#' @seealso https://r4ds.hadley.nz/

# -----------------------------
# Week 1 Scratch Demo
# Goal: get comfortable with basic R code before touching the real dataset.
# -----------------------------

# Clear the workspace so the script runs the same way every time.
rm(list = ls())

# Clear the console for readability.
cat("\014")

# -----------------------------
# 1) Core data types in R
# -----------------------------

# Numeric (double) values are used for measurements (e.g., time in seconds).
time_sec <- 245.5

# Integer values are whole numbers (e.g., number of deaths).
deaths <- 3L

# Logical values are TRUE/FALSE (e.g., task completion).
task_complete <- TRUE

# Character strings are text labels (e.g., build label "A" or "B").
build <- "A"

# Print values.
time_sec
deaths
task_complete
build

# Inspect types using class().
class(time_sec)
class(deaths)
class(task_complete)
class(build)

# -----------------------------
# 2) Vectors: the basic storage type
# -----------------------------

# A vector stores multiple values of the same type.
task_times <- c(120, 180, 240, 300, 600)

# Print the vector.
task_times

# Indexing in R uses 1-based indexing (first element is index 1).
task_times[1]
task_times[5]

# Vectorised operations apply to all elements.
task_times + 10
task_times / 60

# Useful built-in summaries.
mean(task_times)
median(task_times)
min(task_times)
max(task_times)

# Missing values are represented by NA.
task_times_with_na <- c(120, 180, NA, 300, 600)

# Many functions need na.rm = TRUE to ignore NA values.
mean(task_times_with_na)
mean(task_times_with_na, na.rm = TRUE)

# -----------------------------
# 3) Factors: categorical data with levels (important for builds, platforms, experience bands)
# -----------------------------

# Factor is used for categorical variables with known levels.
experience_band <- factor(c("beginner", "experienced", "intermediate", "beginner"))

# Print the factor.
experience_band

# Show levels.
levels(experience_band)

# You can set an explicit order (useful for plotting and reporting).
experience_band_ordered <- factor(
  c("beginner", "experienced", "intermediate", "beginner"),
  levels = c("beginner", "intermediate", "experienced"),
  ordered = TRUE
)

# Print ordered factor and levels.
experience_band_ordered
levels(experience_band_ordered)

# -----------------------------
# 4) Conditionals: if / else (flow control)
# -----------------------------

# A simple conditional to categorise a time-on-task value.
# IMPORTANT (R syntax): when using else / else if, prefer braces so the parser
# treats the whole chain as a single expression (avoids 'unexpected else' errors).
if (time_sec < 180)
{
  message("Fast completion (under 3 minutes).")
} else if (time_sec < 360)
{
  message("Moderate completion time (3–6 minutes).")
} else
{
  message("Slow completion time (over 6 minutes).")
}

# A practical binary variable often used in user testing.
task2_complete <- 0L
task2_time_sec <- NA

# If the task is completed, then time must exist.
# IMPORTANT (R syntax): use braces to keep else attached to the if.
if (task2_complete == 1L)
{
  task2_time_sec <- 260
} else {
  task2_time_sec <- NA
}

# Print result.
task2_time_sec

# -----------------------------
# 5) Loops: for (when you need step-by-step logic)
# -----------------------------

# Although R is strong with vectorised operations, loops can still be useful for teaching logic.
times <- c(120, 200, 400, 800)

# For loop over each value in times.
# IMPORTANT (R syntax): use braces so else/else if binds correctly.
for (t in times)
{
  if (t <= 180)
  {
    print(paste(t, "sec -> fast"))
  } else if (t <= 360) {
    print(paste(t, "sec -> moderate"))
  } else {
    print(paste(t, "sec -> slow"))
  }
}

# -----------------------------
# 6) Writing your own functions
# -----------------------------

# A function is reusable code that takes inputs and returns outputs.
categorise_time <- function(time_in_seconds)
{
  # Validate input: if missing, return NA (not available).
  if (is.na(time_in_seconds))
    return(NA)

  # Use thresholds to return a category label.
  if (time_in_seconds < 180)
    return("fast")
  else if (time_in_seconds < 360)
    return("moderate")
  else
    return("slow")
}

# Test the function with a few values.
categorise_time(120)
categorise_time(250)
categorise_time(900)
categorise_time(NA)

# Apply function across a vector using sapply() (simple teaching tool).
sapply(times, categorise_time)

# -----------------------------
# 7) External functions (packages) and why we use them
# -----------------------------

# Packages add functions and tools beyond base R.
# We'll use tidyverse-style packages later (readr, dplyr, tidyr, ggplot2).
#
# Install packages ONCE:
# install.packages("dplyr")
#
# Load packages EVERY session you need them:
# library(dplyr)

# -----------------------------
# 8) Data frames: table-like storage (rows = participants, columns = variables)
# -----------------------------

# Create a small fake user-test data frame for practice.
df <- data.frame(
  respondent_id = c("R01", "R02", "R03", "R04"),
  build = c("A", "A", "B", "B"),
  experience_band = c("beginner", "intermediate", "beginner", "experienced"),
  task2_complete = c(1, 0, 1, 1),
  task2_time_sec = c(260, NA, 220, 410),
  ui_clarity_1to7 = c(3, 2, 5, 6),
  stringsAsFactors = FALSE
)

# Print the data frame.
df

# -----------------------------
# 9) Interrogating data frames
# -----------------------------

# str() shows structure and column types.
str(df)

# head() shows first rows.
head(df)

# tail() shows last rows.
tail(df)

# summary() gives quick descriptive summaries (works well for numeric columns).
summary(df)

# You can select a column by name with $.
df$task2_time_sec

# You can filter rows using logical conditions (base R approach).
df[df$build == "A", ]

# -----------------------------
# 10) Basic descriptive statistics (base R)
# -----------------------------

# Completion proportion for task2: mean of 0/1 values.
mean(df$task2_complete)

# Median time-on-task for completed attempts only.
median(df$task2_time_sec, na.rm = TRUE)

# IQR for time-on-task (completed only).
IQR(df$task2_time_sec, na.rm = TRUE)

# -----------------------------
# 11.1) Basic plots 2 (in-built data)
# -----------------------------

# For plotting practice, we'll use an inbuilt dataset: chickwts.
# chickwts contains chicken weights and the feed type used.
# This is a nice example of a numeric variable (weight) and a categorical variable (feed).
# ------------------------------------------------------------
# Extra base R plots using the inbuilt chickwts dataset
# (numeric: weight, categorical: feed)
# ------------------------------------------------------------

# Load dataset (built-in)
data(chickwts)

# Convenience variables
weights <- chickwts$weight
feed <- chickwts$feed

# ------------------------------------------------------------
# a) Dot chart by group (sorted within groups)
# Great "leaderboard-style" grouped view.
# ------------------------------------------------------------
dotchart(
  x = weights,
  groups = feed,
  main = "Chick weights by feed (dotchart)",
  xlab = "Weight"
)

# ------------------------------------------------------------
# b) Stripchart by group (jittered points)
# Great for seeing individual observations per category.
# ------------------------------------------------------------
stripchart(
  weight ~ feed,
  data = chickwts,
  method = "jitter",
  vertical = TRUE,
  las = 2,
  main = "Chick weights by feed (stripchart)",
  ylab = "Weight",
  xlab = "Feed type"
)

# ------------------------------------------------------------
# c) Boxplot + points overlay (boxplot + jittered raw data)
# Students often like seeing "summary + raw" together.
# ------------------------------------------------------------
boxplot(
  weight ~ feed,
  data = chickwts,
  las = 2,
  main = "Chick weights by feed (boxplot + points)",
  xlab = "Feed type",
  ylab = "Weight"
)

stripchart(
  weight ~ feed,
  data = chickwts,
  method = "jitter",
  vertical = TRUE,
  add = TRUE,
  pch = 16,
  col = "black"
)

# ------------------------------------------------------------
# d) Density plot (smooth distribution)
# Like a smoothed histogram.
# ------------------------------------------------------------
plot(
  density(weights),
  main = "Distribution of chick weights (density)",
  xlab = "Weight",
  ylab = "Density"
)

# Optional: add a vertical line at the median
abline(v = median(weights), lty = 2)

# ------------------------------------------------------------
# e) ECDF (Empirical Cumulative Distribution Function)
# Great for teaching percentiles (median = 0.5).
# ------------------------------------------------------------
plot(
  ecdf(weights),
  main = "ECDF of chick weights",
  xlab = "Weight",
  ylab = "F(weight)"
)

# Optional: show median location
abline(v = median(weights), lty = 2)
abline(h = 0.5, lty = 2)

# ------------------------------------------------------------
# f) Group means with Standard Error (SE) error bars
# Teaches "compare groups" with a simple uncertainty cue.
# ------------------------------------------------------------

# Compute mean and SE by feed
means <- tapply(chickwts$weight, chickwts$feed, mean)
sds <- tapply(chickwts$weight, chickwts$feed, sd)
ns <- tapply(chickwts$weight, chickwts$feed, length)
ses <- sds / sqrt(ns)

# Plot means (as points) with error bars
plot(
  x = seq_along(means),
  y = means,
  xaxt = "n",
  pch = 16,
  main = "Mean chick weight by feed (± SE)",
  xlab = "Feed type",
  ylab = "Mean weight"
)

# Add feed labels on x-axis
axis(1, at = seq_along(means), labels = names(means), las = 2)

# Add error bars (mean ± SE)
arrows(
  x0 = seq_along(means),
  y0 = means - ses,
  x1 = seq_along(means),
  y1 = means + ses,
  angle = 90,
  code = 3,
  length = 0.05
)


# -----------------------------
# 11.2) Basic plots 1 (user-defined dataframe)
# -----------------------------

# Stripchart (useful to visualise individual points quickly).
stripchart(
  df$task2_time_sec,
  method = "jitter",
  main = "Task 2 time-on-task (seconds)",
  xlab = "Time (seconds)"
)

# Histogram (distribution shape).
hist(
  df$task2_time_sec,
  main = "Distribution of Task 2 time-on-task",
  xlab = "Time (seconds)",
  breaks = 5
)

# Boxplot (median + IQR + outliers).
boxplot(
  df$task2_time_sec,
  main = "Task 2 time-on-task (boxplot)",
  ylab = "Time (seconds)"
)

# Boxplot by group (e.g., build).
boxplot(
  task2_time_sec ~ build,
  data = df,
  main = "Task 2 time-on-task by build",
  xlab = "Build",
  ylab = "Time (seconds)"
)

# -----------------------------
# 12) Operators, type checking, and coercion (core elements)
# -----------------------------

# Mathematical operators work as you expect: +, -, *, /, ^
a <- 10
b <- 12

# Exponentiation using ^
c <- a ^ b
c

# Operator precedence matters; use parentheses when unsure.
d <- 10 * a + b / 2.3
d

# Modulus (remainder) uses %%
remainder <- 17 %% 3
remainder

# Type checking is essential when cleaning and validating data.
is.numeric(2.5)
is.numeric("2.5")

# Vectors are collections of values of (typically) the same type.
ages <- c(19, 23, 45, 61)
is.vector(ages)

# Type coercion converts one type to another (common when importing CSV/Excel).
age_as_numeric <- as.numeric("32")
age_as_numeric
class(age_as_numeric)

age_as_character <- as.character(32)
age_as_character
class(age_as_character)

# Complex numbers exist in R (not common in this module, but good to recognise).
# A complex number has real and imaginary parts; the imaginary unit is i.
complex_val <- 3i + 4
complex_val
class(complex_val)

# -----------------------------
# 13) Printing and formatting output (clear console messages)
# -----------------------------

module <- "3DGD"

initials <- "NMCG"

# print() prints a value.
print(module)

# paste() combines text and values into one string (good for simple reporting).
print(paste("The module", module, "is taught by", initials))

# You can control separators using sep=, and line breaks with \n.
print(paste("Participant:", "R01", "|", "Build:", "A", sep = " "))
print(paste("Line1", "Line2", sep = "\n"))

# -----------------------------
# 14) Built-in (base R) math functions you’ll see in analysis work
# -----------------------------

# Logs (base-10, base-2, natural log) are common in data transformation.
log10(1000)
log2(64)
log(1000)                # natural log (base e) by default
log(1000, base = exp(1)) # explicit natural log

# Exponentials and powers.
exp(1)      # e
2 ^ 4
sqrt(25)

# Absolute value, rounding, and constants.
abs(-10.58)
abs(-1e6)
round(pi, 3)

# -----------------------------
# 15) While loops (control flow alternative)
# -----------------------------

# while loops run until a condition becomes FALSE.
# Use them when you don’t know in advance how many iterations you need.
counter <- 1
while (counter <= 3)
{
  print(paste("Counter =", counter))
  counter <- counter + 1
}

# -----------------------------
# 16) Named arguments and flexible function calls
# -----------------------------

# Many R functions allow named arguments, which improves readability.
round(pi, digits = 4)

# You can pass arguments out of order when you name them.
seq(from = 1, to = 10, by = 2)

# -----------------------------
# 17) More vector tools (sequences, repetition, filtering, sorting, sets)
# -----------------------------
# A numeric vector of example scores (used in several vector operations below).
player_scores <- c(100, 155, 201, 222, 240, 180, 199)


# Sequence generation with seq()
odd_rounds <- seq(from = 1, to = 20, by = 2)
odd_rounds

difficulty_levels <- seq(from = 0.5, to = 5, length.out = 10)
difficulty_levels

# Repetition with rep()
life_counts <- rep(3, times = 10)
life_counts

# Repeat each element twice
# Here we define a character vector of level names (not to be confused with the levels() function).
level_names <- c("Grassy Plains", "Misty Mountains", "Arid Desert")
repeated_levels <- rep(level_names, each = 2)
repeated_levels

# Logical filtering and indexing (combine conditions with & and |)
high_scores <- player_scores[player_scores > 200 & player_scores %% 2 == 1]
high_scores

# Pattern matching with grep() (returns indices); use it to filter character vectors.

# Here we search within a character vector (level_names) for a pattern.
# ignore.case = TRUE makes the match case-insensitive.
levels_with_un <- level_names[grep("un", level_names, ignore.case = TRUE)]
levels_with_un

# grep() returns the indices of matches.
grep("un", level_names, ignore.case = TRUE)
# all() and any() help test conditions across vectors.
all(player_scores > 100)
any(player_scores > 220)

# Sorting and ordering
sorted_scores <- sort(player_scores)
sorted_scores

sorted_scores_desc <- sort(player_scores, decreasing = TRUE)
sorted_scores_desc

# order() returns indices that sort the vector; useful for sorting data frames by a column.
order_indices <- order(player_scores)
order_indices

# Set operations (useful for comparing lists of items)
completed_levels <- c("Grassy Plains", "Misty Mountains", "Arid Desert", "Icy Tundra")
yet_to_complete_levels <- c("Icy Tundra", "Volcanic Island", "Lava Lair")

union(completed_levels, yet_to_complete_levels)
intersect(completed_levels, yet_to_complete_levels)
setdiff(completed_levels, yet_to_complete_levels)

# -----------------------------
# 18) External (sourced) functions: reusing code across files
# -----------------------------

# In larger projects we store functions in a separate file and import them with source().
# Example (NOT required for this module unless we provide a functions file):
# source("w1_00_ExternalFunctions.R")
#
# After sourcing, you can call those functions like any other function.
# The key teaching point: source() lets teams share and reuse validated code.

# -----------------------------
# 19) More data frame operations (create, update, filter, sort, merge, aggregate)
# -----------------------------

# Adding a column (vector length must match number of rows).
df$session_minutes <- c(12, 10, 15, 9)
df

# Removing a column by setting it to NULL.
df$session_minutes <- NULL
df

# Adding a row using rbind() (must have matching column names).
new_row <- data.frame(
  respondent_id = "R05",
  build = "A",
  experience_band = "beginner",
  task2_complete = 0,
  task2_time_sec = NA,
  ui_clarity_1to7 = 2,
  stringsAsFactors = FALSE
)

df <- rbind(df, new_row)
df

# Removing a row by index (remove the last row we just added).
df <- df[-nrow(df), ]
df

# Creating a derived variable.
# Here: a simple indicator for missing time values.
df$time_missing <- is.na(df$task2_time_sec)
df

# Filtering rows (base R)
df_build_a <- df[df$build == "A", ]
df_build_a

# Sorting rows using order()
df_sorted_by_ui <- df[order(df$ui_clarity_1to7, decreasing = TRUE), ]
df_sorted_by_ui

# Handling missing values
rows_with_missing_time <- df[is.na(df$task2_time_sec), ]
rows_with_missing_time

# Remove rows with any NA values (use cautiously in real analysis).
df_no_na <- na.omit(df)
df_no_na

# Column-wise max/min (ignore NA)
max(df$ui_clarity_1to7, na.rm = TRUE)
min(df$ui_clarity_1to7, na.rm = TRUE)

# Duplicate detection (useful for validating imported datasets)
df$duplicated_row <- duplicated(df)
df

# Transpose (t()) is mainly useful for matrices; here we show it as a concept.
# Example: transpose the first row into a vertical layout.
transposed_first_row <- as.data.frame(t(df[1, ]))
transposed_first_row

# Aggregation: compute a summary by group using aggregate()
avg_ui_by_build <- aggregate(ui_clarity_1to7 ~ build, data = df, FUN = mean)
avg_ui_by_build

# Group-wise operations using tapply()
tapply(df$ui_clarity_1to7, df$build, mean)

# split() returns a list of data frames, one per group.
split(df, df$build)

# Merging / joining: merge() combines data frames by a key.
ratings_df <- data.frame(
  respondent_id = c("R01", "R02", "R03", "R04"),
  recommend_0to10 = c(4, 2, 8, 9),
  stringsAsFactors = FALSE
)

merged_df <- merge(df, ratings_df, by = "respondent_id")
merged_df

# subset() is a convenient helper for filtering.
subset(merged_df, recommend_0to10 >= 8)

# transform() is a convenient helper for adding/modifying columns.
transform(merged_df, recommend_scaled = recommend_0to10 / 10)

# unique() gets unique values in a column (useful for checking coding consistency).
unique(df$experience_band)

# -----------------------------
# 20) Basic plotting colours (optional note)
# -----------------------------

# In base R, you can set colours with names or rgb().
# Keep plots readable: label axes, add titles, and use consistent units.
# Example:
# boxplot(df$ui_clarity_1to7, main = "UI clarity", col = rgb(0.6, 0.5, 0))

# -----------------------------
# 21) Where this fits in the module
# -----------------------------

# Next demo file:
# w1_01_import_inspect_clean.R
# - imports the real dataset
# - cleans column names
# - validates basic rules
# - writes a cleaned dataset to output/

message("Scratch demo complete. You now have the basics to read, inspect, and plot user-test data.")
