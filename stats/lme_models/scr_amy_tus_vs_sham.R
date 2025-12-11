## =========================
## Experiment I: active vs. sham TUS (amygdala)
## =========================

if (!requireNamespace("here", quietly = TRUE)) install.packages("here")
source(here::here("stats","lme_models","_setup.R"))

## -------- acquisition: CS * TUS * TRIAL --------
res_acq_triple <- run_lmer_test(
  data_name   = "scr_df_amy_acq_CS_TUS",
  formula     = SCR_sqrt ~ CS * TUS * TRIAL + (1 + CS * TUS * TRIAL | SUBID),
  effect_name = "CS:TUS:TRIAL"
)

# Emtrends on TRIAL by TUS within CS
trend_results <- emtrends(res_acq_triple$model,
                          pairwise ~ TUS | CS,
                          var = "TRIAL",
                          re_formula = NULL)
trend_results

## -------- acquisition: CS * TUS (TIME: early/mid/late) --------
# early
res_acq_early <- run_lmer_test(
  data_name   = "scr_df_amy_acq_CS_TUS_early",
  formula     = SCR_sqrt_meanTime ~ CS * TUS + (1 + CS | SUBID) + (1 + TUS | SUBID),
  effect_name = "CS:TUS"
)
emm <- emmeans(res_acq_early$model, ~ CS * TUS, re_formula = NULL)
cn  <- contrast(emm, interaction = "revpairwise")
cn

# mid
run_lmer_test(
  data_name   = "scr_df_amy_acq_CS_TUS_mid",
  formula     = SCR_sqrt_meanTime ~ CS * TUS + (1 + CS | SUBID) + (1 + TUS | SUBID),
  effect_name = "CS:TUS"
)

# late
run_lmer_test(
  data_name   = "scr_df_amy_acq_CS_TUS_late",
  formula     = SCR_sqrt_meanTime ~ CS * TUS + (1 + CS | SUBID) + (1 + TUS | SUBID),
  effect_name = "CS:TUS"
)

## -------- threat retention: RETENT * CS * TUS --------
run_lmer_test(
  data_name   = "scr_df_amy_ret_CS_TUS",
  formula     = SCR_sqrt ~ RETENT * CS * TUS + (1 + RETENT + CS + TUS | SUBID),
  effect_name = "CS:TUS"
)

## -------- extinction: CS * TUS * TRIAL --------
res_ext_triple <- run_lmer_test(
  data_name   = "scr_df_amy_ext_CS_TUS",
  formula     = SCR_sqrt ~ CS * TUS * TRIAL + (1 + CS * TUS * TRIAL | SUBID),
  effect_name = "CS:TUS:TRIAL"
)

trend_results <- emtrends(res_ext_triple$model,
                          pairwise ~ TUS | CS,
                          var = "TRIAL",
                          re_formula = NULL)
trend_results

## -------- extinction: CS * TUS (TIME: early) --------
res_ext_time_early <- run_lmer_test(
  data_name   = "scr_df_amy_ext_CS_TUS_early",
  formula     = SCR_sqrt_meanTime ~ CS * TUS + (1 + CS + TUS | SUBID),
  effect_name = "CS:TUS"
)
emm <- emmeans(res_ext_time_early$model, ~ CS * TUS, re_formula = NULL)
cn  <- contrast(emm, interaction = "revpairwise"); cn

## -------- extinction: CS * TUS (TIME: late) --------
res_ext_time_late <- run_lmer_test(
  data_name   = "scr_df_amy_ext_CS_TUS_late",
  formula     = SCR_sqrt_meanTime ~ CS * TUS + (1 + CS + TUS | SUBID),
  effect_name = "CS:TUS"
)
emm <- emmeans(res_ext_time_late$model, ~ CS * TUS, re_formula = NULL)
cn  <- contrast(emm, interaction = "revpairwise"); cn

## -------- recovery following reinstatement: REINST * CS * TUS --------
# interaction REINST:CS (as in your script)
run_lmer_test(
  data_name   = "scr_df_amy_rei_CS_TUS",
  formula     = SCR_sqrt ~ REINST * CS * TUS + (1 + REINST + CS + TUS | SUBID),
  effect_name = "REINST:CS"
)
# CS main effect from same model
run_lmer_test(
  data_name   = "scr_df_amy_rei_CS_TUS",
  formula     = SCR_sqrt ~ REINST * CS * TUS + (1 + REINST + CS + TUS | SUBID),
  effect_name = "CS",
  label       = "CS main effect"
)
