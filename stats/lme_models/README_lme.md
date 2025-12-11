# Linear mixed-effects models (FEARTUS)

This folder contains all linear mixed-effects (LME) analyses for SCR and questionnaire data.

## How the scripts work

Every analysis script in this folder **automatically sources `_setup.R` at the top**.  
This means you can simply open a script (e.g., `scr_amy_sham.R`) and run it — all data loading, contrasts, and helper functions are already taken care of.

## Contents

- `_setup.R`  
  - Anchors the FEARTUS project root via `{here}`  
  - Loads shared data from `data/scr_df.RData` and the pre-split `lme_model_data_list.rds`
  - Sources:
    - `pipeline/prep_lme_scr_dfs.R` (creates the per-model data frames)
    - `pipeline/run_lmer_test.R` (wrapper around `lmer`, `anova`, `effectsize`)

- `scr_amy_sham.R`  
  Amygdala experiment, sham-only.

- `scr_amy_tus_vs_sham.R`  
  Amygdala: active vs sham TUS comparisons.

- `scr_amy_vs_hip_sham.R`  
  Sham-only comparison: amygdala vs hippocampus experiments.

- `scr_amy_vs_hip_tus.R`  
  Active TUS vs sham, including amygdala vs hippocampus interactions.

- `scr_hip_sham.R`  
  Hippocampus experiment, sham-only.

- `scr_hip_tus_vs_sham.R`  
  Hippocampus: active vs sham TUS comparisons.

- `questionnaire_analyses.R`  
  Analyses for CS ratings (`cs_quest_df`) and TUS questionnaires (`tus_quest_df`)

## Phases and factors

The models use `scr_df` with factors such as:

- `CS` (threat vs control), `US` (reinforced vs unreinforced)  
- `PHASE` (acquisition, extinction, re_extinction, retention, recovery)  
- `TUS` (active vs sham)  
- `EXPERIMENT` (amygdala vs hippocampus)

Most scripts work via pre-prepared data frames stored in `data/lme_model_data_list.rds` and accessed with `get_df()` inside `run_lmer_test.R`.
