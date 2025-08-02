# README for GEO Annotation Script (Gene Symbol Present)

## 1. Project Overview

This Perl script processes GEO microarray expression data when gene symbols are available in the platform annotation file. It converts probe-level expression values to gene-level expression matrices by averaging multiple probes mapping to the same gene symbol, enabling downstream gene expression analysis.

## 2. File Structure

The repository contains:

- `1.GEO_annotation_gene_symbol.pl`: Main executable Perl script
- Required input files:
  - `GSE.txt`: Raw expression matrix from GEO
  - `GPL.txt`: Platform annotation file from GEO
- Output file:
  - `geneMatrix.txt`: Generated gene-level expression matrix

## 3. Input File Format

- **GSE.txt**: Tab-delimited raw expression matrix with:
  - Row 1: Sample headers (automatically simplified)
  - Column 1: Probe IDs
  - Subsequent columns: Expression values

- **GPL.txt**: Tab-delimited platform annotation file with:
  - Probe IDs in first column
  - Gene symbols in user-specified column

## 4. Execution Workflow

1. Place `GSE.txt` and `GPL.txt` in the same directory as the script
2. Run the script:
   ```bash
   perl 1.GEO_annotation_gene_symbol.pl
   ```
3. When prompted, enter the column number containing gene symbols in `GPL.txt`
4. The script automatically:
   - Simplifies sample names (e.g., "GSM1234_treatment" → "GSM1234")
   - Maps probes to gene symbols
   - Averages expression values for probes mapping to same gene
   - Generates output matrix

## 5. Output Files

- **geneMatrix.txt**: Tab-delimited gene expression matrix with:
  - Row 1: Simplified sample headers
  - Column 1: Gene symbols
  - Matrix cells: Averaged expression values

- **Formatting**:
  - One gene per row
  - Multiple probes per gene averaged
  - Numeric values only (non-numeric entries skipped)
  - Original quotes removed