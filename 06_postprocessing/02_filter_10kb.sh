#!/usr/bin/env bash
set -euo pipefail

# 02_filter_10kb.sh
# Uso:
#   bash 02_filter_10kb.sh \
#       /ruta/vOTUs_reference_dataset.votu.fasta \
#       /ruta/dir_matrices_votu \
#       /ruta/salida_ge10kb
#
# Requisitos: seqkit (para filtrar FASTA por longitud). Si no está, comenta la parte FASTA.

REF_FASTA_VOTU="${1:?FASTA renombrado requerido}"
MATS_VOTU_DIR="${2:?Dir con *_RPK_CPM.votu.txt requerido}"
OUT_DIR="${3:?Directorio de salida requerido}"

mkdir -p "$OUT_DIR"/matrices_ge10kb

# 1) FASTA ≥10 kb (si tienes seqkit)
if command -v seqkit >/dev/null 2>&1; then
  seqkit seq -m 10000 "$REF_FASTA_VOTU" > "$OUT_DIR/$(basename "${REF_FASTA_VOTU%.fasta}").ge10kb.fasta"
  echo "[INFO] FASTA ≥10kb -> $OUT_DIR/$(basename "${REF_FASTA_VOTU%.fasta}").ge10kb.fasta"
else
  echo "[WARN] seqkit no disponible. Salto filtrado FASTA."
fi

# 2) Filtrar matrices por Length ≥10000 (columna 'Length')
shopt -s nullglob
for f in "$MATS_VOTU_DIR"/*_RPK_CPM.votu.txt; do
  out="$OUT_DIR/matrices_ge10kb/$(basename "${f%.txt}").ge10kb.txt"
  awk -v FS='\t' -v OFS='\t' '
    NR==1{for(i=1;i<=NF;i++){h[$i]=i}; print; next}
    {
      L = $(h["Length"])+0
      if(L>=10000){print}
    }
  ' "$f" > "$out"
  echo "[OK] $(base
