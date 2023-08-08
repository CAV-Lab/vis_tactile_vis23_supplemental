# first import likert_results.csv as 'lr' 
lr <- likert_results

# rename columns and concatenate the data
colnames(lr)[colnames(lr) == 'X1.leastaccuracy.7.highestaccuracy...Tactile'] <- 'accuracy - Tactile'
colnames(lr)[colnames(lr) == 'X1.extremelyeasy.10.extremelydemanding...Tactile'] <- 'demand - Tactile'
colnames(lr)[colnames(lr) == 'X1.extremelyrelaxed.10.extremelystressed...Tactile'] <- 'frustration - Tactile'
colnames(lr)[colnames(lr) == 'X1.leastaccuracy.7.highestaccuracy...Visual'] <- 'accuracy - Visual'
colnames(lr)[colnames(lr) == 'X1.extremelyeasy.10.extremelydemanding...Visual'] <- 'demand - Visual'
colnames(lr)[colnames(lr) == 'X1.extremelyrelaxed.10.extremelystressed...Visual'] <- 'frustration - Visual'
colnames(lr)[colnames(lr) == 'X1.leastaccuracy.7.highestaccuracy...Tabular'] <- 'accuracy - Tabular'
colnames(lr)[colnames(lr) == 'X1.extremelyeasy.10.extremelydemanding...Tabular'] <- 'demand - Tabular'
colnames(lr)[colnames(lr) == 'X1.extremelyrelaxed.10.extremelystressed...Tabular'] <- 'frustration - Tabular'


# reshape the columns from the current name
# New column "condition" has "tactile", "tabular", and "visual"
lr <- lr %>%
  gather(variable, value, -participant_id) %>%
  separate(variable, into = c("measure", "condition"), sep = " - ") %>%
  spread(measure, value)

# Now performing Wilcoxon signed-rank test to compare visual and tactile
# Split data based on condition
tactile_lr <- lr[lr$condition == "Tactile",]
visual_lr <- lr[lr$condition == "Visual",]

# Perform the Wilcoxon signed-rank test 
result_demand <- wilcox.test(tactile_lr$demand, visual_lr$demand, paired=TRUE)
print(result_demand)

result_accuracy <- wilcox.test(tactile_lr$accuracy, visual_lr$accuracy, paired=TRUE)
print(result_accuracy)

result_frus <- wilcox.test(tactile_lr$frustration, visual_lr$frustration, paired=TRUE)
print(result_frus)

# get descriptive stats for "demand" "accuracy" and "frustration" respectively 
# Compute mean values for accuracy, demand, and frustration within each condition
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
