prepare_palm_data <- function(scr_df,
                              PHASE_filter,
                              US_filter = "unreinforced",
                              out_root,
                              out_subdir = NULL,
                              overwrite = FALSE) {
  stopifnot(is.data.frame(scr_df), dir.exists(out_root))
  
  # choose subfolder name if not provided
  if (is.null(out_subdir)) {
    # heuristic mapping
    if (length(PHASE_filter) == 1 && PHASE_filter == "acquisition") {
      out_subdir <- "acq"
    } else if (all(PHASE_filter %in% c("extinction","retention"))) {
      out_subdir <- "ext"
    } else if (all(PHASE_filter %in% c("re_extinction","recovery"))) {
      out_subdir <- "reext"
    } else {
      out_subdir <- paste0("custom_", paste(PHASE_filter, collapse = "-"))
    }
  }
  
  out_dir <- file.path(out_root, out_subdir)
  if (!dir.exists(out_dir)) dir.create(out_dir, recursive = TRUE)
  
  # Single combined list (for quick loading)
  list_rds <- file.path(out_dir, sprintf("palm_%s_list.rds", out_subdir))
  if (file.exists(list_rds) && !overwrite) {
    return(readRDS(list_rds))
  }
  
  suppressPackageStartupMessages({
    requireNamespace("dplyr"); requireNamespace("tidyr")
  })
  library(dplyr); library(tidyr)
  
  # ------------ Filter & trial handling ------------
  df <- scr_df %>%
    dplyr::filter(PHASE %in% PHASE_filter, US == !!US_filter)
  
  # Acquisition-only trial fix (double control trials)
  if (length(PHASE_filter) == 1 && PHASE_filter == "acquisition") {
    df <- df %>%
      mutate(
        TRIAL = ifelse(CS == "control", TRIAL / 2, TRIAL),
        TRIAL = as.numeric(TRIAL),
        TRIAL = ifelse(TRIAL != floor(TRIAL), TRIAL + 0.5, TRIAL)
      )
  }
  
  # Mean per EXPERIMENT × SUBID × TRIAL × TUS × CS
  SUBID_difference <- df %>%
    group_by(EXPERIMENT, SUBID, TRIAL, TUS, CS) %>%
    summarise(mean_SCR_sqrt = mean(SCR_sqrt, na.rm = TRUE), .groups = "drop")
  
  # Helper to slice and widen into subjects×trials matrix
  make_wide <- function(experiment, tus, cs) {
    SUBID_difference %>%
      filter(EXPERIMENT == experiment, TUS == tus, CS == cs) %>%
      pivot_wider(
        names_from = TRIAL, values_from = mean_SCR_sqrt,
        names_prefix = "TRIAL_"
      ) %>%
      select(-SUBID, -CS, -TUS, -EXPERIMENT)
  }
  
  # Build the 8 matrices
  out <- list(
    amygdala_sham_safety       = make_wide("amygdala","sham","control"),
    amygdala_sham_threat       = make_wide("amygdala","sham","threat"),
    amygdala_active_safety     = make_wide("amygdala","active","control"),
    amygdala_active_threat     = make_wide("amygdala","active","threat"),
    hippocampus_sham_safety    = make_wide("hippocampus","sham","control"),
    hippocampus_sham_threat    = make_wide("hippocampus","sham","threat"),
    hippocampus_active_safety  = make_wide("hippocampus","active","control"),
    hippocampus_active_threat  = make_wide("hippocampus","active","threat")
  )
  
  # Save individual .RData files (keeps your existing downstream code compatible)
  saveRData <- function(obj, nm) save(obj, file = file.path(out_dir, paste0(nm, ".RData")))
  saveRData(out$amygdala_sham_safety,        "amygdala_sham_safety_df_wide")
  saveRData(out$amygdala_sham_threat,        "amygdala_sham_threat_df_wide")
  saveRData(out$amygdala_active_safety,      "amygdala_active_safety_df_wide")
  saveRData(out$amygdala_active_threat,      "amygdala_active_threat_df_wide")
  saveRData(out$hippocampus_sham_safety,     "hippocampus_sham_safety_df_wide")
  saveRData(out$hippocampus_sham_threat,     "hippocampus_sham_threat_df_wide")
  saveRData(out$hippocampus_active_safety,   "hippocampus_active_safety_df_wide")
  saveRData(out$hippocampus_active_threat,   "hippocampus_active_threat_df_wide")
  
  # Also store one combined list for quick loading
  saveRDS(out, list_rds)
  
  out
}
