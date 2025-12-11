## ---- stats/learning_models/_setup.R ----

if (!requireNamespace("here", quietly = TRUE)) install.packages("here")
here::i_am("stats/learning_models/_setup.R")  # pins root to the repo that contains this file

# 1) Packages (install on first run if missing)
pkgs <- c(
  "rstan","brms","posterior","tidyverse","dplyr","magrittr","tidyr",
  "ggplot2","gghalves","cowplot","here"
)
to_install <- pkgs[!pkgs %in% rownames(installed.packages())]
if (length(to_install)) install.packages(to_install, dependencies = TRUE)
invisible(lapply(pkgs, library, character.only = TRUE))

# 2) Paths (relative to repo root)
paths <- list(
  root       = here::here(),
  data       = here::here("data"),
  model_fits = here::here("stats","learning_models","model_fits")
)

if (!dir.exists(paths$model_fits)) dir.create(paths$model_fits, recursive = TRUE)

# 3) Load data used by all models
load(file.path(paths$data, "scr_df.RData"))  # provides scr_df

# 4) Helper save/read utilities
save_fit   <- function(obj, name) saveRDS(obj, file.path(paths$model_fits, paste0(name, ".rds")))
read_fit   <- function(name) readRDS(file.path(paths$model_fits, paste0(name, ".rds")))
save_summ  <- function(obj, name) saveRDS(obj, file.path(paths$model_fits, paste0(name, "_summary.rds")))
read_summ  <- function(name) readRDS(file.path(paths$model_fits, paste0(name, "_summary.rds")))
