# Project Overview

This R script analyzes correlations between immune cell infiltration proportions and co-expressed genes in treatment groups. It calculates Spearman correlations, visualizes relationships through a coupled correlation plot, and highlights statistically significant associations between immune cell types and target genes.

## File Structure

### Core Component:
- `5.immune_cell_gene_correlation.R`: Main analysis script

### Required Input Files:
- `GSE27536.txt`: Processed expression matrix
- `interGenes.List.txt`: Target gene list
- `CIBERSORT-Results.txt`: Immune cell proportions

### Output File:
- `cor.pdf` (visualization)

## Input File Format

### `GSE27536.txt`
- Tab-delimited matrix with:
  - Row names: Gene symbols
  - Column names: Sample IDs (must contain "_Treat" suffix for treatment group)

### `interGenes.List.txt`
- Plain text file with one gene symbol per line

### `CIBERSORT-Results.txt`
- Immune cell proportions (22 columns) with sample IDs matching expression matrix
- Example format:
```
GSM1234_Treat  B.cells.naive  0.05  T.cells.CD8  0.12  ...
```


## Execution Workflow

1. Install dependencies:
    ```r
    BiocManager::install("limma")
    install.packages(c("dplyr", "tidyverse", "ggplot2", "devtools"))
    devtools::install_github("Hy4m/linkET")
    ```
2. Set working directory in script (line 22)
    ```r
    setwd("path/to/your/data")
    ```
3. Run script:
    ```r
    source("5.immune_cell_gene_correlation.R")
    ```
4. The script automatically:
   - Filters to treatment group samples (ID contains "_Treat")
   - Matches samples across expression and immune cell data
   - Computes Spearman correlations (gene vs. immune cell)
   - Classifies correlations by significance (p<0.05) and direction
   - Bins absolute correlation values into tiers

## Output Files

### `cor.pdf`
- Multi-layer visualization showing:
  - Lower triangle: Immune cell-to-cell Spearman correlations (heatmap)
  - Upper elements: Gene-immune cell correlations with:
    - Line color: Significance/direction (green=positive, orange=negative, gray=NS)
    - Line thickness: Absolute correlation strength (4 tiers: <0.2 to ≥0.6)
  - Color gradient: Blue-to-red for cell-cell correlations
  - Comprehensive legends for interpretation

### Statistical Handling:
- Spearman's rank correlation
- P-value threshold: 0.05
- Absolute correlation binning for visual weighting