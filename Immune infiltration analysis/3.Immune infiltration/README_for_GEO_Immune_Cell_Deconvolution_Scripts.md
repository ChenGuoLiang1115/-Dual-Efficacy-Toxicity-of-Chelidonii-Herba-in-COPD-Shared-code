# Project Overview

These scripts implement the CIBERSORT algorithm for immune cell deconvolution of GEO expression data. They estimate relative proportions of 22 immune cell types in bulk tissue samples using a support vector regression approach with gene expression signatures.

## File Structure

### Two core components:
- `3.GEOimmune.CIBERSORT.R`: Core algorithm implementation (CIBERSORT functions)
- `3.GEOimmune.run.R`: Execution script

### Required Input Files:
- `ref.txt`: Immune cell signature matrix (LM22)
- `merge.normalize.txt`: Normalized expression matrix

## Input File Format

### `ref.txt`
- Tab-delimited signature matrix with:
  - Row 1: Immune cell type names
  - Column 1: Gene symbols
  - Matrix cells: Signature expression values

### `merge.normalize.txt`
- Tab-delimited expression matrix with:
  - Row 1: Sample IDs
  - Column 1: Gene symbols
  - Matrix cells: Normalized expression values

## Execution Workflow

1. Install dependencies:
    ```r
    install.packages('e1071')
    BiocManager::install("preprocessCore")
    ```
2. Set working directory in `3.GEOimmune.run.R` (line 10):
    ```r
    setwd("path/to/your/data")
    ```
3. Run:
    ```r
    source("3.GEOimmune.run.R")
    ```
4. The script:
   - Sources core CIBERSORT functions
   - Performs 1000 permutations for p-value calculation
   - Applies quantile normalization (QN=TRUE)
   - Filters results by p-value (<1)

## Output Files

### `CIBERSORT-Results.txt`
- Tab-delimited file containing:
  - Column 1: Sample IDs
  - Columns 2-23: Proportions of 22 immune cell types
  - Last columns: P-value, Correlation, RMSE

### Key Features:
- Only includes samples with p-value < 1
- Removes statistical metrics from final output
- Row 1 contains column headers