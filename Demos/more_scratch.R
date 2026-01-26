# read some data from csv

# variable and method naming convention is PASCAL
survey_data <- read.csv("data/open_world_user_testing_survey_data.csv")

print("Summary...")
summary(survey_data)

print("Head...")
head(survey_data, 5)

print("Tail...")
tail(survey_data, 2)

#descriptive statistics
median_like <- median(survey_data$recommend_0to10)
median_like

print(paste("The median recommendation value is", median_like))

avg_ttc <-ave(survey_data$task1_complete); 
avg_ttc

hist(survey_data$task1_time_sec,
     main = "Some nice graph",
     breaks = 8,
     col = "red",
     xlab = "XXXXX",
     ylab = "YYYYY",
     xlim = c(100,200))

#stripchart(survey_data$navigation_1to7)

stripchart(chickwts$weight)

#boxplot()

# data()

boxplot(chickwts$weight~chickwts$feed)











