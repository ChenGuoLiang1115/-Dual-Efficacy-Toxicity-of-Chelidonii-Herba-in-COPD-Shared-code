# Automated Batch Processing for FDR Correction in Enrichment Analysis

## Overview
This R script provides automated batch processing for false discovery rate (FDR) correction of enrichment analysis data across **BP**, **CC**, **MF**, and **KEGG** categories using a consistent FDR threshold of `<0.01`. It processes Excel input files containing raw p-values, applies **Benjamini–Hochberg** correction to calculate adjusted FDR values, and generates comprehensive output packages.

## Output Structure
For each processed dataset, the tool generates an Excel workbook with three sheets:
1. **Full FDR-corrected results**
2. **Statistically significant findings** (FDR < 0.01)
3. **Documentation page** detailing processing parameters

Additionally, the pipeline:
- Creates a visualization plot showing the FDR correction profile
- Maintains a master summary report of batch processing statistics

## Key Functionalities
- **Intelligent p-value column detection** supporting naming variations
- **Automatic filtering** of invalid p-values outside the `[0,1]` range
- **Systematic handling** of duplicate column names
- Integrated quality control with:
  - Console progress reporting
  - Detailed metrics on valid/invalid entries
  - Significance rate calculations
- Standardized output naming:
  - Excel workbooks: `*_FDR校正结果.xlsx`
  - Visualization images: `*_FDR校正图.png`

## Batch Processing Mode
The batch mode sequentially processes **BP**, **CC**, **MF**, and **KEGG** input files while maintaining a unified FDR threshold of `0.01` across all analyses.

## Summary Report
The final summary report includes:
- Total tests performed
- Significant results identified per category
- Output file paths

This ensures complete auditability and standardizes statistical adjustment procedures for **high-throughput omics data analysis** pipelines.
