# MAMI phageome analysis pipeline

This repository contains the complete pipeline used in the analysis of the infant-maternal phageome in the MAMI cohort, as described in [Paper title].

### Pipeline overview:
1. Quality control and trimming
2. De novo assembly (SPAdes)
3. Virus detection (geNomad)
4. Clustering and vOTU definition (ANI-based)
5. Mapping and quantification (BBMap, CPM)
6. Functional and taxonomic annotation (CheckV, iPHoP, Taxmyphage, BACPHLIP)

### Reproducibility:
All steps are modular, documented, and compatible with Linux environments. Conda environment files are provided.

### 🔹 Folder structure

```md
## 📁 Folder Structure

phageome_mami_pipeline/
├── scripts/ # All pipeline scripts organized by step
│ ├── 01_qc/ # Quality control (FastQC, MultiQC)
│ ├── 02_assembly/ # SPAdes assembly and contig organization
│ ├── 03_genomad/ # Viral detection with geNomad
│ ├── 04_clustering/ # Clustering of vOTUs based on ANI
│ ├── 05_mapping/ # Read mapping and CPM calculation
│ ├── 06_postprocessing/ # Renaming, filtering, and matrix processing
│ ├── 07_annotation/ # Annotation tools: CheckV, iPHoP, BACPHLIP, Taxmyphage
│ └── 08_final_outputs/ # Organization of final results for analysis
├── envs/ # Conda environment files
├── data/ # Example data (non-sensitive)
├── docs/ # Documentation or diagrams
├── output/ # Final results (CPM matrices, etc.)
└── plots_stats/ # R scripts and notebooks for stats and plots
