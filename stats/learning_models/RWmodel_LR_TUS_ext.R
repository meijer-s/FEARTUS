if (!requireNamespace("here", quietly = TRUE)) install.packages("here")
source(here::here("stats","learning_models","_setup.R"))

scr_ext <- scr_df %>%
  filter(PHASE %in% c("retention", "extinction") & TUS == "active") %>%
  mutate(
    US = ifelse(US == "reinforced", 1, ifelse(US == "unreinforced", 0, NA)),
    CUE = ifelse(EXPERIMENT == "amygdala" & CS == "control", 1, 
                 ifelse(EXPERIMENT == "amygdala" & CS == "threat", 2, 
                        ifelse(EXPERIMENT == "hippocampus" & CS == "control", 1,
                               ifelse(EXPERIMENT == "hippocampus" & CS == "threat", 2,
                                      NA))))
  ) %>%
  group_by(EXPERIMENT, SUBID) %>%
  mutate(TRIAL = row_number()) %>%
  mutate(SUBID = factor(SUBID, levels = unique(SUBID))) %>%
  ungroup()

# Define data (replace these with actual values)
N_SUB <-    as.numeric(length(unique(scr_ext$SUBID)))
N_TRIAL <-  as.numeric(length(unique(scr_ext$TRIAL)))
Tsubj <-    rep(N_TRIAL, N_SUB)

# SCR
scr_wide <- scr_ext %>%
  arrange(SUBID, BLOCK, TRIAL) %>%
  group_by(SUBID) %>% 
  mutate(row_id = row_number()) %>%
  ungroup() %>%
  select(row_id, SUBID, SCR_sqrt) %>%
  spread(key = SUBID, value = SCR_sqrt) %>%
  select(-(row_id))

# US
us_wide <- scr_ext %>%
  arrange(SUBID, BLOCK, TRIAL) %>%
  group_by(SUBID) %>% 
  mutate(row_id = row_number()) %>%
  ungroup() %>%
  select(row_id, SUBID, US) %>%
  spread(key = SUBID, value = US) %>%
  select(-(row_id))

# CS
cue_wide <- scr_ext %>%
  arrange(SUBID, BLOCK, TRIAL) %>%
  group_by(SUBID) %>% 
  mutate(row_id = row_number()) %>%
  ungroup() %>%
  select(row_id, SUBID, CUE) %>%
  spread(key = SUBID, value = CUE) %>%
  select(-(row_id))

fit_RW_TUS_acq <- read_fit("fit_RW_TUS_acq")

predicted_ev <- rstan::extract(fit_RW_TUS_acq, 
                                pars = "EV_trial", 
                                permute = TRUE)$EV_trial

predicted_ev <- apply(predicted_ev, c(2, 3),
                       mean, 
                       na.rm = TRUE) %>% 
  data.frame()

predicted_ev <- predicted_ev %>%
  pivot_longer(cols = everything(), names_to = "COLID", values_to = "EV_trial") %>%
  arrange(COLID) %>%
  select(-c(COLID))

predicted_scr <- rstan::extract(fit_RW_TUS_acq,
                                pars = "SCR_sim",
                                permute = TRUE)$SCR_sim

predicted_scr <- apply(predicted_scr, c(2, 3),
                       mean,
                       na.rm = TRUE) %>%
  data.frame()

predicted_scr <- predicted_scr %>%
  pivot_longer(cols = everything(), names_to = "COLID", values_to = "SCR_pred") %>%
  arrange(COLID) %>%
  select(-c(COLID))

scr_df_acq <- scr_df %>%
  mutate(SUBID = factor(SUBID, levels = unique(SUBID)))

scr_df_acq <- scr_df_acq %>%
  filter(PHASE == "acquisition" & TUS == "active") %>%
  arrange(SUBID)

data_RW_TUS_acq <- readRDS(here::here("data", "data_RW_TUS_acq.rds"))

observed_scr <- data_RW_TUS_acq$SCR

observed_scr <- observed_scr %>%
  pivot_longer(cols = everything(), 
               names_to = "SUBID", 
               values_to = "SCR_obs") %>% 
  arrange(SUBID) %>%
  select(-c(SUBID))

EV_pred <- cbind(scr_df_acq, observed_scr, predicted_ev)

EV_pred_model_input <- EV_pred %>%
  filter(RETENT == "pre", US == "unreinforced") %>%
  group_by(EXPERIMENT, SUBID, CS) %>%
  slice_tail(n = 1) %>%   # <-- keeps only the last row per group
  ungroup()

EV_pred_model_input <- EV_pred_model_input %>%
  mutate(
    CUE = ifelse(EXPERIMENT == "amygdala" & CS == "control", 1, 
                 ifelse(EXPERIMENT == "amygdala" & CS == "threat", 2, 
                        ifelse(EXPERIMENT == "hippocampus" & CS == "control", 1,
                               ifelse(EXPERIMENT == "hippocampus" & CS == "threat", 2,
                                      NA))))
  )

ev_pred_threat <- EV_pred_model_input %>%
  filter(CS == "threat") %>%
  select(SUBID, EV_trial) %>%
  spread(key = SUBID, value = EV_trial)

ev_pred_control <- EV_pred_model_input %>%
  filter(CS == "control") %>%
  select(SUBID, EV_trial) %>%
  spread(key = SUBID, value = EV_trial)

# Convert to vectors
SCR_safety_initEV <- as.numeric(ev_pred_control[1, ])
SCR_threat_initEV <- as.numeric(ev_pred_threat[1, ])

# Create data list for Stan
data_RW_TUS_ext <- list(
  
  N = N_SUB,
  T = N_TRIAL,
  Tsubj = Tsubj,
  CUE = cue_wide,
  US = us_wide,
  SCR = scr_wide,
  SCR_safety_initEV = SCR_safety_initEV,
  SCR_threat_initEV = SCR_threat_initEV
  
)

model_RW_TUS_ext <- "
data {
  
  int<lower=1> N;                     // Number of subjects
  int<lower=1> T;                     // Maximum number of trials per subject
  int<lower=1, upper=T> Tsubj[N];     // Number of trials for each subject
  int<lower=1, upper=2> CUE[T, N];    // Stimulus type
  int<lower=0, upper=1> US[T, N];     // Observed binary outcomes
  real<lower=0> SCR[T, N];            // Continuous SCR scores
  real<lower=0, upper=1> SCR_safety_initEV[N];
  real<lower=0, upper=1> SCR_threat_initEV[N];
  
}

transformed data {

  // Initialize expected values for both cues (control = 1, threat = 2)
  vector<lower=0, upper=1>[2] initEV[N];  // Initial expected values for both cues for each subject
  
  // Loop over each subject to assign their specific SCR_pred values as initial EVs
  for (i in 1:N) {
    initEV[i, 1] = SCR_safety_initEV[i];  // EV_pred for control cue (CUE = 1)
    initEV[i, 2] = SCR_threat_initEV[i];  // EV_pred for threat cue (CUE = 2)
  }
  
}

parameters {
  
  // Population-level parameters
  vector[4] mu_p;                      // Group-level means of parameters (hyper-prior)
  vector<lower=0>[4] error_p;          // Group-level standard deviations (hyper-prior)
  
  // Subject-level parameters (raw for non-centered parameterization)
  vector[N] LR_pr;                     // Learning rate (raw)
  vector[N] intercept_pr;              // Intercept (raw)
  vector[N] slope_pr;                  // Slope (raw)
  vector[N] error_pr;                  // Noise parameter (raw)
  
}

transformed parameters {
  
  // Subject-level parameters
  vector<lower=0,upper=1>[N] LR;       // Learning rate per subject [0, 1]
  vector[N] intercept;                 // Intercept per subject
  vector[N] slope;                     // Slope per subject
  vector<lower=0>[N] error;            // Noise per subject

  // Transform raw parameters to actual values
  LR = Phi_approx(mu_p[1] + error_p[1] * LR_pr);
  intercept = mu_p[2] + error_p[2] * intercept_pr;
  slope  = mu_p[3] + error_p[3] * slope_pr;
  error = exp(mu_p[4] + error_p[4] * error_pr);
  
}

model {

  // Priors for hyperparameters
  mu_p  ~ normal(0, 1); 
  error_p ~ cauchy(0, 1);  
  
  // Priors for individual-level parameters (non-centered)
  LR_pr ~ normal(0, 1);
  intercept_pr ~ normal(0, 1);
  slope_pr  ~ normal(0, 1);
  error_pr ~ cauchy(0, 1);

  // Loop over subjects and trials
  for (i in 1:N) {
    
    vector[2] EV = initEV[i];  // Initialize expected values for both cues for each subject
    real PE;                   // Prediction error

    for (t in 1:(Tsubj[i])) {
      
      if (US[t, i] == 0) {
        // Likelihood: observed score depends on EV and noise
        SCR[t, i] ~ normal(intercept[i] + slope[i] * EV[CUE[t, i]], error[i]);
      }
      
      // Calculate prediction error 
      PE = US[t, i] - EV[CUE[t, i]];
      
      EV[CUE[t, i]] = EV[CUE[t, i]] + LR[i] * PE;
      
    }
    
  }
  
}

generated quantities {

  real log_lik[N];      // For log-likelihood calculation
  
  real SCR_sim[T, N];   // Simulated SCR data for posterior predictive checks
  
  real PE_trial[T, N];  // Stores PE for each trial and individual
  real EV_trial[T, N];  // Stores EV for each trial and individual

  // Local section to save time and space
  { 
    
    for (i in 1:N) {
      
      vector[2] EV = initEV[i];  // Initialize expected values for both cues for each subject
      real PE;

      // Initialize values
      EV = initEV[i];
      log_lik[i] = 0;

      for (t in 1:(Tsubj[i])) {
      
        // Compute log likelihood for observed SCR data, update only for US == 0 trials
        if (US[t, i] == 0) {
            log_lik[i] = log_lik[i] + normal_lpdf(SCR[t, i] | intercept[i] + slope[i] * EV[CUE[t, i]], error[i]);
        }
        
        // Simulate SCR scores for posterior predictive checks
        SCR_sim[t, i] = normal_rng(intercept[i] + slope[i] * EV[CUE[t, i]], error[i]);
      
        // Calculate prediction error 
        PE = US[t, i] - EV[CUE[t, i]];
        
        // Update expected values based on learning rate and prediction error
        EV[CUE[t, i]] = EV[CUE[t, i]] + LR[i] * PE;
        
        // Store trial-level PE
        PE_trial[t, i] = PE;
        // Store trial-level EV
        EV_trial[t, i] = EV[CUE[t, i]];
        
      }
      
    }
    
  }
  
}
"

fit_RW_TUS_ext <- stan(
  model_code = model_RW_TUS_ext,
  data = data_RW_TUS_ext,
  iter = 2000,
  warmup = 200,
  chains = 4,
  cores = 4,
  seed = 123
)

# Save the raw model fit
save_fit(fit_RW_TUS_ext, "fit_RW_TUS_ext")
# Load raw model fit
fit_RW_TUS_ext <- read_fit("fit_RW_TUS_ext")

# Compute summary fit
summary_fit <- summary(fit_RW_TUS_ext, pars = c("LR", "intercept", "slope", "error"))
# Save summary fit
save_summ(summary_fit, "fit_RW_TUS_ext")
# Load summary fit
summary_fit <- read_summ("fit_RW_TUS_ext")

# Extract the Rhat values
rhat_values <- summary_fit$summary[, "Rhat"]
# Identify parameters with Rhat >= 1.1
non_converged <- rhat_values[rhat_values >= 1.1]
# Print summary of Rhat
cat("Number of parameters with Rhat >= 1.1:", length(non_converged), "\n")
if (length(non_converged) > 0) {
  cat("Parameters with Rhat >= 1.1:\n")
  print(non_converged)
} else {
  cat("All parameters converged (Rhat < 1.1).\n")
}

# Extract the means for the parameters and ensure they are numeric
LR_values <- as.numeric(summary_fit$summary[grep("LR", rownames(summary_fit$summary)), "mean"])

params_df <- data.frame(
  Subject = rep(1:50, times = 1),
  Experiment = rep(c("Amygdala", "Hippocampus"), each = 25),
  LR = LR_values[1:50]
)

# Independent samples t-test
t_test_LR <- t.test(LR ~ Experiment, data = params_df, var.equal = TRUE)

# Print the results
print(t_test_LR)

# Plot LR values (amygdala-TUS vs. hippocampus-TUS)

# Convert Experiment to a numeric factor (1 for Amygdala, 2 for Hippocampus)
params_df$Experiment <- as.numeric(factor(params_df$Experiment, levels = c("Amygdala", "Hippocampus")))

# Mutate to replace 2 with 1.5
params_df <- params_df %>%
  mutate(Experiment = ifelse(Experiment == 2, 1.5, Experiment))

# Create a jittered Experiment variable for plotting
set.seed(321)
params_df$Experiment_jitter <- jitter(params_df$Experiment, amount = 0.15)

# Create summary data for LR (mean and standard error)
summary_data_LR <- params_df %>%
  group_by(Experiment) %>%
  dplyr::summarise(
    mean_LR = mean(LR, na.rm = TRUE),
    se_LR = sd(LR, na.rm = TRUE) / sqrt(n())
  )

summary_data_LR$Experiment <- as.numeric(summary_data_LR$Experiment, 
                                         levels = c("Amygdala", "Hippocampus"), 
                                         labels = c(1, 1.5))

# Jitter the Experiment variable for the summary data
summary_data_LR$Experiment_jitter <- jitter(summary_data_LR$Experiment, amount = 0.15)

# Colors for the experiments
amy_active_color = "#1F78B4"
hip_active_color = "#996633"

# Boxplot and summary plot
boxplot_LR_extinction <- ggplot(data = params_df, aes(x = Experiment_jitter, y = LR)) +
  
  # Add lines for individual subjects
  geom_line(aes(group = Subject), color = 'lightgray', alpha = .3) +
  
  # Add points for individual subject LR values
  geom_point(
    data = params_df, 
    aes(x = Experiment_jitter), 
    shape = 21, 
    fill = "white", 
    color = "white", 
    size = 3
  ) +
  
  # Add colored points for each Experiment
  geom_point(
    data = params_df %>% filter(Experiment == 1), 
    aes(x = Experiment_jitter), 
    shape = 22, 
    fill = amy_active_color, 
    color = amy_active_color, 
    size = 3,
    alpha = .5
  ) +
  geom_point(
    data = params_df %>% filter(Experiment == 1.5), 
    aes(x = Experiment_jitter), 
    shape = 21, 
    fill = hip_active_color, 
    color = hip_active_color, 
    size = 3,
    alpha = .5
  ) +
  
  # Add summary points (mean LR)
  geom_point(
    data = summary_data_LR, 
    aes(x = Experiment, y = mean_LR), 
    colour = "black", 
    size = 3, 
    shape = 18, 
    position = position_nudge(x = 0, y = 0)
  ) +
  
  # Add error bars (SE for LR)
  geom_errorbar(
    data = summary_data_LR, 
    aes(x = Experiment, y = mean_LR, ymin = mean_LR - se_LR, ymax = mean_LR + se_LR), 
    width = 0.15, 
    linewidth = 1, 
    position = position_nudge(x = 0, y = 0)
  ) +
  
  # Add dashed line for summary trend
  geom_line(
    data = summary_data_LR, 
    aes(x = Experiment, y = mean_LR), 
    color = 'black', 
    size = .5, 
    linetype = "dashed"
  ) +
  
  # Set the x and y axis scale
  scale_x_continuous(
    breaks = c(1, 1.5),
    labels = c("Amygdala", "Hippocampus")
  ) +
  scale_y_continuous(
    limits = c(0, 1), 
    breaks = c(0, 0.25, 0.5, 0.75, 1.0),
    labels = c("0", "0.25", "0.50", "0.75", "1.00"),
    expand = c(0, 0)
  ) +
  
  # Add violins and boxplots
  geom_half_violin(
    data = params_df %>% filter(Experiment == 1), 
    aes(x = Experiment, y = LR, group = as.factor(Experiment)), 
    position = position_nudge(x = -.25), 
    side = "l", 
    fill = amy_active_color, 
    alpha = .3, 
    color = amy_active_color, 
    trim = TRUE
  ) +
  geom_half_violin(
    data = params_df %>% filter(Experiment == 1.5), 
    aes(x = Experiment, y = LR, group = as.factor(Experiment)), 
    position = position_nudge(x = .25), 
    side = "r", 
    fill = hip_active_color, 
    alpha = .3, 
    color = hip_active_color, 
    trim = TRUE
  ) +
  
  # Add boxplots
  geom_boxplot(
    data = params_df %>% filter(Experiment == 1),
    aes(x = Experiment, y = LR, group = as.factor(Experiment)), 
    position = position_nudge(x = -.25),
    fill = "white", 
    width = .1,
    outlier.shape = 22,
    outlier.colour = 'lightgray'
  ) +
  geom_boxplot(
    data = params_df %>% filter(Experiment == 1.5),
    aes(x = Experiment, y = LR, group = as.factor(Experiment)), 
    position = position_nudge(x = .25),
    fill = "white", 
    width = .1,
    outlier.shape = 21,
    outlier.colour = 'lightgray'
  ) +
  
  # Set theme and axis labels
  theme_classic() +
  xlab("") + 
  ylab(expression(bold("Learning rate") * phantom(" ") * bold(alpha))) +
  theme(
    plot.title = element_text(size = 18, face = "bold", colour = "black", vjust = 1, hjust = .5),   
    axis.title.y = element_text(size = 14, face ="bold", colour = "black", lineheight = 1.3),
    axis.text.x = element_blank(),
    axis.ticks.x = element_blank(),
    axis.text.y = element_text(size=14, colour= "black", hjust = .5),
    axis.line.x = element_blank(), axis.title.x = element_blank())

# Print the LR plot
print(boxplot_LR_extinction)
