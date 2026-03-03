# Post-processing and Downstream Analyses
This folder contains downstream utility scripts applied after generating the vOTU reference dataset and abundance matrices (CPM/RPK). These steps standardize identifiers, remove technical artifacts (duplicates), and create filtered datasets used in final analyses and plotting.

**This include:**
- Renaming contig/vOTU headers to consistent IDs (e.g., vOTU1, vOTU2, …)
- Filtering vOTUs by length (e.g., ≥10 kb) to build alternative datasets
- Removing duplicated records (by header and/or sequence)
- Subsetting CPM/RPK matrices to a target set of vOTUs (e.g., 10kb-only, high-confidence)

## Note on downstream annotation:
Host prediction and viral annotation tools such as iPHoP (host prediction), TaxMyPhage (taxonomy), Bacphlip (lifestyle), CheckV (quality), and VIBRANT (AMGs) are recommended to be executed after vOTU definition. 

## Example scripts:
- `01_rename_ids_to_vOTU.sh`
- `02_filter_10kb.sh`
- `03_filter_matrix_by_ids.sh`
