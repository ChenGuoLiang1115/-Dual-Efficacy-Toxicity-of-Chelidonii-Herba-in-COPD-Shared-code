# Project Overview

This R script visualizes immune cell infiltration results from CIBERSORT analysis. It generates two publication-ready plots: a stacked histogram showing relative proportions of immune cells across samples, and boxplots comparing immune cell fractions between control and treatment groups, including statistical significance indicators.

## File Structure

### Core Component:
- `4.immune_cell_visualization.R`: Main visualization script

### Required Input:
- `CIBERSORT-Results.txt`: Output from CIBERSORT analysis

### Output Files:
- `barplot.pdf`: Stacked histogram
- `immune.diff.pdf`: Comparative boxplots

## Input File Format

### `CIBERSORT-Results.txt`
- Tab-delimited file with:
  - Row names: Sample IDs containing "_Control" or "_Treat" identifiers
  - Columns 1-22: Immune cell type proportions
  
Example format:

```
text
GSM1234_Control  B.cells.naive  0.05  T.cells.CD8  0.12  ...  
GSM5678_Treat    B.cells.naive  0.08  T.cells.CD8  0.18  ...
```


## Execution Workflow

1. Install required packages:
    ```r
    install.packages(c("reshape2", "ggpubr", "corrplot"))
    ```
2. Set working directory in script (line 10):
    ```r
    setwd("path/to/your/data")
    ```
3. Run script:
    ```r
    source("4.immune_cell_visualization.R")
    ```
4. The script automatically:
   - Groups samples by "_Control" and "_Treat" identifiers.
   - Generates visualization outputs in current directory.

## Output Files

### `barplot.pdf`
- Stacked histogram showing:
  - X-axis: Samples grouped by condition
  - Y-axis: Relative percentage of immune cells (sum to 100%)
  - Color-coded cell types with legend
  - Control (blue) vs. treatment (red) group labels

### `immune.diff.pdf`
- Boxplot comparison featuring:
  - X-axis: Immune cell types
  - Y-axis: Proportion values
  - Side-by-side boxes for control/treatment groups
  - Statistical significance markers (***p<0.001, **p<0.01, *p<0.05)
  - Notched boxes showing median confidence intervals
  - Color scheme: Control=#0088FF (blue), Treatment=#FF5555 (red)