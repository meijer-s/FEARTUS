# FEARTUS

FEARTUS contains the analysis code and behavioral data for the threat learning and extinction experiment involving transcranial ultrasonic stimulation (TUS) of the human amygdala and hippocampus. The repository includes:

- Trial-level skin conductance response (SCR) analyses  
- Cluster-based permutation tests using PALM  
- Linear mixed-effects (LME) models  
- Reinforcement-learning (RW) models  
- Questionnaire analyses  
- Fully relative paths based on `{here}` and minimal setup requirements  

All analyses are structured to allow direct execution of individual scripts.  
Each folder contains its own `_setup.R` or MATLAB bootstrap ensuring the correct project root.

---

## Repository structure

```text
FEARTUS
├── data/
├── stats/
│ ├── learning_models/
│ ├── lme_models/
│ └── permutation_tests/
└── FEARTUS.Rproj
```

Each subdirectory includes its own README documenting the purpose and workflow of its analysis code.

---

## Naming conventions

| Abbrev | Meaning |
|--------|---------|
| `acq`  | acquisition |
| `ext`  | extinction |
| `reext` | re-extinction |
| `retent` | threat retention |
| `reinst` | recovery following reinstatement |
| `TUS` | transcranial ultrasound stimulation |
| `CS` | conditioned stimulus |
| `US` | unconditioned stimulus |
| `amy`  | amygdala experiment |
| `hip`  | hippocampus experiment |
| `CSmain` | CS main effect |
| `CSxTUS` | CS × TUS interaction |
| `CSxTUSxEXP` | cross-experiment interactions |

These naming patterns are used throughout `palm_code`, `palm_files`, and the R analysis scripts.

---

## License

This project is released under the MIT License (see `LICENSE` file).
