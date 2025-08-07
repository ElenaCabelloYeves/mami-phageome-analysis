# Assembly

This folder includes scripts for de novo assembly using SPAdes and organizing the resulting contigs.

## Scripts:
- `01_spades_assembly.sh`: Automatically runs SPAdes for all paired-end read files.
- `02_rename_contigs.py`: Renames `contigs.fasta` files based on sample names.
- `03_collect_contigs.py`: Moves all contig FASTA files to a central `contigs/` directory for downstream processing.
