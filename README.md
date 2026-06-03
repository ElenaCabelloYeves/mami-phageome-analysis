# Mother–Infant Gut and Milk Phageomes Metagenomic Workflow (MAMI Cohort)

## ✨ Overview ✨

This repository contains the analysis workflow used to reconstruct and analyze the infant gut phageome from shotgun metagenomic sequencing data of the MAMI cohort.

The code accompanies the manuscript:

"Early-life dynamics of the infant gut phageome are associated with breastfeeding and maternal contributions"

Figure generation and statistical analyses are located in the plots_stats/ directory.

## Dataset description

This study analyzes assembled viral contigs (vOTUs) derived from shotgun metagenomic sequencing of the MAMI mother–infant cohort.

Raw reads from 182 samples were assembled independently per sample. Viral sequences ≥10 kb were identified using geNomad and clustered into non-redundant viral populations (vOTUs) using:

- ≥95% average nucleotide identity (ANI)

- ≥85% alignment fraction (AF)

Viral abundances were estimated by mapping the original reads back to the curated contigs and calculating CPM and RPK values.

This dataset corresponds to the final vOTU catalogue analyzed in the associated manuscript.

## Reproducing figures

1. Download/clone this repository.
2. Open any .Rmd file in plots_stats/ and click Knit in RStudio.
3. The scripts use processed inputs in the data/ directory (no raw reads required).

**Input files:**

- results_with_metadata.csv: main analysis table containing vOTU abundances (CPM/RPK), sample metadata (mother/infant, body site, timepoint), viral annotations, and predicted bacterial hosts. 

- mmc3.xlsx: genus-level bacterial relative abundance table used for comparisons between bacterial communities and the phageome.

Raw sequencing data are publicly available at ENA (PRJEB74322; curated vOTU catalogue: PRJEB105288).

## Workflow summary 

1. **Quality control and trimming**
   Raw reads were quality-checked using FastQC and summarized with MultiQC. Metagenomic assembly Each sample was assembled independently using SPAdes in metagenomic mode.

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


## **Data availability**

The final curated catalogue of viral operational taxonomic units (vOTUs) is available at the European Nucleotide Archive (ENA):

ENA Project accession: **PRJEB105288**

Raw sequencing reads from the MAMI cohort (182 samples) are available at:

ENA Project accession: **PRJEB74322**
