[![DOI](https://zenodo.org/badge/1029133350.svg)](https://doi.org/10.5281/zenodo.16723680)  [![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](./LICENSE)
# Project Scope

This repository provides an integrated bioinformatics pipeline for network pharmacology and immune microenvironment analysis. It encompasses four core modules:

- Stepwise median-based filtering to identify high-confidence drug targets  
- GEO microarray processing including probe-to-gene conversion and sample normalization  
- Immune landscape quantification using CIBERSORT deconvolution with visualization  
- Correlation analysis between immune cells and co-expressed genes  

The workflow processes raw pharmacological scores and gene expression data into publication-ready outputs.

## Module 1: Core Target Screening

Three R scripts (`11.1-11.3.core_target_screening.R`) implement sequential median filtering to identify genes scoring above median values across all conditions. Starting with `score1.txt`, each stage outputs filtered gene lists (`score[X].gene11.txt`) and score matrices for subsequent steps, culminating in high-confidence targets after three filtering rounds.

## Module 2: GEO Data Processing

A Perl script (`1.GEO_annotation_gene_symbol.pl`) first converts probe-level data to gene expression matrices by averaging multi-probe measurements, requiring user-specified gene symbol columns.  
The R script (`2.add_sample_type_correction.R`) then normalizes data, applies log2 transformation, and annotates samples using control/treatment IDs from `sample1.txt`/`sample2.txt`, outputting analysis-ready matrices.

## Module 3: Immune Landscape Analysis

The CIBERSORT algorithm (`3.GEOimmune.CIBERSORT.R`) deconvolutes immune cell proportions using LM22 signatures.  
The execution script (`3.GEOimmune.run.R`) processes normalized expression data with 1000 permutations for statistical validation.  
Visualization scripts (`4.immune_cell_visualization.R`) generate stacked histograms and comparative boxplots showing differential infiltration between experimental groups.

## Module 4: Gene-Immune Correlation

An R script (`5.immune_cell_gene_correlation.R`) analyzes Spearman correlations between target genes and immune cells in treatment groups.  
It integrates expression data, immune proportions, and gene lists to produce a multi-layer visualization highlighting significant associations through line color (direction) and thickness (strength).

## Execution Sequence

Begin with **Module 2** for GEO data processing, followed by **Module 3** for immune analysis.  
**Module 1** operates independently on pharmacological scores.  
**Module 4** requires outputs from Modules 2 and 3.  
All scripts specify working directories and input requirements in header comments.

