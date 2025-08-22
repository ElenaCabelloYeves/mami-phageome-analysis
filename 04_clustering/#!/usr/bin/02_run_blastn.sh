#!/usr/bin/env bash
set -euo pipefail

# 02_run_blastn.sh
# Uso: bash 02_run_blastn.sh FINAL_modified_virus3.fna VIRUS_MAMI_db my_blast_MAMI.tsv 24

Q_FASTA="${1:-FINAL_modified_virus3.fna}"
DB_PREFIX="${2:-VIRUS_MAMI_db}"
OUT_TSV="${3:-my_blast_MAMI.tsv}"
THREADS="${4:-24}"

blastn -task megablast \
  -query "$Q_FASTA" \
  -db "$DB_PREFIX" \
  -outfmt '6 std qlen slen' \
  -max_target_seqs 10000 \
  -num_threads "$THREADS" \
  -out "$OUT_TSV"

echo "OK: BLAST TSV -> $OUT_TSV"
