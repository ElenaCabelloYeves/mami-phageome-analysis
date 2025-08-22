#!/usr/bin/env bash
set -euo pipefail

# 01_rename_headers.sh
# Añade "sample_<MUESTRA>_" al inicio de cada cabecera FASTA (líneas que empiezan por '>').
# Por defecto procesa MAMI_*_contigs.fasta en el directorio actual y escribe *_headers.fasta en out/.
# Uso:
#   ./01_rename_headers.sh [-i INPUT_DIR] [-o OUTPUT_DIR] [-g GLOB]
# Ejemplo:
#   ./01_rename_headers.sh -i /nas02/ucm/elena/MAMI_ENA/contigs/contigs_FINAL

INPUT_DIR="."
OUTPUT_DIR="./out"
GLOB="MAMI_*_contigs.fasta"

while getopts ":i:o:g:" opt; do
  case $opt in
    i) INPUT_DIR="$OPTARG" ;;
    o) OUTPUT_DIR="$OPTARG" ;;
    g) GLOB="$OPTARG" ;;
    *) echo "Uso: $0 [-i INPUT_DIR] [-o OUTPUT_DIR] [-g GLOB]" >&2; exit 1 ;;
  end esac
done

mkdir -p "$OUTPUT_DIR"

shopt -s nullglob
files=( "$INPUT_DIR"/$GLOB )
shopt -u nullglob

if [[ ${#files[@]} -eq 0 ]]; then
  echo "No se encontraron archivos con patrón '$GLOB' en '$INPUT_DIR'." >&2
  exit 1
fi

for file in "${files[@]}"; do
  fname=$(basename "$file")
  base_name=${fname%_contigs.fasta}
  out="${OUTPUT_DIR}/${base_name}_headers.fasta"

  echo "Procesando: $fname  ->  $(basename "$out")"
  # Prefija solo las líneas de cabecera
  sed "/^>/ s/>/>sample_${base_name}_/" "$file" > "$out"
done

echo "Listo. Archivos renombrados en: $OUTPUT_DIR"
