# Project Overview

This R script processes gene expression matrices from GEO datasets by performing normalization, log2 transformation, and sample type annotation. It integrates control and treatment group information to generate a standardized expression matrix ready for differential expression analysis.

## File Structure

### Required Files:
- `2.add_sample_type_correction.R`: Main R script
- `geneMatrix.txt`: Input expression matrix (from previous annotation step)
- `sample1.txt`: Control group sample IDs
- `sample2.txt`: Treatment group sample IDs

### Output File:
- `GSE28750.txt` (processed expression matrix)

## Input File Format

### `geneMatrix.txt`
- Tab-delimited gene expression matrix with:
  - Row 1: Sample headers
  - Column 1: Gene symbols
  - Matrix cells: Expression values

### `sample1.txt/sample2.txt`
- Plain text files listing sample IDs (one per line) corresponding to control and treatment groups

## Execution Workflow

1. Install required packages if missing:
    ```r
    install.packages(c("limma", "ggpubr", "pROC"))
    ```
2. Set working directory in script (line 15):
    ```r
    setwd("path/to/your/data")
    ```
3. Run script:
    ```r
    source("2.add_sample_type_correction.R")
    ```
4. The script automatically:
   - Normalizes data using `normalizeBetweenArrays()`.
   - Applies log2 transformation if needed (based on data distribution).
   - Annotates samples with "Control" or "Treat" labels.
   - Merges control/treatment datasets.

## Output Files

### `GSE28750.txt`
- Processed expression matrix with:
  - First row: Sample IDs with type annotation (e.g., "GSM1234_Control")
  - Subsequent rows: Gene symbols and normalized expression values
  - Format: Tab-delimited, ready for differential expression analysis

### Data Processing
- Multiple probes per gene averaged (`avereps()`)
- Quantile-based log2 transformation
- Between-array normalization
- Control/treatment sample integration