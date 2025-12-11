## =========================
## Experiment I : sham (hippocampus)
## =========================

if (!requireNamespace("here", quietly = TRUE)) install.packages("here")
source(here::here("stats","lme_models","_setup.R"))

# acquisition: CS
run_lmer_test(
  data_name = "scr_df_hip_acq_sham_CS",
  formula   = SCR_sqrt ~ CS + (1 + CS | SUBID),
  effect_name = "CS"
)

# acquisition: US
run_lmer_test(
  data_name = "scr_df_hip_acq_sham_US",
  formula   = SCR_sqrt ~ US + (1 + US | SUBID),
  effect_name = "US"
)

# acquisition: CS * TRIAL
run_lmer_test(
  data_name = "scr_df_hip_acq_sham_CS",
  formula   = SCR_sqrt ~ CS * TRIAL + (1 + CS + TRIAL | SUBID),
  effect_name = "CS:TRIAL"
)

# acquisition: CS * TIME (early/mid/late)
run_lmer_test(
  data_name = "scr_df_hip_acq_sham_CS_early",
  formula   = SCR_sqrt_meanTime ~ CS + (1 | SUBID),
  effect_name = "CS"
)
run_lmer_test(
  data_name = "scr_df_hip_acq_sham_CS_mid",
  formula   = SCR_sqrt_meanTime ~ CS + (1 | SUBID),
  effect_name = "CS"
)
run_lmer_test(
  data_name = "scr_df_hip_acq_sham_CS_late",
  formula   = SCR_sqrt_meanTime ~ CS + (1 | SUBID),
  effect_name = "CS"
)

# threat retention: RETENT * CS
run_lmer_test(
  data_name = "scr_df_hip_ret_sham_CS",
  formula   = SCR_sqrt ~ RETENT * CS + (1 + RETENT + CS | SUBID),
  effect_name = "RETENT:CS"
)
# CS main effect from same model
run_lmer_test(
  data_name = "scr_df_hip_ret_sham_CS",
  formula   = SCR_sqrt ~ RETENT * CS + (1 + RETENT + CS | SUBID),
  effect_name = "CS",
  label = "CS main effect"
)

# extinction: CS * TRIAL
run_lmer_test(
  data_name = "scr_df_hip_ext_sham_CS",
  formula   = SCR_sqrt ~ CS * TRIAL + (1 + CS * TRIAL | SUBID),
  effect_name = "CS:TRIAL"
)

# extinction: CS * TIME (early/late)
run_lmer_test(
  data_name = "scr_df_hip_ext_sham_CS_early",
  formula   = SCR_sqrt_meanTime ~ CS + (1 | SUBID),
  effect_name = "CS"
)
run_lmer_test(
  data_name = "scr_df_hip_ext_sham_CS_late",
  formula   = SCR_sqrt_meanTime ~ CS + (1 | SUBID),
  effect_name = "CS"
)

# recovery following reinstatement: REINST * CS
run_lmer_test(
  data_name = "scr_df_hip_rei_sham_CS",
  formula   = SCR_sqrt ~ REINST * CS + (1 + REINST + CS | SUBID),
  effect_name = "REINST:CS"
)

# CS main effect from same model
run_lmer_test(
  data_name = "scr_df_hip_rei_sham_CS",
  formula   = SCR_sqrt ~ REINST * CS + (1 + REINST + CS | SUBID),
  effect_name = "CS",
  label = "CS main effect"
)

# re-extinction: CS * TRIAL
run_lmer_test(
  data_name = "scr_df_hip_reext_sham_CS",
  formula   = SCR_sqrt ~ CS * TRIAL + (1 + CS * TRIAL | SUBID),
  effect_name = "CS:TRIAL"
)
