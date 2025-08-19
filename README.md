[![DOI](https://zenodo.org/badge/1029133350.svg)](https://doi.org/10.5281/zenodo.16723680) [![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](./LICENSE)
# Project Overview
This repository provides an end-to-end workflow for network pharmacology and immune microenvironment analysis. The pipeline integrates drug target screening, gene expression processing, immune landscape quantification, correlation analysis, and specialized tools for FDR correction, molecular docking analysis, and heatmap visualization. It transforms raw pharmacological and omics data into publication-ready outputs.

# Core Modules

## Module 1: Core Target Screening
Implements stepwise median filtering to identify high-confidence drug targets.

- **Scripts**  
  - `11.1-core_target_screening.R`  
  - `11.2-core_target_screening.R`  
  - `11.3-core_target_screening.R`  

- **Input**  
  - Pharmacological score matrix (`score1.txt`)  

- **Process**  
  - **Stage 1**: Filters genes scoring above median, outputs `score1.gene11.txt` and `score2.txt`  
  - **Stage 2**: Repeats median filtering, outputs `score2.gene11.txt` and `score3.txt`  
  - **Stage 3**: Final filtering, outputs high-confidence targets (`score3.gene11.txt`)  

- **Execution**  
  Run scripts sequentially  

---

## Module 2: GEO Data Processing
Converts and normalizes microarray data for downstream analysis.

- **Scripts**  
  - `1.GEO_annotation_gene_symbol.pl` (Perl)  
  - `2.add_sample_type_correction.R` (R)  

- **Input**  
  - Raw expression data  
  - Sample IDs (`sample1.txt`, `sample2.txt`)  

- **Process**  
  - Step 1: Probe-to-gene conversion (averages multi-probe measurements)  
  - Step 2: Log2 transformation and sample annotation  
  - Step 3: Outputs analysis-ready expression matrices  

---

## Module 3: Immune Landscape Analysis
Quantifies immune cell infiltration using CIBERSORT deconvolution.

- **Scripts**  
  - `3.GEOimmune.CIBERSORT.R`  
  - `3.GEOimmune.run.R`  
  - `4.immune_cell_visualization.R`  

- **Input**  
  - Normalized expression matrix (from Module 2)  

- **Process**  
  - Step 1: Cell proportion estimation with LM22 signatures (1000 permutations)  
  - Step 2: Generates stacked histograms of immune cell distributions  
  - Step 3: Produces comparative boxplots (control vs treatment)  
  - Step 4: Creates statistical validation reports  

---

## Module 4: Gene-Immune Correlation
Identifies significant associations between target genes and immune cells.

- **Script**  
  - `5.immune_cell_gene_correlation.R`  

- **Input**  
  - Immune proportions (Module 3)  
  - Expression matrix (Module 2)  
  - Target gene list (Module 1)  

- **Output**  
  - Multi-layer network visualization with line color indicating correlation direction and line thickness indicating correlation strength  

---

# Specialized Tools

## FDR Correction for Enrichment Data
Automated batch processing of enrichment results.

- **Input**  
  - Excel files with raw p-values (BP/CC/MF/KEGG)  

- **Features**  
  - Benjamini-Hochberg correction (FDR < 0.01)  
  - Intelligent p-value column detection  
  - Automatic filtering of invalid values  

- **Outputs**  
  - Excel workbook with three sheets:  
    - Full FDR-corrected results  
    - Significant findings (FDR < 0.01)  
    - Documentation  
  - FDR correction profile plot (prefix: `_FDR校正图`)  
  - Batch summary report  

- **Naming Convention**  
  - `[InputName]_FDR校正结果.xlsx`  

---

## Molecular Docking Processor
Transforms AutoDock Vina outputs into structured results.

- **Input**  
  - `log.txt` (Top 20 docking modes)  

- **Outputs**  
  - `Supplementary_Table_S1.csv`: Binding parameters  
  - `Supplementary_Table_S2.csv`: Statistical summary (mean energy, SD, CIs)  
  - `docking_energy_distribution.png`: Histogram with annotated statistics  

- **Metrics**  
  - Binding affinity, RMSD values, confidence intervals  

---

## Herb-Disease Heatmap Generator
Creates publication-ready docking score visualizations.

- **Scripts**  
  - `22.heatmap_script_(Herb-Disease).R` (e.g., `Chelidonium-COPD`)  

- **Input**  
  - Tab-delimited `biodate.txt` matrix  
  - Rows: Herbal compounds  
  - Columns: Disease targets  
  - Cells: Docking scores  

- **Output**  
  - PDF heatmap (`热图.pdf` by default)  
  - Non-clustered rows/columns, black numerical scores, fixed cell dimensions (40×20 px), sans-serif fonts, white borders  

---

# Execution Workflow
1. **Start with GEO Processing**  
   - `1.GEO_annotation_gene_symbol.pl` → `2.add_sample_type_correction.R`  

2. **Run Immune Analysis**  
   - `3.GEOimmune.run.R` → `4.immune_cell_visualization.R`  

3. **Screen Targets (Parallel)**  
   - `11.1-core_target_screening.R` → `11.2-core_target_screening.R` → `11.3-core_target_screening.R`  

4. **Correlation Analysis**  
   - `5.immune_cell_gene_correlation.R` (Uses Modules 2+3 outputs)  

5. **Specialized Tools (Independent)**  
   - FDR correction  
   - Docking log processing  
   - Heatmap generation  

**Note**: All scripts include header comments specifying working directories and input requirements. Set paths using `setwd()` before execution.



