#!/usr/bin/env bash
set -euo pipefail

# 04_extract_representatives.sh
# Uso: bash 04_extract_representatives.sh my_clusters_MAMI.tsv VIRUS_MAMI_db FINAL_modified_virus3.fna vOTUs_reference_dataset.fna
# Toma el primer miembro por cluster como representante.

CLUST_TSV="${1:-my_clusters_MAMI.tsv}"
DB_PREFIX="${2:-VIRUS_MAMI_db}"
FNA="${3:-FINAL_modified_virus3.fna}"
OUT_FASTA="${4:-vOTUs_reference_dataset.fna}"

REPS_TXT="votu_representatives.txt"

# Si el TSV de aniclust tiene formato: cluster_id \t seq_id \t is_rep(0/1) ...,
# coge el primer seq_id por cluster; si trae columna de representante, ajusta awk.
awk -F'\t' '!seen[$1]++ {print $2}' "$CLUST_TSV" > "$REPS_TXT"

# Limpia espacios/CR y filtra líneas vacías
sed -i 's/\r$//' "$REPS_TXT"
awk 'NF>0' "$REPS_TXT" > .tmp && mv .tmp "$REPS_TXT"

echo "Representantes: $(wc -l < "$REPS_TXT")"

# === Método A (robusto): usar seqkit sobre el FASTA original ===
# Requiere que los IDs de REPS_TXT aparezcan literalmente en las cabeceras del FNA.
if command -v seqkit >/dev/null 2>&1; then
  seqkit grep -f "$REPS_TXT" "$FNA" > "$OUT_FASTA"
  echo "OK (seqkit): $OUT_FASTA"
  exit 0
fi

# === Método B (alternativo): blastdbcmd (requiere IDs 1:1 con makeblastdb -parse_seqids) ===
# Si ves 'Skipped QNAME', revisa la sección de troubleshooting de abajo.
blastdbcmd -db "$DB_PREFIX" -entry_batch "$REPS_TXT" -out "$OUT_FASTA"
echo "OK (blastdbcmd): $OUT_FASTA"
