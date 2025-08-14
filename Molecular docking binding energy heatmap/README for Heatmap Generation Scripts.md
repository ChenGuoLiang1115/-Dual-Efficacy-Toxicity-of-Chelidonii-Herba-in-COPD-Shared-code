# Heatmap Generation for Molecular Docking Scores

## 1. Project Overview
These R scripts generate publication-ready heatmaps to visualize **molecular docking scores** between herbal compounds and disease targets. Each script is customized for specific herb–disease pairs (e.g., *Chelidonium–COPD* or *Chelidonium–Drug_Induced_Liver_Injury*), creating clustered heatmaps with **numerical docking scores** displayed in matrix cells.

## 2. File Structure
The repository contains multiple heatmap scripts following the naming convention:

```
22.heatmap_script_(Herb-Disease).R
```

Each script requires one input file: `biodate.txt` (docking score matrix). Examples:
- `22.heatmap_script_(Chelidonium-COPD).R`
- `22.heatmap_script_(Chelidonium-Drug_Induced_Liver_Injury).R`

Output files are **PDF heatmaps** named `热图.pdf` by default.

## 3. Input File Format
The `biodate.txt` file must be tab-delimited with:
- **First row**: Column headers (disease target names)  
- **First column**: Row names (herbal compound names)  
- **Matrix cells**: Numerical docking scores (e.g., `Compound1  -7.2  -6.8  -5.5`)

## 4. Execution Workflow
1. Create a directory containing the script and `biodate.txt`
2. Edit two lines in the script:
   - **Line 2**: `setwd("path/to/your/folder")`
   - **Line 12**: `pdf(file = "custom_name.pdf")` *(optional)*
3. Run the script via command line:
   ```bash
   Rscript 22.heatmap_script_(Herb-Disease).R
   ```

## 5. Output Files
Each script generates a PDF heatmap with:
- **Non-clustered rows/columns** (`cluster_cols = F`, `cluster_rows = F`)
- **Numerical docking scores** displayed in black (`display_numbers = T`)
- **Fixed cell dimensions** (40×20 pixels)
- **Sans-serif font** throughout (`fontfamily = "sans"`)
- **White cell borders** and standardized font sizes:
  - Row labels: 10
  - Column labels: 10
  - Numbers: 10