if (!requireNamespace("here", quietly = TRUE)) install.packages("here")
source(here::here("stats","permutation_tests","palm_code","_setup.R"))

# Load the EXT matrices into the environment:
palm_load("ext")  # loads hippocampus_sham_threat_df_wide, hippocampus_sham_safety_df_wide, etc. for extinction

# --- Define output folder (project-relative)
out_dir <- here::here(
  "stats","permutation_tests","palm_files",
  "hip","hip_ext_sham_unr_CS"
)
if (!dir.exists(out_dir)) dir.create(out_dir, recursive = TRUE)

##### DATA #####

data_wide <- rbind(hippocampus_sham_threat_df_wide, hippocampus_sham_safety_df_wide)

# Write the data to a CSV file
write.table(
  data_wide,
  file      = file.path(out_dir, "data_hip_ext_sham_unr_CS.csv"),
  row.names = FALSE,
  col.names = FALSE,  # exclude column names
  sep       = ","
)

##### EXCHANGABILITY BLOCKS #####

# Number of subjects
subjects <- 25

# Generate the data frame for SUBJECT, TRIAL, and CONDITION
exchange_blocks <- expand.grid(
  EXPERIMENT = -1,           # top-level group
  SUBJECT    = rep(1:25, 2)  # 25 subjects × 2 CS conditions
)

# Add the CS column
exchange_blocks$CS <- rep(c(1, 2), each = subjects)

# Rearrange columns to ensure the top-level grouping column is first
exchangeability_file <- exchange_blocks[, c("EXPERIMENT", "SUBJECT", "CS")]

# Write the exchangeability blocks file to a CSV
write.table(
  exchangeability_file,
  file      = file.path(out_dir, "blocks_hip_ext_sham_unr_CS.csv"),
  row.names = FALSE,
  col.names = FALSE,
  sep       = ","
)

##### DESIGN MATRIX #####

subjects   <- 25
conditions <- 2

# Number of total rows (subject * conditions)
total_rows <- subjects * conditions
total_cols <- subjects + 1 # CS

# Initialize an empty matrix for the design matrix
design_matrix <- matrix(0, nrow = total_rows, ncol = total_cols)

# CS: threat
design_matrix[1:25,   1] <-  1
# CS: safety
design_matrix[26:50,  1] <- -1

# Add subject identity columns
for (i in 1:subjects) {
  design_matrix[i,        i + 1] <- 1  # threat rows
  design_matrix[25 + i,   i + 1] <- 1  # safety rows
}

# Convert to a data frame
design_matrix_df <- as.data.frame(design_matrix)

# Write the design matrix to a CSV file
write.table(
  design_matrix_df,
  file      = file.path(out_dir, "design_hip_ext_sham_unr_CS.csv"),
  row.names = FALSE,
  col.names = FALSE,  # exclude column names
  sep       = ","
)

##### CONTRAST MATRIX #####

# Initialize the contrast matrix with 0s (1 row, total_cols columns)
contrast_matrix <- matrix(0, nrow = 1, ncol = total_cols)

# Set the contrast for the first column (condition)
contrast_matrix[1, 1] <- 1  # CS effect

# Convert to a data frame and save as a CSV file
contrast_matrix_df <- as.data.frame(contrast_matrix)

write.table(
  contrast_matrix_df,
  file      = file.path(out_dir, "contrast_hip_ext_sham_unr_CS.csv"),
  row.names = FALSE,
  col.names = FALSE,
  sep       = ","
)
