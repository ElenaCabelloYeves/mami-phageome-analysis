#!/usr/bin/env bash
set -euo pipefail

# 03_run_anicalc_aniclust.sh
# Uso: bash 03_run_anicalc_aniclust.sh my_blast_MAMI.tsv FINAL_modified_virus3.fna my_ani_MAMI.tsv my_clusters_MAMI.tsv

BLAST_TSV="${1:-my_blast_MAMI.tsv}"
FNA="${2:-FINAL_modified_virus3.fna}"
ANI_TSV="${3:-my_ani_MAMI.tsv}"
CLUST_TSV="${4:-my_clusters_MAMI.tsv}"

# anicalc
python anicalc.py -i "$BLAST_TSV" -o "$ANI_TSV"

# aniclust (parámetros MIUViG: 95 ANI, 85% AF en target; qcov=0 permite fragmentos)
python aniclust.py \
  --fna "$FNA" \
  --ani "$ANI_TSV" \
  --out "$CLUST_TSV" \
  --min_ani 95 \
  --min_tcov 85 \
  --min_qcov 0

echo "OK: ANI -> $ANI_TSV ; CLUSTERS -> $CLUST_TSV"
