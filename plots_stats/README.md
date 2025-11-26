# Plots and Statistical Analysis (R)

This folder contains all scripts and RMarkdown notebooks used for data visualization and statistical analysis of the MAMI phageome dataset.

These analyses are performed after the main phageome processing workflow (mapping, clustering, annotation) and are focused on the interpretation and presentation of results for publication.

## 🧪 Analyses performed

- **Diversity**
  - Alpha diversity (Shannon, observed richness)
  - Beta diversity (Bray-Curtis, NMDS, PERMANOVA)

- **Temporal dynamics**
  - Longitudinal phageome evolution across infant timepoints
  - Comparisons between maternal, infant, and milk samples

- **CPM-based abundance analysis**
  - Heatmaps and clustering of vOTUs
  - Filtering by coverage, length, or taxonomic group

- **Core phageome analysis**
  - Shared and persistent vOTUs across individuals or timepoints
  - Contribution of core vs. transient phageome components

- **Taxonomy**
  - Relative abundance of phage taxa (class, family)
  - Custom color palettes (e.g., Wes Anderson)

- **Phage-host interactions**
  - Integration of iPHoP predictions with vOTU abundance
  - Co-occurrence visualizations of phages and predicted hosts

## 📦 R packages used

Most scripts rely on the following R packages:

- `tidyverse`
- `vegan`
- `ggplot2`
- `pheatmap` or `ComplexHeatmap`
- `reshape2`
- `data.table`
- `ggrepel`
- `patchwork`
- `RColorBrewer`

A script like `install_packages.R` can be added to help install all dependencies.

## 📁 File examples

- `NMDS_Plots_Elena.Rmd`: Ordination plots and PERMANOVA results
- `Heatmap_CPM.Rmd`: Abundance heatmaps of filtered vOTUs
- `Taxonomy_Analysis.Rmd`: Barplots and summaries of viral taxa
- `Core_Phageome_Analysis.Rmd`: Identification and visualization of core vOTUs
- `Host_Phage_Integration.Rmd`: Combining iPHoP host predictions with abundance data

## 🧬 Example usage

To knit an RMarkdown notebook:

```R
rmarkdown::render("NMDS_Plots_Elena.Rmd")
