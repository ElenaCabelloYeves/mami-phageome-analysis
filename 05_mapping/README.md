# Mapping and Quantification

Scripts for mapping sequencing reads to reference vOTUs and calculating read-based abundance metrics (RPK and CPM).

## Scripts:
- `01_mapping_bbmap_automatic.py`: Maps paired-end reads using `BBMap` and extracts `covstats`.
- `02_rpk_cpm_calculation.py`: Calculates RPK and CPM from covstats, applying coverage filters (<70% or <1x → CPM=0).
