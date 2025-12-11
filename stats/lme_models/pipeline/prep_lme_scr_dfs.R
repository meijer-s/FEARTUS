prep_lme_scr_dfs <- function() {

# Remove previously derived scr_df_* objects (keep raw scr_df)
to_delete <- setdiff(ls(pattern = "^scr_df", envir = .GlobalEnv), "scr_df")
if (length(to_delete)) rm(list = to_delete, envir = .GlobalEnv)

# Snapshot BEFORE creating derived data frames
.before <- ls(envir = .GlobalEnv)

# ---- CREATE DATA FRAMES ----

#### Experiment I: sham (amygdala) ####
# acquisition: CS
scr_df_amy_acq_sham_CS <- scr_df %>% 
  filter(EXPERIMENT == "amygdala", PHASE == "acquisition", TUS == "sham", US == "unreinforced")

scr_df_amy_acq_sham_CS_time <- scr_df %>%
  group_by(EXPERIMENT, SUBID, PHASE, TIME, TUS, CS, US) %>%
  summarise(SCR_sqrt_meanTime = mean(SCR_sqrt, na.rm = TRUE), .groups = "drop") %>% 
  filter(EXPERIMENT == "amygdala", PHASE == "acquisition", TUS == "sham", US == "unreinforced")

scr_df_amy_acq_sham_CS_early <- scr_df %>%
  group_by(EXPERIMENT, SUBID, PHASE, TIME, TUS, CS, US) %>%
  summarise(SCR_sqrt_meanTime = mean(SCR_sqrt, na.rm = TRUE), .groups = "drop") %>% 
  filter(EXPERIMENT == "amygdala", PHASE == "acquisition", TIME == "early", TUS == "sham", US == "unreinforced")

scr_df_amy_acq_sham_CS_mid <- scr_df %>%
  group_by(EXPERIMENT, SUBID, PHASE, TIME, TUS, CS, US) %>%
  summarise(SCR_sqrt_meanTime = mean(SCR_sqrt, na.rm = TRUE), .groups = "drop") %>% 
  filter(EXPERIMENT == "amygdala", PHASE == "acquisition", TIME == "mid", TUS == "sham", US == "unreinforced")

scr_df_amy_acq_sham_CS_late <- scr_df %>%
  group_by(EXPERIMENT, SUBID, PHASE, TIME, TUS, CS, US) %>%
  summarise(SCR_sqrt_meanTime = mean(SCR_sqrt, na.rm = TRUE), .groups = "drop") %>% 
  filter(EXPERIMENT == "amygdala", PHASE == "acquisition", TIME == "late", TUS == "sham", US == "unreinforced")

# acquisition: US
scr_df_amy_acq_sham_US <- scr_df %>% 
  filter(EXPERIMENT == "amygdala", PHASE == "acquisition", TUS == "sham", CS == "threat")

# threat retention
scr_df_amy_ret_sham_CS <- scr_df %>% 
  filter(EXPERIMENT == "amygdala", !is.na(RETENT), TUS == "sham", US == "unreinforced")

# extinction
scr_df_amy_ext_sham_CS <- scr_df %>% 
  filter(EXPERIMENT == "amygdala", PHASE == "extinction", TUS == "sham")

scr_df_amy_ext_sham_CS_time <- scr_df %>%
  group_by(EXPERIMENT, SUBID, PHASE, TIME, TUS, CS, US) %>%
  summarise(SCR_sqrt_meanTime = mean(SCR_sqrt, na.rm = TRUE), .groups = "drop") %>% 
  filter(EXPERIMENT == "amygdala", PHASE == "extinction", TUS == "sham", US == "unreinforced")

scr_df_amy_ext_sham_CS_early <- scr_df %>%
  group_by(EXPERIMENT, SUBID, PHASE, TIME, TUS, CS, US) %>%
  summarise(SCR_sqrt_meanTime = mean(SCR_sqrt, na.rm = TRUE), .groups = "drop") %>% 
  filter(EXPERIMENT == "amygdala", PHASE == "extinction", TIME == "early", TUS == "sham", US == "unreinforced")

scr_df_amy_ext_sham_CS_late <- scr_df %>%
  group_by(EXPERIMENT, SUBID, PHASE, TIME, TUS, CS, US) %>%
  summarise(SCR_sqrt_meanTime = mean(SCR_sqrt, na.rm = TRUE), .groups = "drop") %>% 
  filter(EXPERIMENT == "amygdala", PHASE == "extinction", TIME == "late", TUS == "sham", US == "unreinforced")

# recovery following reinstatement
scr_df_amy_rei_sham_CS <- scr_df %>% 
  filter(EXPERIMENT == "amygdala", !is.na(REINST), TUS == "sham", US == "unreinforced")

# re-extinction
scr_df_amy_reext_sham_CS <- scr_df %>% 
  filter(EXPERIMENT == "amygdala", PHASE == "re_extinction", TUS == "sham")

scr_df_amy_reext_sham_CS_time <- scr_df %>%
  group_by(EXPERIMENT, SUBID, PHASE, TIME, TUS, CS, US) %>%
  summarise(SCR_sqrt_meanTime = mean(SCR_sqrt, na.rm = TRUE), .groups = "drop") %>% 
  filter(EXPERIMENT == "amygdala", PHASE == "re_extinction", TUS == "sham", US == "unreinforced")

#### Experiment I vs. II: sham (amygdala) vs sham (hippocampus) ####
scr_df_exp_acq_sham_CS <- scr_df %>% 
  filter(PHASE == "acquisition", TUS == "sham", US == "unreinforced")

scr_df_exp_acq_sham_US <- scr_df %>% 
  filter(PHASE == "acquisition", TUS == "sham", CS == "threat")

scr_df_exp_ret_sham_CS <- scr_df %>% 
  filter(!is.na(RETENT), TUS == "sham", US == "unreinforced")

scr_df_exp_ext_sham_CS <- scr_df %>% 
  filter(PHASE == "extinction", TUS == "sham")

scr_df_exp_ext_sham_CS_time <- scr_df %>%
  group_by(EXPERIMENT, SUBID, PHASE, TIME, TUS, CS, US) %>%
  summarise(SCR_sqrt_meanTime = mean(SCR_sqrt, na.rm = TRUE), .groups = "drop") %>% 
  filter(PHASE == "extinction", TUS == "sham", US == "unreinforced")

scr_df_exp_rei_sham_CS <- scr_df %>% 
  filter(!is.na(REINST), TUS == "sham", US == "unreinforced")

scr_df_exp_reext_sham_CS <- scr_df %>% 
  filter(PHASE == "re_extinction", TUS == "sham")

scr_df_exp_reext_sham_CS_time <- scr_df %>%
  group_by(EXPERIMENT, SUBID, PHASE, TIME, TUS, CS, US) %>%
  summarise(SCR_sqrt_meanTime = mean(SCR_sqrt, na.rm = TRUE), .groups = "drop") %>% 
  filter(PHASE == "re_extinction", TUS == "sham", US == "unreinforced")

#### Experiment I: active TUS vs. sham (amygdala) ####
scr_df_amy_acq_CS_TUS <- scr_df %>% 
  filter(EXPERIMENT == "amygdala", PHASE == "acquisition", US == "unreinforced")
scr_df_amy_acq_US_TUS <- scr_df %>% 
  filter(EXPERIMENT == "amygdala", PHASE == "acquisition", US == "reinforced")
scr_df_amy_acq_CSUS_TUS <- scr_df %>% 
  filter(EXPERIMENT == "amygdala", PHASE == "acquisition", CS == "threat", US == "reinforced")

scr_df_amy_acq_CS_TUS_early <- scr_df %>% group_by(EXPERIMENT, SUBID, PHASE, TIME, TUS, CS, US) %>%
  summarise(SCR_sqrt_meanTime = mean(SCR_sqrt, na.rm = TRUE), .groups = "drop") %>% 
  filter(EXPERIMENT == "amygdala", PHASE == "acquisition", TIME == "early", US == "unreinforced")
scr_df_amy_acq_CS_TUS_mid <- scr_df %>% group_by(EXPERIMENT, SUBID, PHASE, TIME, TUS, CS, US) %>%
  summarise(SCR_sqrt_meanTime = mean(SCR_sqrt, na.rm = TRUE), .groups = "drop") %>% 
  filter(EXPERIMENT == "amygdala", PHASE == "acquisition", TIME == "mid",   US == "unreinforced")
scr_df_amy_acq_CS_TUS_late <- scr_df %>% group_by(EXPERIMENT, SUBID, PHASE, TIME, TUS, CS, US) %>%
  summarise(SCR_sqrt_meanTime = mean(SCR_sqrt, na.rm = TRUE), .groups = "drop") %>% 
  filter(EXPERIMENT == "amygdala", PHASE == "acquisition", TIME == "late",  US == "unreinforced")

scr_df_amy_acq_CS_TUS_early_trial <- scr_df %>% 
  filter(EXPERIMENT == "amygdala", PHASE == "acquisition", TIME == "early", US == "unreinforced")

scr_df_amy_ret_CS_TUS <- scr_df %>% 
  filter(EXPERIMENT == "amygdala", !is.na(RETENT), US == "unreinforced")

scr_df_amy_ext_CS_TUS <- scr_df %>% 
  filter(EXPERIMENT == "amygdala", PHASE == "extinction")

scr_df_amy_ext_CS_TUS_time <- scr_df %>% group_by(EXPERIMENT, SUBID, PHASE, TIME, TUS, CS, US) %>%
  summarise(SCR_sqrt_meanTime = mean(SCR_sqrt, na.rm = TRUE), .groups = "drop") %>% 
  filter(EXPERIMENT == "amygdala", PHASE == "extinction", US == "unreinforced")

scr_df_amy_ext_CS_TUS_early <- scr_df %>% group_by(EXPERIMENT, SUBID, PHASE, TIME, TUS, CS, US) %>%
  summarise(SCR_sqrt_meanTime = mean(SCR_sqrt, na.rm = TRUE), .groups = "drop") %>% 
  filter(EXPERIMENT == "amygdala", PHASE == "extinction", TIME == "early")

scr_df_amy_ext_CS_TUS_late <- scr_df %>% group_by(EXPERIMENT, SUBID, PHASE, TIME, TUS, CS, US) %>%
  summarise(SCR_sqrt_meanTime = mean(SCR_sqrt, na.rm = TRUE), .groups = "drop") %>% 
  filter(EXPERIMENT == "amygdala", PHASE == "extinction", TIME == "late")

scr_df_amy_ext_CS_TUS_early_trial <- scr_df %>% 
  filter(EXPERIMENT == "amygdala", PHASE %in% c("extinction","retention"), TIME == "early")

scr_df_amy_rei_CS_TUS <- scr_df %>% 
  filter(EXPERIMENT == "amygdala", !is.na(REINST), US == "unreinforced")

scr_df_amy_reext_CS_TUS <- scr_df %>% 
  filter(EXPERIMENT == "amygdala", PHASE == "re_extinction")

scr_df_amy_reext_CS_TUS_time <- scr_df %>% group_by(EXPERIMENT, SUBID, PHASE, TIME, TUS, CS, US) %>%
  summarise(SCR_sqrt_meanTime = mean(SCR_sqrt, na.rm = TRUE), .groups = "drop") %>% 
  filter(EXPERIMENT == "amygdala", PHASE == "re_extinction", US == "unreinforced")

scr_df_amy_reext_CS_TUS_early <- scr_df %>% group_by(EXPERIMENT, SUBID, PHASE, TIME, TUS, CS, US) %>%
  summarise(SCR_sqrt_meanTime = mean(SCR_sqrt, na.rm = TRUE), .groups = "drop") %>% 
  filter(EXPERIMENT == "amygdala", PHASE == "re_extinction", TIME == "early")

scr_df_amy_reext_CS_TUS_late <- scr_df %>% group_by(EXPERIMENT, SUBID, PHASE, TIME, TUS, CS, US) %>%
  summarise(SCR_sqrt_meanTime = mean(SCR_sqrt, na.rm = TRUE), .groups = "drop") %>% 
  filter(EXPERIMENT == "amygdala", PHASE == "re_extinction", TIME == "late")

#### Experiment II: active TUS vs. sham (hippocampus) ####
scr_df_hip_acq_CS_TUS <- scr_df %>% 
  filter(EXPERIMENT == "hippocampus", PHASE == "acquisition", US == "unreinforced")
scr_df_hip_acq_US_TUS <- scr_df %>% 
  filter(EXPERIMENT == "hippocampus", PHASE == "acquisition", CS == "threat")
scr_df_hip_ret_CS_TUS <- scr_df %>% 
  filter(EXPERIMENT == "hippocampus", !is.na(RETENT), US == "unreinforced")
scr_df_hip_ext_CS_TUS <- scr_df %>% 
  filter(EXPERIMENT == "hippocampus", PHASE == "extinction")

scr_df_hip_ext_CS_TUS_time <- scr_df %>% group_by(EXPERIMENT, SUBID, PHASE, TIME, TUS, CS, US) %>%
  summarise(SCR_sqrt_meanTime = mean(SCR_sqrt, na.rm = TRUE), .groups = "drop") %>% 
  filter(EXPERIMENT == "hippocampus", PHASE == "extinction", US == "unreinforced")

scr_df_hip_rei_CS_TUS <- scr_df %>% 
  filter(EXPERIMENT == "hippocampus", !is.na(REINST), US == "unreinforced")

scr_df_hip_reext_CS_TUS <- scr_df %>% 
  filter(EXPERIMENT == "hippocampus", PHASE == "re_extinction")

scr_df_hip_reext_CS_TUS_time <- scr_df %>% group_by(EXPERIMENT, SUBID, PHASE, TIME, TUS, CS, US) %>%
  summarise(SCR_sqrt_meanTime = mean(SCR_sqrt, na.rm = TRUE), .groups = "drop") %>% 
  filter(EXPERIMENT == "hippocampus", PHASE == "re_extinction", US == "unreinforced")

#### Experiment I vs II: all TUS levels ####
scr_df_exp_acq_CS_TUS <- scr_df %>% 
  filter(PHASE == "acquisition", US == "unreinforced")

scr_df_exp_acq_CS_TUS_early <- scr_df %>% group_by(EXPERIMENT, SUBID, PHASE, TIME, TUS, CS, US) %>%
  summarise(SCR_sqrt_meanTime = mean(SCR_sqrt, na.rm = TRUE), .groups = "drop") %>% 
  filter(PHASE == "acquisition", TIME == "early", US == "unreinforced")

scr_df_exp_acq_CS_TUS_mid <- scr_df %>% group_by(EXPERIMENT, SUBID, PHASE, TIME, TUS, CS, US) %>%
  summarise(SCR_sqrt_meanTime = mean(SCR_sqrt, na.rm = TRUE), .groups = "drop") %>% 
  filter(PHASE == "acquisition", TIME == "mid", US == "unreinforced")

scr_df_exp_acq_CS_TUS_late <- scr_df %>% group_by(EXPERIMENT, SUBID, PHASE, TIME, TUS, CS, US) %>%
  summarise(SCR_sqrt_meanTime = mean(SCR_sqrt, na.rm = TRUE), .groups = "drop") %>% 
  filter(PHASE == "acquisition", TIME == "late", US == "unreinforced")

scr_df_exp_acq_CS_TUS_early_trial <- scr_df %>% 
  filter(PHASE == "acquisition", TIME == "early", US == "unreinforced")

scr_df_exp_ret_CS_TUS <- scr_df %>% 
  filter(!is.na(RETENT), US == "unreinforced")

scr_df_exp_ext_CS_TUS <- scr_df %>% 
  filter(PHASE == "extinction")

scr_df_exp_ext_CS_TUS_time <- scr_df %>% group_by(EXPERIMENT, SUBID, PHASE, TIME, TUS, CS, US) %>%
  summarise(SCR_sqrt_meanTime = mean(SCR_sqrt, na.rm = TRUE), .groups = "drop") %>% 
  filter(PHASE == "extinction", US == "unreinforced")

scr_df_exp_ext_CS_TUS_early <- scr_df %>% group_by(EXPERIMENT, SUBID, PHASE, TIME, TUS, CS, US) %>%
  summarise(SCR_sqrt_meanTime = mean(SCR_sqrt, na.rm = TRUE), .groups = "drop") %>% 
  filter(PHASE == "extinction", TIME == "early")

scr_df_exp_ext_CS_TUS_late <- scr_df %>% group_by(EXPERIMENT, SUBID, PHASE, TIME, TUS, CS, US) %>%
  summarise(SCR_sqrt_meanTime = mean(SCR_sqrt, na.rm = TRUE), .groups = "drop") %>% 
  filter(PHASE == "extinction", TIME == "late")

scr_df_exp_ext_CS_TUS_early_trial <- scr_df %>% 
  filter(PHASE %in% c("extinction", "retention"), TIME == "early")

scr_df_exp_rei_CS_TUS <- scr_df %>% 
  filter(!is.na(REINST), US == "unreinforced")

scr_df_exp_reext_CS_TUS <- scr_df %>% 
  filter(PHASE == "re_extinction")

scr_df_exp_reext_CS_TUS_time <- scr_df %>% group_by(EXPERIMENT, SUBID, PHASE, TIME, TUS, CS, US) %>%
  summarise(SCR_sqrt_meanTime = mean(SCR_sqrt, na.rm = TRUE), .groups = "drop") %>% 
  filter(PHASE == "re_extinction", US == "unreinforced")

scr_df_exp_reext_CS_TUS_early <- scr_df %>% group_by(EXPERIMENT, SUBID, PHASE, TIME, TUS, CS, US) %>%
  summarise(SCR_sqrt_meanTime = mean(SCR_sqrt, na.rm = TRUE), .groups = "drop") %>% 
  filter(PHASE == "re_extinction", TIME == "early")

scr_df_exp_reext_CS_TUS_late <- scr_df %>% group_by(EXPERIMENT, SUBID, PHASE, TIME, TUS, CS, US) %>%
  summarise(SCR_sqrt_meanTime = mean(SCR_sqrt, na.rm = TRUE), .groups = "drop") %>% 
  filter(PHASE == "re_extinction", TIME == "late")

# ---- Snapshot AFTER ----
.after <- ls(envir = .GlobalEnv)
new_objects <- setdiff(.after, .before)

# Keep only newly created objects that start with scr_df and are data frames/tibbles
obj_names <- grep("^scr_df", new_objects, value = TRUE)
objs <- mget(obj_names, envir = .GlobalEnv, inherits = TRUE)
is_df <- vapply(objs, function(x) inherits(x, c("data.frame","tbl","tbl_df")), logical(1))
dfs_created <- objs[is_df]

# Save to disk
dir_out <- here::here("data")
if (!dir.exists(dir_out)) dir.create(dir_out, recursive = TRUE)

# collect newly created scr_df_* data frames
obj_names <- ls()
obj_names <- obj_names[grepl("^scr_df", obj_names)]
objs <- mget(obj_names, inherits = FALSE)
is_df <- vapply(objs, function(x) inherits(x, c("data.frame","tbl","tbl_df")), logical(1))
dfs_created <- objs[is_df]
saveRDS(dfs_created, file.path(dir_out, "lme_model_data_list.rds"))

return(invisible(NULL))
}

# run it
prep_lme_scr_dfs()
