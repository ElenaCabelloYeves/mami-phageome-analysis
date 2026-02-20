# MAMI phageome analysis workflow

## Overview

This repository contains the analysis workflow used to reconstruct and analyze the infant gut phageome from shotgun metagenomic sequencing data of the MAMI cohort.

### Workflow summary

1. **Quality control and trimming**
   Raw reads were quality-checked using FastQC and summarized with MultiQC.

2. **Metagenomic assembly**
   Each sample was assembled independently using SPAdes in metagenomic mode.

3. **Viral sequence detection**
   Viral contigs were identified using geNomad.

4. **vOTU clustering**
   Viral contigs were clustered into non-redundant vOTUs using 95% ANI and 85% alignment fraction thresholds (anicalc/aniclust).

5. **Abundance estimation**
   Reads were mapped back to vOTU representatives using BBMap and normalized as CPM/RPK.

6. **Host prediction and annotation**
   Host assignment was performed using iPHoP and taxonomic annotation using geNomad/taxMyPhage.

7. **Ecological analyses**
   Diversity metrics, ordinations, and statistical analyses were performed in R.

The final curated catalogue of vOTUs is in ENA: PRJEB105288
This repository include all scripts to plot the figures used in the manuscript in plots_stats.
