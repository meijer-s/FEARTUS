## =========================
## Experiment I vs. II: CS x TUS × EXPERIMENT
## =========================

if (!requireNamespace("here", quietly = TRUE)) install.packages("here")
source(here::here("stats","lme_models","_setup.R"))

## -------- acquisition: CS * TUS * TRIAL * EXPERIMENT --------
res_acq_4way <- run_lmer_test(
  data_name   = "scr_df_exp_acq_CS_TUS",
  formula     = SCR_sqrt ~ CS * TUS * TRIAL * EXPERIMENT + (1 + CS + TUS + TRIAL | SUBID),
  effect_name = "CS:TUS:TRIAL:EXPERIMENT"
)

## -------- acquisition (TIME: early) : CS * TUS * EXPERIMENT --------
res_acq_time_early <- run_lmer_test(
  data_name   = "scr_df_exp_acq_CS_TUS_early",
  formula     = SCR_sqrt_meanTime ~ CS * TUS * EXPERIMENT + (1 + CS + TUS | SUBID),
  effect_name = "CS:TUS:EXPERIMENT"
)
# emmeans & contrast
emm <- emmeans(res_acq_time_early$model, ~ CS * TUS * EXPERIMENT, re_formula = NULL)
cn  <- contrast(emm, interaction = "revpairwise"); cn
aov_tab <- anova(res_acq_time_early$model)
effectsize::eta_squared(aov_tab, partial = TRUE)

## -------- acquisition (TIME: mid) : CS * TUS * EXPERIMENT --------
run_lmer_test(
  data_name   = "scr_df_exp_acq_CS_TUS_mid",
  formula     = SCR_sqrt_meanTime ~ CS * TUS * EXPERIMENT + (1 + CS + TUS | SUBID),
  effect_name = "CS:TUS:EXPERIMENT"
)

## -------- acquisition (TIME: late) : CS * TUS * EXPERIMENT --------
run_lmer_test(
  data_name   = "scr_df_exp_acq_CS_TUS_late",
  formula     = SCR_sqrt_meanTime ~ CS * TUS * EXPERIMENT + (1 + CS + TUS | SUBID),
  effect_name = "CS:TUS:EXPERIMENT"
)

## -------- extinction (TIME: early) : CS * TUS * EXPERIMENT --------
res_ext_time_early <- run_lmer_test(
  data_name   = "scr_df_exp_ext_CS_TUS_early",
  formula     = SCR_sqrt_meanTime ~ CS * TUS * EXPERIMENT + (1 + CS + TUS | SUBID),
  effect_name = "CS:TUS:EXPERIMENT"
)
emm <- emmeans(res_ext_time_early$model, ~ CS * TUS * EXPERIMENT, re_formula = NULL)
cn  <- contrast(emm, interaction = "revpairwise"); cn
aov_tab <- anova(res_ext_time_early$model)
effectsize::eta_squared(aov_tab, partial = TRUE)

## -------- extinction (TIME: late) : CS * TUS * EXPERIMENT --------
run_lmer_test(
  data_name   = "scr_df_exp_ext_CS_TUS_late",
  formula     = SCR_sqrt_meanTime ~ CS * TUS * EXPERIMENT + (1 + CS + TUS | SUBID),
  effect_name = "CS:TUS:EXPERIMENT"
)

## -------- recovery following reinstatement: REINST * CS * TUS * EXPERIMENT --------
run_lmer_test(
  data_name   = "scr_df_exp_rei_CS_TUS",
  formula     = SCR_sqrt ~ REINST * CS * TUS * EXPERIMENT + (1 + REINST + CS + TUS | SUBID),
  effect_name = "REINST:CS:TUS:EXPERIMENT"
)

## -------- re-extinction (TIME: early) : CS * TUS * EXPERIMENT --------
run_lmer_test(
  data_name   = "scr_df_exp_reext_CS_TUS_early",
  formula     = SCR_sqrt_meanTime ~ CS * TUS * EXPERIMENT + (1 + CS + TUS | SUBID),
  effect_name = "CS:TUS:EXPERIMENT"
)

## -------- re-extinction (TIME: late) : CS * TUS * EXPERIMENT --------
run_lmer_test(
  data_name   = "scr_df_exp_reext_CS_TUS_late",
  formula     = SCR_sqrt_meanTime ~ CS * TUS * EXPERIMENT + (1 + CS + TUS | SUBID),
  effect_name = "CS:TUS:EXPERIMENT"
)
