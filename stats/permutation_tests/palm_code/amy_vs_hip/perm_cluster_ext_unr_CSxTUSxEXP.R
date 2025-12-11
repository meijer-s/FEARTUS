if (!requireNamespace("here", quietly = TRUE)) install.packages("here")
source(here::here("stats", "permutation_tests", "palm_code", "_setup.R"))

# Load the EXTINCTION matrices into the environment
palm_load("ext")

# --- Define output folder (project-relative)
out_dir <- here::here(
  "stats", "permutation_tests", "palm_files",
  "amy_vs_hip", "ext_unr_CSxTUSxEXP"
)
if (!dir.exists(out_dir)) dir.create(out_dir, recursive = TRUE)

##### DATA #####

data_wide <- rbind(
  amygdala_sham_threat_df_wide,      amygdala_sham_safety_df_wide,
  amygdala_active_threat_df_wide,    amygdala_active_safety_df_wide,
  hippocampus_sham_threat_df_wide,   hippocampus_sham_safety_df_wide,
  hippocampus_active_threat_df_wide, hippocampus_active_safety_df_wide
)

# Write the data to a CSV file
write.table(
  data_wide,
  file      = file.path(out_dir, "data_ext_unr_CSxTUSxEXP.csv"),
  row.names = FALSE,
  col.names = FALSE,  # exclude column names
  sep       = ","
)

##### EXCHANGABILITY BLOCKS #####

# Number of subjects, trials, and conditions
subjects   <- 25
TUS        <- 50
EXPERIMENT <- 100

EXP1_SUB <- rep(1:25, 4)    # Repeats 1 to 25 four times
EXP2_SUB <- rep(26:50, 4)   # Repeats 26 to 50 four times

# Generate the data frame for SUBJECT, TRIAL, and CONDITION
exchange_blocks <- expand.grid(
  SUBJECT = c(EXP1_SUB, EXP2_SUB)
)

exchange_blocks$CS  <- rep(c(1, 2), each = subjects)
exchange_blocks$TUS <- rep(c(1, 2), each = TUS)

# Add a top-level constant grouping column
exchange_blocks$EXPERIMENT <- rep(c(-1, -2), each = EXPERIMENT)
exchange_blocks$COMPLETE   <- rep(-1, each = 200)

# Rearrange columns to ensure the top-level grouping column is first
exchangeability_file <- exchange_blocks[, c("COMPLETE", "EXPERIMENT", "SUBJECT", "TUS", "CS")]

# Write the exchangeability blocks file to a CSV
write.table(
  exchangeability_file,
  file      = file.path(out_dir, "blocks_ext_unr_CSxTUSxEXP.csv"),
  row.names = FALSE,
  col.names = FALSE,
  sep       = ","
)

##### DESIGN MATRIX #####

conditions  <- 4
experiments <- 2

# Number of total rows (subject * conditions)
total_rows <- subjects * conditions
total_cols <- subjects * experiments + 1 + 1 + 1 # CS, TUS, CS×TUS×EXP

# Initialize an empty matrix for the design matrix
design_matrix <- matrix(0, nrow = total_rows, ncol = total_cols)

design_matrix <- rbind(design_matrix, design_matrix)

# TUS: sham / active (both experiments)
design_matrix[1:50,    1] <-  1
design_matrix[51:100,  1] <- -1
design_matrix[101:150, 1] <-  1
design_matrix[151:200, 1] <- -1

# CS: threat / safety (both experiments)
design_matrix[1:25,     2] <-  1
design_matrix[26:50,    2] <- -1
design_matrix[51:75,    2] <-  1
design_matrix[76:100,   2] <- -1

design_matrix[101:125,  2] <-  1
design_matrix[126:150,  2] <- -1
design_matrix[151:175,  2] <-  1
design_matrix[176:200,  2] <- -1

# EXP×TUS×CS-coded column (unchanged logic)
# EXP amygdala
design_matrix[1:25,    3] <-  1  # sham, threat
design_matrix[26:50,   3] <- -1  # sham, safety
design_matrix[51:75,   3] <- -1  # active, threat
design_matrix[76:100,  3] <-  1  # active, safety

# EXP hippocampus
design_matrix[101:125, 3] <- -1  # sham, threat
design_matrix[126:150, 3] <-  1  # sham, safety
design_matrix[151:175, 3] <-  1  # active, threat
design_matrix[176:200, 3] <- -1  # active, safety

subjects <- 25

# Subject identity columns
for (i in 1:subjects) {
  design_matrix[i,            i + 3]      <- 1
  design_matrix[25 + i,       i + 3]      <- 1
  design_matrix[50 + i,       i + 3]      <- 1
  design_matrix[75 + i,       i + 3]      <- 1
  
  design_matrix[i + 100,      i + 3 + 25] <- 1
  design_matrix[25 + 100 + i, i + 3 + 25] <- 1
  design_matrix[50 + 100 + i, i + 3 + 25] <- 1
  design_matrix[75 + 100 + i, i + 3 + 25] <- 1
}

design_matrix_df <- as.data.frame(design_matrix)

# Write the design matrix to a CSV file
write.table(
  design_matrix_df,
  file      = file.path(out_dir, "design_ext_unr_CSxTUSxEXP.csv"),
  row.names = FALSE,
  col.names = FALSE,
  sep       = ","
)

##### CONTRAST MATRIX #####

contrast_matrix <- matrix(0, nrow = 3, ncol = total_cols)

contrast_matrix[1, 1] <- 1  # TUS main
contrast_matrix[2, 2] <- 1  # CS main
contrast_matrix[3, 3] <- 1  # CS×TUS×EXP interaction

contrast_matrix_df <- as.data.frame(contrast_matrix)

write.table(
  contrast_matrix_df,
  file      = file.path(out_dir, "contrast_ext_unr_CSxTUSxEXP.csv"),
  row.names = FALSE,
  col.names = FALSE,
  sep       = ","
)
