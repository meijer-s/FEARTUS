# Reinforcement learning & SCR autocorrelation models (FEARTUS)

This folder contains all reinforcement‐learning (RL) model analyses and SCR autocorrelation analyses performed on trial-level SCR data.

## How the scripts work

Every analysis script in this folder **automatically sources `_setup.R` at the top**.  
This means you can simply open a script (e.g., `RWmodel_LR_TUS_acq.R`) and run it — all package loading, path setup, data loading, and helper functions are already taken care of.

`_setup.R` also ensures that the `model_fits/` directory exists, so all model outputs are saved in a stable location.

## Contents

### `_setup.R`
- Anchors the FEARTUS project root via `{here}`
- Loads the SCR data (`data/scr_df.RData`)
- Creates the `model_fits/` directory if missing
- Provides helper functions:
  - `save_fit()`, `read_fit()`
  - `save_summ()`, `read_summ()`

### Reinforcement-learning models

- `RWmodel_LR_TUS_acq.R`  
  RW learning model for acquisition.

- `RWmodel_LR_TUS_ext.R`  
  RW learning model for extinction.

- `RWmodel_LR_TUS_acq_ext.R`  
  Joint RW learning model across acquisition and extinction.

### SCR autocorrelation

- `SCR_autocorrelation.R`  
  Computes trial-wise autocorrelation indices on SCR data.

## Outputs

All models save their results to:
stats/learning_models/model_fits/

Each script writes two files per model:

- `<model>.rds` — fitted model  
- `<model>_summary.rds` — model summary used for reporting

Both are created automatically by the helper functions in `_setup.R`.
