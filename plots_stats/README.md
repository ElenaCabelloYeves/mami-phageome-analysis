# 📊 Plots & Statistical Analyses (R)

This folder contains all scripts and RMarkdown notebooks used for data visualization and statistical analysis of the MAMI phageome dataset.

These analyses are performed after the main phageome processing workflow (mapping, clustering, annotation) and are focused on the interpretation and presentation of results for publication.

These scripts use the output tables provided in the data/ directory.

## 🧪 Analyses performed

This repository contains the R scripts and notebooks used to generate all figures and statistical results for the MAMI mother–infant phageome study, including comparisons across infant stool time points (1W, 1M, 6M, 12M) and maternal reservoirs (maternal stool and human milk).

All analyses are performed downstream of the core phageome workflow (vOTU catalog generation, read mapping, CPM computation, and annotation).


## 1️⃣ Catalogue Structure & Maternal Sharing

**Objective:** Characterize the global structure of the infant phageome and its overlap with maternal reservoirs.

Shared and unique vOTUs across ecosystems:

- Infant stool
- Maternal stool
- Human milk

**Time-resolved sharing across infant developmental stages**

- Overlap statistics: Jaccard / Sørensen similarity
- Dyad-level sharing
- Stratification by delivery mode 
- Mother-Infant UpSet plots
- 
(Figure 1)

## 2️⃣ Dominance, Persistence & Core Definitions

**Objective:** Identify dominant and persistent components of the infant phageome.

- Cumulative abundance analyses (CPM-based)
- Definition of: vOTUs explaining 50%, 80%, 85%, 90%, 95%, and 99% of total abundance
- The **Dominant Phageome Group** (minimal set explaining ≥85% abundance)
- **Persistent High-Abundance (PHA)** core across all infant time points

Additional analyses:

- Maternal-source overlap of dominant/core vOTUs
- Temporal stability of dominant components

**Visualization**

- Cumulative abundance curves
- UpSet plots of dominant/core sets
- Prevalence panels
(Figure 2)

## 3️⃣ Diversity & Community Structure

**Objective:** Quantify phageome diversity and ecological structuring across development.

# Alpha Diversity

- vOTU richness (per sample)
- Shannon diversity (via vegan)

# Beta Diversity

- Bray–Curtis dissimilarity
- Principal Coordinates Analysis (PCoA)
- PERMANOVA (adonis2)
- Dispersion checks (betadisper) to control for heterogeneity effects

# Phage–Bacteria Coordination

- Mantel correlation (phageome vs bacteriome distance matrices)
- Procrustes alignment tests

# Visualization

- Alpha diversity panels
- PCoA ordination plots
- Correlation summaries
(Figure 3)

## 4️⃣ Host-Linked Ecological Structuring

**Objective:** Integrate host prediction data to resolve ecological patterns.

- Host predictions from iPHoP (genus/family level)
- Host-associated abundance and richness trajectories across infant development
- Phage-to-bacteria ratios per predicted host genus (stool samples)
- Lifestyle composition across hosts: Virulent vs temperate probabilities (BACPHLIP)

**Visualization**

- Stacked host composition bars
- Host-specific abundance ratios
- Sankey plots
(Figure 4)

## 5️⃣ Drivers of Infant Phageome Assembly
(Feeding vs Perinatal Factors)

**Objective:** Assess environmental and perinatal influences on phageome structuring.

# Community-Level Effects

PERMANOVA by time point for:
- Feeding mode (breastfed / partial / none)
- Human milk exposure at sampling
- Dietary stage

Delivery-related variables:
- Mode of birth
- Place of birth

Inclusion of covariates where applicable

# Feature-Level Effects

Genus-level CLR transformations with Linear Mixed Models (LMM)
MaAsLin2 multivariable models

**Visualization**

- Stratified composition panels
- Forest plots of effect sizes
- Prevalence and abundance trajectories
(Figure 5)

## 6️⃣ Supplementary & Robustness Analyses

**Objective:** Ensure robustness and reproducibility of findings.

Sensitivity to filtering thresholds:
- Coverage
- Depth
- CPM presence definitions

Alternative normalization strategies (when applicable)
Alternative distance metrics (optional)
Additional stratifications
Supplemental figures (Figures S1–Sx)

## 🧪 Reproducibility Notes

- All analyses use CPM-normalized abundance matrices.
- Presence is defined as CPM > 0 unless otherwise stated.
- Statistical tests account for repeated measures when required.
- Scripts are organized to mirror manuscript figure structure.

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

- `Taxonomy_Analysis.Rmd`: Barplots and summaries of viral taxa

