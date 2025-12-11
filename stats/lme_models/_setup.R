if (!requireNamespace("here", quietly = TRUE)) install.packages("here")
here::i_am("stats/lme_models/_setup.R")  # anchor the repo root

# Prefer sum-to-zero contrasts for ANOVA-style F tests
options(contrasts = c("contr.sum", "contr.poly"))

# Base packages used across scripts (+ the missing ones)
pkgs <- c(
  "dplyr","tidyr","lme4","lmerTest","effectsize","glue","tibble",
  "emmeans","broom","purrr","nloptr"   # added
)
to_install <- setdiff(pkgs, rownames(installed.packages()))
if (length(to_install)) install.packages(to_install, dependencies = TRUE)
invisible(suppressPackageStartupMessages(
  lapply(pkgs, library, character.only = TRUE)
))

# Load raw data (repo-relative)
load(here::here("data", "scr_df.RData"))        # provides scr_df
if (file.exists(here::here("data", "cs_quest_df.RData"))) {
  load(here::here("data", "cs_quest_df.RData")) # provides cs_quest_df
}
if (file.exists(here::here("data", "tus_quest_df.RData"))) {
  load(here::here("data", "tus_quest_df.RData")) # provides tus_quest_df
}

# Build derived LME datasets and load helpers
source(here::here("stats","lme_models","pipeline","prep_lme_scr_dfs.R"))
source(here::here("stats","lme_models","pipeline","run_lmer_test.R"))
