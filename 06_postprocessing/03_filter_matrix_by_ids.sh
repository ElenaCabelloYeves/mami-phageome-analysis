#!/usr/bin/env bash
set -euo pipefail

# 03_filter_matrix_by_ids.sh
# Uso:
#   bash 03_filter_matrix_by_ids.sh /ruta/dir_matrices "*.votu.txt" ids_lista.txt /ruta/salida_subsets
#
# ids_lista.txt: una ID por línea (debe coincidir con la 1ª columna).
# Funciona con matrices renombradas o ge10kb (elige patrón adecuado).

MATS_DIR="${1:?Dir matrices}"
GLOB="${2:-*_RPK_CPM.votu.txt}"
IDS_FILE="${3:?Lista de IDs}"
OUT_DIR="${4:?Salida}"

mkdir -p "$OUT_DIR"

# Cargar IDs en un awk array rápido
shopt -s nullglob
for f in "$MATS_DIR"/$GLOB; do
  base=$(basename "$f")
  out="$OUT_DIR/${base%.txt}.subset.txt"
  awk -v FS='\t' -v OFS='\t' 'BEGIN{
      while((getline line < ids)>0){gsub(/\r$/,"",line); if(line!="") keep[line]=1}
      close(ids)
    }
    NR==1{print; next}
    {
      id=$1
      if(id in keep){print}
    }
  ' ids="$IDS_FILE" "$f" > "$out"
  echo "[OK] $base -> $(basename "$out")"
done
shopt -u nullglob

echo "[DONE] Subsets por lista de IDs."
