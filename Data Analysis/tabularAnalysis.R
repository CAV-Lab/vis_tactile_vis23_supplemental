# import tabular_data.csv as td
str(td)
summary(td)

# H1: Number of wrong forced-choice responses
wrong_count <- sum(!is.na(td$FCWrong))
print(wrong_count) # count = 0

# H2 & H3 Mean Absolute Error of the tabular condition
# qualitative stats including SD and range 

# Calculate mean
mean_value <- mean(td$abs_diff, na.rm = TRUE)

# Calculate standard deviation (sd)
sd_value <- sd(td$abs_diff, na.rm = TRUE)

# Calculate range (min to max)
range_min <- min(td$abs_diff, na.rm = TRUE)
range_max <- max(td$abs_diff, na.rm = TRUE)

# Print the results
print(paste("Mean:", mean_value))
print(paste("Standard Deviation (sd):", sd_value))
print(paste("Range (min to max):", range_min, "to", range_max))

# H4 and H5 likert responses analysis
# first import likert_results.csv as 'lr' 
lr <- likert_results
lr <- lr[, -c(2:7)]

# rename columns and concatenate the data
colnames(lr)[colnames(lr) == 'X1.leastaccuracy.7.highestaccuracy...Tabular'] <- 'accuracy - Tabular'
colnames(lr)[colnames(lr) == 'X1.extremelyeasy.10.extremelydemanding...Tabular'] <- 'demand - Tabular'
colnames(lr)[colnames(lr) == 'X1.extremelyrelaxed.10.extremelystressed...Tabular'] <- 'frustration - Tabular'


# reshape the columns from the current name
# New column "condition" has "tactile", "tabular", and "visual"
lr <- lr %>%
  gather(variable, value, -participant_id) %>%
  separate(variable, into = c("measure", "condition"), sep = " - ") %>%
  spread(measure, value)

# get descriptive stats for "demand" "accuracy" and "frustration" respectively 
# Compute mean values for accuracy, demand, and frustration for tabular condition
summary_stats <- function(x) {
  c(mean = mean(x), 
    sd = sd(x),
    min = min(x),
    max = max(x))
}

mean_accuracy <- aggregate(lr$accuracy ~ lr$condition, FUN=summary_stats)
mean_demand <- aggregate(lr$demand ~ lr$condition, FUN=summary_stats)
mean_frustration <- aggregate(lr$frustration ~ lr$condition, FUN=summary_stats)

# Print the results
print(mean_accuracy)
print(mean_demand)
print(mean_frustration)
