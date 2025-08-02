# README for Core Target Screening Scripts

## 1. Project Overview

This repository provides R scripts for identifying core targets in network pharmacology studies using a stepwise median-based filtering approach. The scripts sequentially filter genes/proteins that score above the median for all specified conditions across three rounds of screening, resulting in a refined set of high-confidence core targets.

## 2. File Structure

Three scripts execute the filtering pipeline:

- `11.1.core_target_screening.R` processes `score1.txt` to generate `score2.txt` (filtered scores) and `score2.gene11.txt` (genes meeting all first-round criteria).
- `11.2.core_target_screening.R` processes `score2.txt` to generate `score3.txt` and `score3.gene11.txt`.
- `11.3.core_target_screening.R` processes `score3.txt` to produce final outputs `score4.txt` and `score4.gene11.txt`.

## 3. Input File Format

Input files must be tab-delimited text files (`.txt`) with:

- **Row 1**: Header containing condition names
- **Column 1**: Gene symbols (row names)
- **Subsequent columns**: Numerical scores (e.g., `TP53 0.85 1.2`)

## 4. Execution Workflow

1. Prepare directories:
   - `filter1/` (contains `11.1.*.R` and `score1.txt`)
   - `filter2/` (contains `11.2.*.R` and `score2.txt`)
   - `filter3/` (contains `11.3.*.R` and `score3.txt`)

2. Run sequentially:
   - Execute `Rscript 11.1.core_target_screening.R` in `filter1/`
   - Copy `filter1/score2.txt` to `filter2/`, then run `11.2.*.R`
   - Copy `filter2/score3.txt` to `filter3/`, then run `11.3.*.R`

## 5. Output Files

Each script generates two outputs:

- `score[X].txt`: Tab-delimited file with gene names and filtered scores for downstream analysis.
- `score[X].gene11.txt`: List of core gene symbols meeting all criteria (one gene per line).
