# vOTU Clustering (ANI-based)

Scripts for identifying representative viral Operational Taxonomic Units (vOTUs) using pairwise Average Nucleotide Identity (ANI) and clustering.

## Steps:
1. Create a BLAST database.
2. Run all-vs-all `blastn`.
3. Calculate ANI with `anicalc.py`.
4. Cluster sequences with `aniclust.py`.

## Scripts:
- `01_make_blast_db.sh`
- `02_run_blastn.sh`
- `03_run_anicalc_aniclust.sh`
- `04_extract_representatives.sh`
