# Molecular Docking Results Processing Script

## Overview
This R script processes molecular docking results from **AutoDock Vina** output logs, transforming raw data into structured analysis outputs. It extracts **binding affinity** and **RMSD** values for the top 20 docking modes from `log.txt` files, computes statistical metrics including **mean binding energy**, **standard deviation**, and **confidence intervals**, and generates three key outputs:

1. `Supplementary_Table_S1.csv` — Detailed docking parameters table  
2. `Supplementary_Table_S2.csv` — Statistical summary  
3. `docking_energy_distribution.png` — Binding energy distribution histogram

## Features
- Robust parsing to handle format variations in **Vina** logs  
- Automated statistical calculations (mean, SD, CI)  
- Visual data representation for efficient analysis of molecular interactions  
- Real-time console execution feedback confirming:
  - Successful file generation
  - Summary statistics

## Key Functionality
- Extraction of docking modes and affinity values  
- RMSD data processing  
- Statistical computation with confidence interval determination  
- Generation of publication-ready outputs with integrated visualization  

## Output Details
- **Naming conventions**: consistent and descriptive  
- **File format**: CSV for tabular data to ensure compatibility with downstream analysis  
- **Visualization**: Histogram annotated with statistical parameters for immediate interpretation of binding energy distributions across docking modes

## Purpose
This tool standardizes molecular docking result analysis pipelines and ensures **reproducible** and **organized** data processing for high-quality computational chemistry workflows.
