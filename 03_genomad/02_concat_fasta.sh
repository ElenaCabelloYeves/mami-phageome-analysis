#!/usr/bin/env bash
set -euo pipefail

# 02_concat_fasta.sh
# Concatena FASTA renombrados en un único archivo, en orden alfanumérico.
# Uso:
#   ./02_concat_fasta.sh [-i INPUT_DIR] [-g GLOB] [-o OUTPUT_FASTA]
# Ejemplo:
#   ./02_concat_fasta.sh -i ./out -o contigs_MAMI_final.fasta

INPUT_DIR="./out"
GLOB="*_headers.fasta"
OUTPUT_FASTA="contigs_MAMI_final.fasta"

while getopts ":i:g:o:" opt; do
  case $opt in
    i) INPUT_DIR="$OPTARG" ;;
    g) GLOB="$OPTARG" ;;
    o) OUTPUT_FASTA="$OPTARG" ;;
    *) echo "Uso: $0 [-i INPUT_DIR] [-g GLOB] [-o OUTPUT_FASTA]" >&2; exit 1 ;;
  end esac
done

shopt -s nullglob
mapfile -t files < <(ls -1 "$INPUT_DIR"/$GLOB 2>/dev/null | sort)
shopt -u nullglob

if [[ ${#files[@]} -eq 0 ]]; then
  echo "No se encontraron archivos con patrón '$GLOB' en '$INPUT_DIR'." >&2
  exit 1
fi

echo "Concatenando ${#files[@]} archivos -> $OUTPUT_FASTA"
cat "${files[@]}" > "$OUTPUT_FASTA"

# Comprobación rápida de número de secuencias
nseq=$(grep -c '^>' "$OUTPUT_FASTA" || true)
echo "OK. Archivo final: $OUTPUT_FASTA (secuencias: $nseq)"
