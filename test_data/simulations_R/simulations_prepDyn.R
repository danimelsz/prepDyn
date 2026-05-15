#!/usr/bin/env Rscript

#############
# PRE-AMBLE #
#############

# Set the working directory 
setwd("/Users/labanfibios/Desktop/Doutorado/Project/B3_PrepDyn/GitHub/test_data/simulations_R/")

# Load required packages
if (!require(ggplot2)) install.packages("ggplot2", dependencies = TRUE)
if (!require(GGally)) install.packages("GGally", dependencies = TRUE)
if (!require(mgcv)) install.packages("mgcv", dependencies = TRUE)
if (!require(viridis)) install.packages("viridis")
if (!require(readxl)) install.packages("readxl", dependencies = TRUE)
if (!require(patchwork)) install.packages("patchwork", dependencies = TRUE)
if (!require(ggrepel)) install.packages("ggrepel", dependencies = TRUE)
if (!require(dplyr)) install.packages("dplyr", dependencies = TRUE)


#############
# LOAD DATA #
#############

# Read the data
df <- read_excel("simulations_complexity.xlsx", sheet = "with80t")

# Inspect the data structure
str(df)

df <- df[1:60, ]

df
#################
# PREPROCESSING #
#################

min(df$prepDyn_CPU_time)
max(df$prepDyn_CPU_time)

# Min and max cost for the worst case scenario
subset_df <- df[df$n_leaves == 80 & df$n_columns == 10000, ]
min(subset_df$prepDyn_CPU_time, na.rm = TRUE)
max(subset_df$prepDyn_CPU_time, na.rm = TRUE)

# Run model
model <- lm(log2(prepDyn_CPU_time) ~ log2(n_leaves) + log2(n_columns) + log2(n_partitions), data = df)
summary(model)

# Figure 4: Time vs Partitions, grouped by (n_leaves, n_columns)
df$group <- interaction(df$n_leaves, df$n_columns, drop = TRUE)
p <- ggplot(df, aes(x = n_partitions, y = prepDyn_CPU_time, color = group)) +
  geom_line() +
  geom_point() +
  labs(title = "",
       x = "\nNo. partitions",
       y = "CPU time (s) for preprocessing (log)\n",
       color = "No. leaves × No. nucleotides") +
  theme_classic() +
  scale_color_viridis_d(option = "D", direction=-1)  # discrete viridis palette
p
ggsave("fig4_simulations_noPartitionsXtimePreprocessing.jpg", p, width = 8, height = 5, dpi = 300, units = "in")


# Plot: Time vs Leaves, grouped by (n_leaves, n_columns)
df$group <- interaction(df$n_columns, df$n_partitions, drop = TRUE)
p <- ggplot(df, aes(x = n_leaves, y = prepDyn_CPU_time, color = group)) +
  geom_line() +
  geom_point() +
  labs(title = "",
       x = "\nNo. leaves",
       y = "CPU time (s) for preprocessing\n",
       color = "No. nucleotides × No. partitions") +
  theme_classic() +
  scale_color_viridis_d(option = "D", direction=-1)  # discrete viridis palette
p
ggsave("simulations_noLeavesXtimePreprocessing.jpg", p, width = 8, height = 5, dpi = 300, units = "in")

# Plot: Time vs Characters, grouped by (n_leaves, n_partitions)
df$group <- interaction(df$n_leaves, df$n_partitions, drop = TRUE)
p <- ggplot(df, aes(x = n_columns, y = prepDyn_CPU_time, color = group)) +
  geom_line() +
  geom_point() +
  labs(title = "",
       x = "\nNo. nucleotides",
       y = "CPU time (s) for preprocessing\n",
       color = "No. leaves × No. partitions") +
  theme_classic() +
  scale_color_viridis_d(option = "D", direction=-1)  # discrete viridis palette
p
ggsave("simulations_noCharactersXtimePreprocessing.jpg", p, width = 8, height = 5, dpi = 300, units = "in")

# Fig S1: Preprocessing: time vs characters and leaves
# Plot A: Time vs Leaves
df$group_a <- interaction(df$n_columns, df$n_partitions, drop = TRUE)
p1 <- ggplot(df, aes(x = n_leaves, y = prepDyn_CPU_time, color = group_a)) +
  geom_line() +
  geom_point() +
  labs(subtitle = "A",
       x = "\nNo. leaves",
       y = "CPU time (s) for preprocessing\n",
       color = "Seq. length × Partitions") +
  theme_classic() +
  scale_color_viridis_d(option = "D", direction = -1)
# Plot B: Time vs Nucleotides
df$group_b <- interaction(df$n_leaves, df$n_partitions, drop = TRUE)
p2 <- ggplot(df, aes(x = n_columns, y = prepDyn_CPU_time, color = group_b)) +
  geom_line() +
  geom_point() +
  labs(subtitle = "B",
       x = "\nNo. nucleotides",
       y = "CPU time (s) for preprocessing\n",
       color = "No. leaves × Partitions") +
  theme_classic() +
  scale_color_viridis_d(option = "D", direction = -1)
# Combine the plots side-by-side
combined_plot <- p1 + p2
# Display the plot
combined_plot
# Save the combined figure
ggsave("FigureS1_Preprocessing.jpg", combined_plot, 
       width = 12, height = 5.5, dpi = 300, units = "in")

sink()

###################################
# PHYLOGENETIC ANALYSES: DO COSTS #
###################################

# -- ALL SATA -- #
min(df$cost)
max(df$cost)

# LINEAR MODELS
# Runtime ~ leaves * characters * partitions 
model1 <- lm(log2(cost) ~ log2(n_leaves) * log2(n_columns) * log2(n_partitions), data = df)
summary(model1)
# Runtime ~ leaves + characters + partitions + leaves:partitions + characters:partitions
model2 <- lm(log2(cost) ~ log2(n_leaves) + log2(n_columns) + log2(n_partitions) + log2(n_leaves):log2(n_partitions) + log2(n_columns):log2(n_partitions), data = df)
summary(model2)
# Runtime ~ leaves + characters + partitions + leaves:partitions
model3 <- lm(log2(cost) ~ log2(n_leaves) + log2(n_columns) + log2(n_partitions) + log2(n_leaves):log2(n_partitions), data = df)
summary(model3)
# Runtime ~ leaves + characters + partitions + characters:partitions
model4 <- lm(log2(cost) ~ log2(n_leaves) + log2(n_columns) + log2(n_partitions) + log2(n_columns):log2(n_partitions), data = df)
summary(model4)
# Runtime ~ leaves + characters + partitions
model5 <- lm(log2(cost) ~ log2(n_leaves) + log2(n_columns) + log2(n_partitions), data = df)
summary(model5)
# Runtime ~ leaves
model_l <- lm(log2(cost) ~ log2(n_leaves), data = df)
summary(model_l)
# Runtime ~ characters
model_c <- lm(log2(cost) ~ log2(n_columns), data = df)
summary(model_c)
# Runtime ~ partitions
model_p <- lm(log2(cost) ~ log2(n_partitions), data = df)
summary(model_p)

# MODEL SELECTION
# AIC of multi-predictor models
AIC(model1, model2, model3, model4, model5)
# AIC of all models
AIC(model1, model2, model3, model4, model5, model_l, model_c, model_p)
BIC(model1, model2, model3, model4, model5, model_l, model_c, model_p)

# Plot: Cost vs Partitions, grouped by (n_leaves, n_columns), all data
df$group <- interaction(df$n_leaves, df$n_columns, drop = TRUE)
p <- ggplot(df, aes(x = n_partitions, y = cost, color = group)) +
  geom_line() +
  geom_point() +
  labs(title = "",
       x = "\nNo. partitions",
       y = "Parsimony score\n",
       color = "No. leaves × No. nucleotides") +
  theme_classic() +
  scale_color_viridis_d(option = "D", direction=-1)  # discrete viridis palette
p
ggsave("simulations_noPartitionsXcostDO.jpg", p, width = 8, height = 5, dpi = 300, units = "in")

# Figure S3
df$group <- interaction(df$n_leaves, df$n_columns, drop = TRUE)
# 1. Calculate successive changes without losing group info
df_plotted <- df %>%
  arrange(group, n_partitions) %>%
  group_by(group) %>%
  mutate(
    # Check if the NEXT point is higher or lower than the CURRENT point
    change_type = case_when(
      lead(cost) > cost ~ "Increase",
      lead(cost) < cost ~ "Decrease",
      lead(cost) == cost ~ "No Change",
      TRUE ~ "Last round"
    )
  ) %>%
  ungroup()
# 2. Plotting: Color by Group, Shape by Change
p <- ggplot(df_plotted, aes(x = n_partitions, y = cost, color = group)) +
  # Lines connect the points within each group
  # We use a slight alpha so overlaps are visible
  geom_line(aes(group = group), alpha = 0.6, linewidth = 0.8) +
  # Points change shape based on the direction of the next step
  geom_point(aes(shape = change_type), size = 3) +
  scale_shape_manual(
    values = c("Increase" = 17,    # Triangle up
               "Decrease" = 25,    # Triangle down (filled)
               "No Change" = 16,   # Standard circle
               "Last round" = 3), # Plus sign for the last point
    name = "Cost difference between current and next round of partitioning"
  ) +
  scale_color_viridis_d(option = "D", direction = -1) +
  labs(
    x = "\nNo. partitions",
    y = "Parsimony score\n",
    color = "Leaves × Nucleotides"
  ) +
  theme_classic() +
  # Place legend at the bottom to give the plot more horizontal room
  theme(legend.position = "bottom", legend.box = "vertical")
p
ggsave("figS3_simulations_noPartitionsXcostDO.jpg", p, width = 8, height = 8, dpi = 300, units = "in")

# 2D plot
grid <- expand.grid(
  n_leaves = median(df$n_leaves),
  n_columns = seq(min(df$n_columns), max(df$n_columns), length=50),
  n_partitions = seq(min(df$n_partitions), max(df$n_partitions), length=50)
)
# Predict CPU time
grid$pred <- predict(model4, newdata=grid)
grid$pred_time <- 2^grid$pred  # back to CPU time
# Contour plot
p=ggplot(grid, aes(x = n_columns, y = n_partitions, z = pred_time)) +
  geom_contour_filled() +
  scale_x_log10() + scale_y_log10() +
  labs(x="\nNo. nucleotides", y="No. partitions\n", fill="Tree cost") +
  theme_minimal()
p
ggsave("countor_simulations_noPartitionsXcostDO.jpg", p, width = 8, height = 5, dpi = 300, units = "in")

# -- SMALLEST DATASET -- #
# Min and max cost for the worst case scenario
subset_df <- df[df$n_leaves == 10 & df$n_columns == 100, ]
min(subset_df$cost, na.rm = TRUE)
max(subset_df$cost, na.rm = TRUE)

# Cost (worst case)
model <- lm(log2(cost) ~ log2(n_partitions), data = subset_df)
summary(model)

# -- LARGEST DATASET -- #
# Min and max cost for the worst case scenario
subset_df <- df[df$n_leaves == 80 & df$n_columns == 10000, ]
min(subset_df$cost, na.rm = TRUE)
max(subset_df$cost, na.rm = TRUE)

# Cost (worst case)
model <- lm(log2(cost) ~ log2(n_partitions), data = subset_df)
summary(model)

# Plot (worst case): Cost vs Partitions, grouped by (n_leaves, n_columns)
p <- ggplot(subset_df, aes(x = n_partitions, y = cost)) +
  geom_point() +
  geom_smooth(
    method = "lm",        # linear trend
    se = TRUE,            # confidence ribbon
    color = "#440154FF"   # line color
  ) +
  labs(
    x = "\nNo. partitions",
    y = "Tree cost\n"
  ) +
  theme_classic()
p
ggsave("fig5A_simulations_noPartitionsXcostDO.jpg", p, width = 8, height = 5, dpi = 300, units = "in")


##################################
# PHYLOENETIC ANALYSES: DO TIME #
##################################

min(df$swap_CPU_time, na.rm=TRUE)
max(df$swap_CPU_time, na.rm=TRUE)

# Min and max time for the worst case scenario
subset_df <- df[df$n_leaves == 80 & df$n_columns == 10000, ]
min(subset_df$swap_CPU_time, na.rm = TRUE)
max(subset_df$swap_CPU_time, na.rm = TRUE)

# LINEAR MODELS
# Runtime ~ leaves * characters * partitions 
model1 <- lm(log2(swap_CPU_time) ~ log2(n_leaves) * log2(n_columns) * log2(n_partitions), data = df)
summary(model1)
# Runtime ~ leaves + characters + partitions + leaves:partitions + characters:partitions
model2 <- lm(log2(swap_CPU_time) ~ log2(n_leaves) + log2(n_columns) + log2(n_partitions) + log2(n_leaves):log2(n_partitions) + log2(n_columns):log2(n_partitions), data = df)
summary(model2)
# Runtime ~ leaves + characters + partitions + leaves:partitions
model3 <- lm(log2(swap_CPU_time) ~ log2(n_leaves) + log2(n_columns) + log2(n_partitions) + log2(n_leaves):log2(n_partitions), data = df)
summary(model3)
# Runtime ~ leaves + characters + partitions + characters:partitions
model4 <- lm(log2(swap_CPU_time) ~ log2(n_leaves) + log2(n_columns) + log2(n_partitions) + log2(n_columns):log2(n_partitions), data = df)
summary(model4)
# Runtime ~ leaves + characters + partitions
model5 <- lm(log2(swap_CPU_time) ~ log2(n_leaves) + log2(n_columns) + log2(n_partitions), data = df)
summary(model5)
# Runtime ~ leaves
model_l <- lm(log2(swap_CPU_time) ~ log2(n_leaves), data = df)
summary(model_l)
# Runtime ~ characters
model_c <- lm(log2(swap_CPU_time) ~ log2(n_columns), data = df)
summary(model_c)
# Runtime ~ partitions
model_p <- lm(log2(swap_CPU_time) ~ log2(n_partitions), data = df)
summary(model_p)

# MODEL SELECTION
# AIC of multi-predictor models
AIC(model1, model2, model3, model4, model5)
# AIC of all models
AIC(model1, model2, model3, model4, model5, model_l, model_c, model_p)
BIC(model1, model2, model3, model4, model5, model_l, model_c, model_p)

# VISUALIZATION
# Plot: time vs Partitions, grouped by (n_leaves, n_columns)
df$group <- interaction(df$n_leaves, df$n_columns, drop = TRUE)
p <- ggplot(df, aes(x = n_partitions, y = swap_CPU_time, color = group)) +
  geom_line() +
  geom_point() +
  labs(title = "",
       x = "\nNo. partitions",
       y = "CPU time (s) for direct optimization\n",
       color = "No. leaves × No. nucleotides") +
  theme_classic() +
  scale_color_viridis_d(option = "D", direction=-1)  # discrete viridis palette
p
ggsave("simulations_noPartitionsXtimeDO.jpg", p, width = 8, height = 5, dpi = 300, units = "in")

# 2D plot
grid <- expand.grid(
  n_leaves = median(df$n_leaves),
  n_columns = seq(min(df$n_columns), max(df$n_columns), length=50),
  n_partitions = seq(min(df$n_partitions), max(df$n_partitions), length=50)
)
# Predict CPU time
grid$pred <- predict(model4, newdata=grid)
grid$pred_time <- 2^grid$pred  # back to CPU time
# Contour plot
p=ggplot(grid, aes(x = n_columns, y = n_partitions, z = pred_time)) +
  geom_contour_filled() +
  scale_x_log10() + scale_y_log10() +
  labs(x="\nNo. nucleotides", y="No. partitions\n", fill="CPU time (s)") +
  theme_minimal()
p
ggsave("simulations_interactionPartitionsNucleotidesXtimeDO.jpg", p, width = 8, height = 5, dpi = 300, units = "in")

# 3D plot
grid <- expand.grid(
  n_leaves = median(df$n_leaves),                # hold leaves constant
  n_columns = seq(min(df$n_columns), max(df$n_columns), length.out = 100),
  n_partitions = seq(min(df$n_partitions), max(df$n_partitions), length.out = 100)
)
grid$pred <- predict(model4, newdata = grid)
grid$CPU_time <- 2^grid$pred
z_matrix <- matrix(grid$CPU_time, nrow=100, ncol=100)
library(plotly)
plot_ly(
  x = seq(min(df$n_columns), max(df$n_columns), length.out=100),
  y = seq(min(df$n_partitions), max(df$n_partitions), length.out=100),
  z = z_matrix,
  type = "surface"
) %>%
  layout(
    scene = list(
      xaxis = list(title="Number of columns", type="log"),
      yaxis = list(title="Number of partitions", type="log"),
      zaxis = list(title="CPU time")
    )
  )


# -- SMALLEST DATASET -- #
# Min and max time for the simplest case scenario
subset_df_small <- df[df$n_leaves == 10 & df$n_columns == 100, ]
min(subset_df_small$swap_CPU_time, na.rm = TRUE)
max(subset_df_small$swap_CPU_time, na.rm = TRUE)
# Runtime ~ leaves * characters * partitions 
model_s <- lm(log2(swap_CPU_time) ~ log2(n_partitions), data = subset_df_small)
summary(model_s)

# -- LARGEST DATASET -- #
# Min and max time for the largest case scenario
subset_df_large <- df[df$n_leaves == 80 & df$n_columns == 10000, ]
min(subset_df_large$swap_CPU_time, na.rm = TRUE)
max(subset_df_large$swap_CPU_time, na.rm = TRUE)
# Runtime ~ leaves * characters * partitions 
model_l <- lm(log2(swap_CPU_time) ~ log2(n_partitions), data = subset_df_large)
summary(model_l)

############
# FIGURE 5 #
############

# Min and max time for the worst case scenario
subset_df <- df[df$n_leaves == 80 & df$n_columns == 10000, ]
min(subset_df$swap_CPU_time, na.rm = TRUE)
max(subset_df$swap_CPU_time, na.rm = TRUE)
# LINEAR MODELS IN WORST CASE
# Runtime ~ leaves * characters * partitions 
model1 <- lm(log2(swap_CPU_time) ~ log2(n_partitions), data = subset_df)
summary(model1)
# Plot worst case: time vs Partitions, grouped by (n_leaves, n_columns)
q <- ggplot(subset_df, aes(x = n_partitions, y = swap_CPU_time)) +
  geom_point() +
  geom_smooth(
    method = "lm",        # linear trend
    se = TRUE,            # confidence ribbon
    color = "#440154FF"   # line color
  ) +
  labs(
    x = "\nNo. partitions",
    y = "CPU time (s) for direct optimization\n"
  ) +
  theme_classic()
q
ggsave("fig5B_simulations_noPartitionsXtimeDO.jpg", q, width = 8, height = 5, dpi = 300, units = "in")

# Plot worst case: time vs Partitions, grouped by (n_leaves, n_columns)
p <- ggplot(subset_df_small, aes(x = n_partitions, y = swap_CPU_time)) +
  geom_line(color = "#440154FF") +
  geom_point() +
  labs(title = "",
       x = "\nNo. partitions",
       y = "CPU time (s) for direct optimization\n",
       color = "No. leaves × No. nucleotides") +
  theme_classic() +
  scale_color_viridis_d(option = "D", direction=-1)  # discrete viridis palette
p
ggsave("simulations_noPartitionsXtimeDO.jpg", p, width = 8, height = 5, dpi = 300, units = "in")


library(patchwork)
# suppose your plots are p1 and p2
combined <- (q| p) + 
  plot_annotation(
    tag_levels = "a",
    theme = theme(
      plot.tag = element_text(face = "italic")  # ← italic
    )
  )
combined
ggsave("figure5.jpg", combined, width = 9, height = 4, dpi = 300)
