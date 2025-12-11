## =========================
## Experiment I vs. II: sham (amygdala) vs sham (hippocampus)
## =========================

if (!requireNamespace("here", quietly = TRUE)) install.packages("here")
source(here::here("stats","lme_models","_setup.R"))

# acquisition: CS
run_lmer_test(
  data_name   = "scr_df_exp_acq_sham_CS",
  formula     = SCR_sqrt ~ CS * EXPERIMENT + (1 + CS | SUBID),
  effect_name = "CS:EXPERIMENT"
)

# acquisition: CS * TRIAL
run_lmer_test(
  data_name   = "scr_df_exp_acq_sham_CS",
  formula     = SCR_sqrt ~ CS * TRIAL * EXPERIMENT + (1 + CS * TRIAL | SUBID),
  effect_name = "CS:TRIAL:EXPERIMENT"
)

# threat retention: RETENT * CS * EXPERIMENT
run_lmer_test(
  data_name   = "scr_df_exp_ret_sham_CS",
  formula     = SCR_sqrt ~ RETENT * CS * EXPERIMENT + (1 + RETENT + CS | SUBID),
  effect_name = "RETENT:CS:EXPERIMENT"
)

# threat retention: CS × EXPERIMENT main effect from same model
run_lmer_test(
  data_name   = "scr_df_exp_ret_sham_CS",
  formula     = SCR_sqrt ~ RETENT * CS * EXPERIMENT + (1 + RETENT + CS | SUBID),
  effect_name = "CS:EXPERIMENT",
  label       = "CS×EXPERIMENT"
)

# extinction: CS * TRIAL * EXPERIMENT
run_lmer_test(
  data_name   = "scr_df_exp_ext_sham_CS",
  formula     = SCR_sqrt ~ CS * TRIAL * EXPERIMENT + (1 + CS * TRIAL | SUBID),
  effect_name = "CS:TRIAL:EXPERIMENT"
)

# recovery following reinstatement: REINST * CS * EXPERIMENT
run_lmer_test(
  data_name   = "scr_df_exp_rei_sham_CS",
  formula     = SCR_sqrt ~ REINST * CS * EXPERIMENT + (1 + REINST + CS | SUBID),
  effect_name = "REINST:CS:EXPERIMENT"
)

# recovery following reinstatement: CS × EXPERIMENT main effect
run_lmer_test(
  data_name   = "scr_df_exp_rei_sham_CS",
  formula     = SCR_sqrt ~ REINST * CS * EXPERIMENT + (1 + REINST + CS | SUBID),
  effect_name = "CS:EXPERIMENT",
  label       = "CS×EXPERIMENT"
)

# re-extinction: CS * TRIAL * EXPERIMENT
run_lmer_test(
  data_name   = "scr_df_exp_reext_sham_CS",
  formula     = SCR_sqrt ~ CS * TRIAL * EXPERIMENT + (1 + CS * TRIAL | SUBID),
  effect_name = "CS:TRIAL:EXPERIMENT"
)
