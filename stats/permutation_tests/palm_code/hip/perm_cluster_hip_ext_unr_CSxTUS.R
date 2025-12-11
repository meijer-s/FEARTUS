if (!requireNamespace("here", quietly = TRUE)) install.packages("here")
source(here::here("stats","permutation_tests","palm_code","_setup.R"))

# Load the extinction matrices into the environment
palm_load("ext")  # gives hippocampus_sham_threat_df_wide, hippocampus_active_threat_df_wide, etc.

# --- Define output folder (project-relative)
out_dir <- here::here(
  "stats","permutation_tests","palm_files",
  "hip","hip_ext_unr_CSxTUS"
)
if (!dir.exists(out_dir)) dir.create(out_dir, recursive = TRUE)

##### DATA #####

data_wide <- rbind(
  hippocampus_sham_threat_df_wide,
  hippocampus_sham_safety_df_wide,
  hippocampus_active_threat_df_wide,
  hippocampus_active_safety_df_wide
)

# Write the data to a CSV file
write.table(
  data_wide,
  file      = file.path(out_dir, "data_hip_ext_unr_CSxTUS.csv"),
  row.names = FALSE,
  col.names = FALSE,  # exclude column names
  sep       = ","
)

##### EXCHANGABILITY BLOCKS #####

# Number of subjects, trials, and conditions
subjects <- 25
TUS      <- 50  # as in your original script

# Generate the data frame for SUBJECT and conditions
exchange_blocks <- expand.grid(
  SUBJECT = rep(1:subjects, 4)  # 25 subjects × 4 CS×TUS conditions
)

exchange_blocks$CS  <- rep(c(1, 2), each = subjects)   # CS levels
exchange_blocks$TUS <- rep(c(1, 2), each = TUS)        # TUS levels

# Add a top-level constant grouping column
exchange_blocks$EXPERIMENT <- -1

# Rearrange columns to ensure the top-level grouping column is first
exchangeability_file <- exchange_blocks[, c("EXPERIMENT", "SUBJECT", "TUS", "CS")]

# Write the exchangeability blocks file to a CSV
write.table(
  exchangeability_file,
  file      = file.path(out_dir, "blocks_hip_ext_unr_CSxTUS.csv"),
  row.names = FALSE,
  col.names = FALSE,
  sep       = ","
)

##### DESIGN MATRIX #####

subjects   <- 25
conditions <- 4

# Number of total rows (subject × conditions)
total_rows <- subjects * conditions
total_cols <- subjects + 1 + 1 + 1 # CS + TUS + INTERACTION

# Initialize an empty matrix for the design matrix
design_matrix <- matrix(0, nrow = total_rows, ncol = total_cols)

# TUS: sham vs active
design_matrix[1:50,   1] <-  1  # sham
design_matrix[51:100, 1] <- -1  # active

# CS: threat vs safety
design_matrix[1:25,    2] <-  1   # sham, threat
design_matrix[26:50,   2] <- -1   # sham, safety
design_matrix[51:75,   2] <-  1   # active, threat
design_matrix[76:100,  2] <- -1   # active, safety

# CS×TUS interaction coding (your original pattern)
design_matrix[1:25,    3] <-  1   # sham, threat
design_matrix[26:50,   3] <- -1   # sham, safety
design_matrix[51:75,   3] <- -1   # active, threat
design_matrix[76:100,  3] <-  1   # active, safety

# Add subject identity columns
for (i in 1:subjects) {
  design_matrix[i,        i + 3] <- 1
  design_matrix[25 + i,   i + 3] <- 1
  design_matrix[50 + i,   i + 3] <- 1
  design_matrix[75 + i,   i + 3] <- 1
}

design_matrix_df <- as.data.frame(design_matrix)

# Write the design matrix to a CSV file
write.table(
  design_matrix_df,
  file      = file.path(out_dir, "design_hip_ext_unr_CSxTUS.csv"),
  row.names = FALSE,
  col.names = FALSE,
  sep       = ","
)

##### CONTRAST MATRIX #####

# Initialize the contrast matrix (3 rows: CS, TUS, CS×TUS)
contrast_matrix <- matrix(0, nrow = 3, ncol = total_cols)

contrast_matrix[1, 1] <- 1  # TUS main effect (column 1)
contrast_matrix[2, 2] <- 1  # CS main effect (column 2)
contrast_matrix[3, 3] <- 1  # CS×TUS interaction (column 3)

contrast_matrix_df <- as.data.frame(contrast_matrix)

write.table(
  contrast_matrix_df,
  file      = file.path(out_dir, "contrast_hip_ext_unr_CSxTUS.csv"),
  row.names = FALSE,
  col.names = FALSE,
  sep       = ","
)
