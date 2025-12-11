# Cluster-based permutation tests (FEARTUS)

This folder contains all PALM-based cluster-corrected permutation analyses for trial-level SCR data.  
The analyses identify significant clusters of SCR differences across trials for:

- Amygdala and hippocampus experiments  
- Sham-only CS effects  
- TUS-related contrasts  
- Cross-experiment interactions  
- Acquisition, extinction, and re-extinction phases  

All PALM scripts (MATLAB) and data-preparation scripts (R) run with project-relative paths.

---

## Folder structure

permutation_tests/
├── palm-alpha119/ # Full PALM toolbox (unmodified)
├── palm_code/ # MATLAB + R wrapper scripts (one per contrast)
├── palm_files/ # CSVs for data, design, contrasts, and exchangeability blocks (auto-created)
├── palm_results/ # Output folders (auto-created)
└── pipeline/ # R scripts for generating trial-level PALM files

---

## How to run analyses

Each MATLAB script:

1. Anchors itself relative to the FEARTUS root  
2. Adds `palm-alpha119` to the MATLAB path  
3. Loads trial-level SCR matrices from `palm_files/...`  
4. Builds the exchangeability tree  
5. Executes PALM  
6. Writes output to `palm_results/...`  
