if (!requireNamespace("here", quietly = TRUE)) install.packages("here")
source(here::here("stats","learning_models","_setup.R"))

data_acq <- subset(scr_df, PHASE == "acquisition" & TUS == "active" & CS == "threat")

data_acq$CS <- relevel(data_acq$CS, ref = "control")
data_acq$US <- relevel(data_acq$US, ref = "unreinforced")

data_acq <- data_acq %>%
  mutate(SUBID = factor(SUBID, levels = unique(SUBID)))

# Create a new column with NA values
data_acq$n_trials_after_US <- NA

# Loop through each unique SUBID
unique_subjects <- unique(data_acq$SUBID)

for (subid in unique_subjects) {
  
  # Subset data for the current subject
  subj_data <- data_acq[data_acq$SUBID == subid, ]
  
  # Initialize counters and reset conditions for this subject
  counters <- list()
  reset_conditions <- list()
  
  for (i in 1:nrow(subj_data)) {
    
    # Create a unique combination key based on TUS and CS values
    key <- paste(subj_data$TUS[i], subj_data$CS[i], sep = "_")
    
    # If the key doesn't exist in counters, initialize it
    if (!key %in% names(counters)) {
      counters[[key]] <- 0
      reset_conditions[[key]] <- TRUE
    }
    
    # Update the counter for the current key
    if (subj_data$US[i] == "reinforced") {
      counters[[key]] <- 0
      reset_conditions[[key]] <- FALSE
    } else if (reset_conditions[[key]]) {
      counters[[key]] <- 0
    } else {
      counters[[key]] <- counters[[key]] + 1
    }
    
    # Set the value in n_trials_after_US based on the counter for the current key
    subj_data$n_trials_after_US[i] <- counters[[key]]
  }
  
  # Update the original data frame with the computed values for this subject
  data_acq[data_acq$SUBID == subid, "n_trials_after_US"] <- subj_data$n_trials_after_US
}

# Assign block IDs as before
data_acq <- data_acq %>%
  group_by(EXPERIMENT, SUBID) %>%
  mutate(
    n_trials_after_US_block_ID = cumsum(n_trials_after_US == 0 & 
                                          (lag(n_trials_after_US, default = -1) != 0)) + 1
  ) %>%
  ungroup()

# Group by n_trials_after_US and n_trials_after_US_block_ID
data_acq_blockID_mean <- data_acq %>%
  group_by(EXPERIMENT, SUBID, n_trials_after_US, n_trials_after_US_block_ID) %>%
  dplyr::summarise(
    mean_SCR_sqrt = mean(SCR_sqrt, na.rm = TRUE)
  ) %>%
  arrange(SUBID, n_trials_after_US_block_ID) %>% 
  ungroup()

scatter_data <- data_acq_blockID_mean

data_reshaped <- scatter_data %>% 
  group_by(EXPERIMENT, SUBID, n_trials_after_US_block_ID) %>% 
  pivot_wider(., names_from = n_trials_after_US, values_from = mean_SCR_sqrt)

data_reshaped <- data_reshaped %>%
  dplyr::rename(
    mean_SCR_sqrt_0 = `0`,
    mean_SCR_sqrt_1 = `1`,
    mean_SCR_sqrt_2 = `2`
  )

# Calculate Spearman's rank correlation coefficients for each participant
corr_results <- data_reshaped %>%
  group_by(EXPERIMENT, SUBID) %>%
  dplyr::summarize(
    corrcoef_0_1 = cor(mean_SCR_sqrt_0, mean_SCR_sqrt_1, method = "spearman", use = "complete.obs"),
    corrcoef_1_2 = cor(mean_SCR_sqrt_1, mean_SCR_sqrt_2, method = "spearman", use = "complete.obs")
  ) %>%
  ungroup()

# Perform t-tests to compare the correlation coefficients between the two experiments
t_test_0_1 <- t.test(corr_results$corrcoef_0_1 ~ corr_results$EXPERIMENT)
t_test_1_2 <- t.test(corr_results$corrcoef_1_2 ~ corr_results$EXPERIMENT)

t_test_0_1 # CS+US --> CS
t_test_1_2 # CS --> CS

# Compute Cohen's d (pooled SD) for CS+US --> CS effect
n1 <- sum(corr_results$EXPERIMENT == "amygdala")
n2 <- sum(corr_results$EXPERIMENT == "hippocampus")

t_val <- t_test_0_1$statistic[[1]]

d_pooled <- t_val * sqrt(1/n1 + 1/n2)   # Cohen's d (pooled SD version)
d_pooled
