# Anchor the repo root
if (!requireNamespace("here", quietly = TRUE)) install.packages("here")
here::i_am("stats/permutation_tests/palm_code/_setup.R")

# Packages
pkgs <- c("dplyr","tidyr","purrr","stringr","readr")
to_install <- setdiff(pkgs, rownames(installed.packages()))
if (length(to_install)) install.packages(to_install, dependencies = TRUE)
invisible(lapply(pkgs, library, character.only = TRUE))

# Raw SCR (provides scr_df)
load(here::here("data","scr_df.RData"))

# Paths
paths <- list(
  pipeline = here::here("stats","permutation_tests","palm_code","pipeline"),
  out_root = here::here("stats","permutation_tests","palm_data")
)
if (!dir.exists(paths$pipeline)) dir.create(paths$pipeline, recursive = TRUE)
if (!dir.exists(paths$out_root)) dir.create(paths$out_root, recursive = TRUE)

# Prep function
source(file.path(paths$pipeline,"prep_palm_data.R"))

## -------------------------------
## Build all three output folders
## -------------------------------
cfg <- list(
  list(subdir = "acq",  phase = "acquisition",                       us = "unreinforced"),
  list(subdir = "ext",  phase = c("extinction","retention"),         us = "unreinforced"),
  list(subdir = "reext",phase = c("re_extinction","recovery"),       us = "unreinforced")
)

palm_lists <- purrr::map(cfg, ~{
  prepare_palm_data(
    scr_df        = scr_df,
    PHASE_filter  = .x$phase,     # can be a character vector
    US_filter     = .x$us,
    out_root      = paths$out_root,
    out_subdir    = .x$subdir,    # writes to acq/, ext/, or reext/
    overwrite     = FALSE
  )
})

# Named list by subdir for convenience:
palm_data <- setNames(palm_lists, purrr::map_chr(cfg, "subdir"))
invisible(palm_data)

# ---- Loader: bring phase-specific PALM matrices into the workspace ----
palm_load <- function(which = c("acq","ext","reext"), into = .GlobalEnv) {
  which <- match.arg(which)
  dir_phase <- file.path(paths$out_root, which)
  rds <- file.path(dir_phase, sprintf("palm_%s_list.rds", which))
  if (!file.exists(rds)) {
    stop("No PALM list at: ", rds,
         "\nRun prepare_palm_data() via _setup or set overwrite=TRUE to rebuild.")
  }
  lst <- readRDS(rds)
  
  # name them exactly like your downstream code expects
  names(lst) <- paste0(names(lst), "_df_wide")
  
  # make available in the chosen environment (default: global)
  list2env(lst, envir = into)
  invisible(lst)
}

