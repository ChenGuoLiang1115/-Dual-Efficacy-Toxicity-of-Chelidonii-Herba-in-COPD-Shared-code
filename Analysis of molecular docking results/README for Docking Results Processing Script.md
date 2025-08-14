# Molecular Docking Results Processing Script

## Overview
This R script processes molecular docking results from **AutoDock Vina** output logs, transforming raw data into structured analysis outputs. It extracts **binding affinity** and **RMSD** values for the top 20 docking modes from `log.txt` files, computes statistical metrics including **mean binding energy**, **standard deviation**, and **confidence intervals**, and generates three key outputs:

1. **Detailed docking parameters table** — `Supplementary_Table_S1.csv`  
2. **Statistical summary** — `Supplementary_Table_S2.csv`  
3. **Binding energy distribution histogram** — `docking_energy_distribution.png`

## Key Functionalities
- Extraction of docking modes and affinity values  
- RMSD data processing and cleaning  
- Statistical computation, including confidence interval determination  
- Publication-ready outputs with integrated visualization  
- Robust parsing to handle **Vina** log format variations  
- Real-time console feedback confirming:
  - Successful file generation
  - Summary statistics reporting

## Output Details
- **`Supplementary_Table_S1.csv`** — Contains extracted docking parameters for the top 20 modes  
- **`Supplementary_Table_S2.csv`** — Includes statistical summaries (mean, SD, CI)  
- **`docking_energy_distribution.png`** — Histogram visualization annotated with statistical parameters for quick interpretation

## Workflow Standardization
This tool standardizes molecular docking result analysis pipelines, ensuring **reproducible data processing** and **consistent output formatting**. All output files follow:
- **Consistent naming conventions**
- **CSV format compatibility** for seamless downstream analysis integration
