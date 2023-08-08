# First import perception_tasks.csv as "pt"
# Initially we have 864 values in total. 432 for each conditions. 
# library used: dplyr, ggplot2 
summary(pt)
str(pt)

# Now performing data cleaning for H2 and H3
# The idea is to exclude data points beyond 3 sd but within each condition and each type respectively
clean_pt_H3 <- pt %>%
  group_by(condition, type) %>%
  mutate(mean_error= mean(raw_error),
         sd_value = sd(raw_error),
         excluded_count = sum(abs(raw_error-mean_error) > 3 * sd_value)) %>%
  filter(abs(raw_error - mean_error) <= 3 * sd_value) %>%
  ungroup() %>%
  select(-mean_error, -sd_value)

clean_pt_H3 <- clean_pt_H3 %>%
  mutate(abs_error = abs(raw_error))

# Group by 'condition' and 'type', and calculate the number of data points for each combination
count_data_points <- clean_pt_H3 %>%
  group_by(condition, type) %>%
  summarise(data_points = n()) %>%
  ungroup()
print(count_data_points)

# calculate the mean absolute error for the two conditions
condition_stats <- clean_pt_H3 %>%
  group_by(condition) %>%
  summarise(
    mean_abs_error = sprintf("%.2f", mean(abs(abs_error))),
    data_range = sprintf("%.2f%% to %.2f%%", min(abs_error), max(abs_error)),
    std_dev = sprintf("%.2f", sd(abs_error))
  ) %>%
  ungroup()
print(condition_stats)


# Calculate MAE for each combination of condition and encoding type
# Group by 'condition' and 'type', and calculate the mean absolute error for each combination
mean_abs_error <- clean_pt_H3 %>%
  group_by(condition, type) %>%
  summarise(
    mean_abs_error = sprintf("%.2f", mean(abs(abs_error))),
    range = sprintf("%.2f", max(abs_error) - min(abs_error)),
    std_dev = sprintf("%.2f", sd(abs_error))
  ) %>%
  ungroup()
print(mean_abs_error)

# Plot the visualization for encoding channel ranking using cleaned data
point_colors <- c("#1f78b4", "#33a02c", "#e31a1c", "#ff7f00", "#6a3d9a", "#a6cee3")  
line_colors <- c("#a6cee3", "#b2df8a", "#fb9a99", "#fdbf6f", "#cab2d6", "#1f78b4")  

# This plot visualizes the mean absolute error (MAE) over different true percentage values, categorized by encoding types and conditions.
# The scatter points represent the calculated MAE, grouped by 'type', and are color-coded by encoding type.
# The two facets display tactile and visual condition separately, and a second-degree polynomial regression line is fitted for each encoding type.

clean_pt_H3$type <- factor(clean_pt_H3$type, levels = ranking)

clean_pt_H3 %>%
  group_by(truePercent, type, condition) %>%
  summarise(mean_abs_error = mean(raw_error)) %>%
  ggplot(aes(truePercent, mean_abs_error, color = type, fill = type)) +
  facet_wrap(~condition) +
  geom_point(position = position_dodge(width = .5), size = 3, aes(color = type)) +  
  geom_smooth(aes(group = type), method = "lm", formula = y ~ poly(x, degree = 3), se = FALSE, linewidth = 1.5) +
  
  # Set the color scale for points and lines
  scale_color_manual(values = point_colors) +
  scale_fill_manual(values = line_colors) +
  
  # Add a horizontal line at y = 0
  geom_hline(yintercept = 0, linetype = "dashed", color = "red") +
  
  labs(x = "True Percent", y = "Raw Error",
       title = "Mean Raw Error over True Percent",
       subtitle = "Polynomial fit for each type", color = "Encoding", fill = "Encoding") +
  theme(panel.grid = element_blank(),
        panel.background = element_rect(fill = "white"),
        panel.border = element_rect(color = "black", fill = NA),
        strip.background = element_blank())

# Now performing ALigned Rank Transform for H3 
# first divide the cleaned dataset by condition
clean_tac_H3 <- clean_pt_H3 %>%
  filter(condition == "Tactile")
clean_vis_H3 <- clean_pt_H3 %>%
  filter(condition == "Visual")

# Now applying ART and RMANOVA to tactile
m_tac_H3 <- art(abs_error ~ type + Error(participant_id), data=clean_tac_H3)
summary(m_tac_H3)
anova(m_tac_H3)

# Now applying ART and RMANOVA to Visual
m_vis_H3 <- art(abs_error ~ type + Error(participant_id), data=clean_vis_H3)
summary(m_vis_H3)
anova(m_vis_H3)

# Performing ART, RMANOVA, and contrast tests on cleaned data for H3 
m_h3 <- art(abs_error ~ condition * type + Error(participant_id), data=clean_pt_H3)
anova(m_h3)
art.con(m_h3, ~condition, adjust = "holm")
art.con(m_h3, ~type, adjust = "holm")
art.con(m_h3, ~condition*type, adjust = "holm")

# Plotting Figure 4 
clean_pt_H3_summary <- clean_pt_H3 %>%
  group_by(condition, type) %>%
  summarise(mean_abs_error = mean(abs_error, na.rm = TRUE))

# Define encoding ranking from Cleveland & McGill's Study
ranking <- c("Position aligned", "Position non-aligned", "Length", "Area", "Curvature", "Shading")
clean_pt_H3_summary$type <- factor(clean_pt_H3_summary$type, levels = ranking)

ggplot(clean_pt_H3_summary, aes(x = condition, y = mean_abs_error, color = type, group = type)) +
  geom_point(size = 4) +
  geom_line() +
  labs(title = 'Graphical Perceptual Hierarchy',
       subtitle = 'Mean Absolute Error Across Perceptual Condition',
       x = 'Condition', 
       y = 'Mean Absolute Error', 
       color = 'Encoding Type') +
  scale_color_manual(values = point_colors) +
  scale_y_continuous(breaks = function(x) {
    breaks <- pretty_breaks(n = 5)(x) # Calculate 'pretty' breaks, adjust n for more/less breaks as needed
    breaks[breaks == floor(breaks)]   # Keep only whole numbers
  }) +
  theme_minimal()
