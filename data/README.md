This folder contains the processed tables required to reproduce the analyses and figures in this repository.

## Files

### `mmc3.xlsx`

Bacterial taxonomic relative abundance table from the MAMI cohort, originally generated for the previous study published in Cell Host & Microbe. The file contains genus-level bacterial composition per sample and is used here to compare bacterial communities with the phageome and host predictions.

### `results_with_metadata.csv`

Main viral abundance table used throughout this repository.

It includes:

- vOTU abundance estimates for detected vOTUs only
- CPM and RPK values
- sample metadata
- viral annotations and host predictions

This table contains only detected vOTUs (`CPM > 0`) and is mainly used for abundance-based analyses, descriptive summaries, overlaps, and figure generation. It contains 21,567 detected sample–vOTU observations across 171 samples and includes all 6,248 vOTUs identified in the study.

### `results_with_metadata2.csv`

Complete viral presence/absence and abundance table used for longitudinal mixed-effects models.

It includes:

- all sample–vOTU combinations
- detected and non-detected vOTUs
- zero-filled CPM and RPK values
- sample metadata
- viral annotations and host predictions

This table contains 1,133,745 sample–vOTU observations across 182 samples, including 1,112,178 observations with `CPM = 0`, and includes the same 6,248 vOTUs as `results_with_metadata.csv`.

This table is required for binomial mixed-effects models because it retains both presences and absences, allowing vOTU detection to be modeled as:

```r
presence = if_else(CPM > 0, 1L, 0L)

```r
presence = if_else(CPM > 0, 1L, 0L)
```

## Genomic and metagenomic data

Raw sequencing reads are not included in this repository and are publicly available at the European Nucleotide Archive (ENA):

Raw reads (182 samples): PRJEB74322

New crated viral catalogue (vOTUs): PRJEB105288
