## =========================
## Experiment I: active vs. sham TUS (hippocampus)
## =========================

if (!requireNamespace("here", quietly = TRUE)) install.packages("here")
source(here::here("stats","lme_models","_setup.R"))

## -------- acquisition: CS * TUS --------
run_lmer_test(
  data_name   = "scr_df_hip_acq_CS_TUS",
  formula     = SCR_sqrt ~ CS * TUS + (1 + CS * TUS | SUBID),
  effect_name = "CS:TUS"
)

## -------- acquisition: CS * TUS * TRIAL --------
run_lmer_test(
  data_name   = "scr_df_hip_acq_CS_TUS",
  formula     = SCR_sqrt ~ CS * TUS * TRIAL + (1 + CS * TUS * TRIAL | SUBID),
  effect_name = "CS:TUS:TRIAL"
)

## -------- threat retention: RETENT * CS * TUS --------
# 3-way interaction
run_lmer_test(
  data_name   = "scr_df_hip_ret_CS_TUS",
  formula     = SCR_sqrt ~ RETENT * CS * TUS + (1 + RETENT + CS * TUS | SUBID),
  effect_name = "RETENT:CS:TUS"
)

# CS * TUS interaction from the same model
run_lmer_test(
  data_name   = "scr_df_hip_ret_CS_TUS",
  formula     = SCR_sqrt ~ RETENT * CS * TUS + (1 + RETENT + CS * TUS | SUBID),
  effect_name = "CS:TUS",
  label       = "CS * TUS interaction effect"
)

## -------- extinction: CS * TUS * TRIAL --------
run_lmer_test(
  data_name   = "scr_df_hip_ext_CS_TUS",
  formula     = SCR_sqrt ~ CS * TUS * TRIAL + (1 + CS * TUS * TRIAL | SUBID),
  effect_name = "CS:TUS:TRIAL"
)

## -------- recovery following reinstatement: REINST * CS * TUS --------
# 3-way interaction
run_lmer_test(
  data_name   = "scr_df_hip_rei_CS_TUS",
  formula     = SCR_sqrt ~ REINST * CS * TUS + (1 + REINST + CS + TUS | SUBID),
  effect_name = "REINST:CS:TUS"
)

# CS main effect from the same model
run_lmer_test(
  data_name   = "scr_df_hip_rei_CS_TUS",
  formula     = SCR_sqrt ~ REINST * CS * TUS + (1 + REINST + CS + TUS | SUBID),
  effect_name = "CS",
  label       = "CS main effect"
)

## -------- re-extinction: CS * TUS * TRIAL --------
run_lmer_test(
  data_name   = "scr_df_hip_reext_CS_TUS",
  formula     = SCR_sqrt ~ CS * TUS * TRIAL + (1 + CS * TUS * TRIAL | SUBID),
  effect_name = "CS:TUS:TRIAL"
)
