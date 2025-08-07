# Viral Detection with geNomad

Scripts for viral genome detection and classification using [geNomad](https://genomad.readthedocs.io/).

## Scripts:
- `01_rename_headers.sh`: Adds sample names as prefixes to contig headers.
- `02_concat_fasta.sh`: Concatenates all renamed FASTA files into one.
- `03_run_genomad.sh`: Runs the `genomad end-to-end` pipeline using the concatenated contigs.

Outputs are used for vOTU clustering and host prediction.
