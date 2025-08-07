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

To run:
```bash
bash scripts/01_qc/01_fastqc_all.sh
