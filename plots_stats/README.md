# 📊 Plots & Statistical Analyses (R)

This folder contains the R scripts and notebooks used to generate all figures and statistical results for the MAMI mother–infant phageome study, including comparisons across infant stool time points (1W, 1M, 6M, 12M) and maternal reservoirs (maternal stool and human milk).

These analyses are focused on the interpretation and presentation of results for publication.

These scripts use the output tables provided in the data/ directory.

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

**Alpha Diversity**

- vOTU richness (per sample)
- Shannon diversity (via vegan)
- Longitudinal mixed-effects models

**Beta Diversity**

- Bray–Curtis dissimilarity
- Principal Coordinates Analysis (PCoA)
- PERMANOVA (adonis2) with subject-level stratification
- Dispersion checks (betadisper) to control for heterogeneity effects

**Phage–Bacteria Coordination**

- Mantel correlation (phageome vs bacteriome distance matrices)
- Procrustes alignment tests

**Visualization**

- Alpha diversity panels
- PCoA ordination plots
- Correlation summaries

(Figure 3)

## 4️⃣ Host-Linked Ecological Structuring

**Objective:** Integrate host prediction data to resolve ecological patterns.

- Host predictions from iPHoP (genus/family level)
- Host-associated abundance and richness trajectories across infant development
- Lifestyle composition across hosts: Virulent vs temperate probabilities (BACPHLIP)

**Visualization**

- Stacked host composition bars
- Host-specific trajectories
- Sankey plots

(Figure 4)

## 5️⃣ Drivers of Infant Phageome Assembly
(Feeding vs Perinatal Factors)

**Objective:** Assess environmental and perinatal influences on phageome structuring.

**Longitudinal Mixed-Effects Models**

Assessment of:
- Human milk exposure
- Dietary stage
- Exclusive breastfeeding
- Delivery mode
- Birth environment
- Intrapartum antibiotic exposure

Models included subject identity as a random effect to account for repeated measures.

**Community-Level Effects**

PERMANOVA analyses including:
- Human milk exposure
- Dietary stage
- Delivery mode
- Birth environment

with subject-level stratification where applicable.

**Feature-Level Effects**

- vOTU presence/absence mixed-effects models
- Total viral abundance mixed-effects models
- Genus-level CLR transformations
- MaAsLin2 multivariable models

**Visualization**

- Stratified composition panels
- Forest plots of effect sizes
- Prevalence and abundance trajectories

(Figure 5)

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
- `lme4`
- `lmerTest`
- `emmeans`
- `MaAsLin2`
- `RColorBrewer`

## 📁 File examples

- Fig1-2_Transmission_vOTUs.Rmd: contains UpSet plots of vOTUs in mother–infant gut and milk used to make Figures 1–2
- Fig2_abundance_threshold.Rmd: to plot thresholds for the most dominant vOTUs
- Fig3_Phage-bacteria-alpha_beta_diversity.Rmd
- Fig4_host_predictions.Rmd
- Fig5_longitudinal_models.Rmd
- singletons.Rmd: to calculate number of singletons

