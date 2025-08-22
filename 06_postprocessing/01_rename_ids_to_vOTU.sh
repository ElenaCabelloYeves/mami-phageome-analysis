#!/usr/bin/env bash
set -euo pipefail

# 01_rename_ids_to_vOTU.sh
# Uso:
#   bash 01_rename_ids_to_vOTU.sh \
#       /ruta/vOTUs_reference_dataset.fasta \
#       /ruta/dir_matrices_RPK_CPM \
#       /ruta/salida
#
# Salida:
#   out/votu_map.tsv          (orig_id  vOTU_id  provirus_flag)
#   out/vOTUs_reference_dataset.votu.fasta
#   out/matrices_renamed/*_RPK_CPM.votu.txt

REF_FASTA="${1:?FASTA de referencia requerido}"
MATS_DIR="${2:?Directorio con *_RPK_CPM.txt requerido}"
OUT_DIR="${3:?Directorio de salida requerido}"

mkdir -p "$OUT_DIR"/{matrices_renamed,tmp}

MAP="$OUT_DIR/votu_map.tsv"

# 1) Construir mapa (orden estable por aparición en FASTA)
#   - preserva "|provirus" si aparece en el ID original (o "|p_")
#   - IDs finales tipo: vOTU1  o  vOTU1|provirus
awk -v OFS='\t' '
  BEGIN{count=0}
  /^>/{
    id=$0; sub(/^>/,"",id)
    if(!(id in seen)){
      seen[id]=1; count++
      prov = (id ~ /\|provirus/ || id ~ /\|p_/) ? "yes" : "no"
      votu = "vOTU" count
      if(prov=="yes"){votu=votu"|provirus"}
      print id, votu, prov
    }
  }
' "$REF_FASTA" > "$MAP"

echo "[INFO] Mapa creado -> $MAP (n="$(wc -l < "$MAP")")"

# 2) Renombrar FASTA
awk -v FS='\t' -v OFS='\t' 'NR==FNR{map[$1]=$2; next} 
  /^>/{hdr=$0; sub(/^>/,"",hdr); 
       if(hdr in map){print ">"map[hdr]}
       else{print ">"hdr}
       next}
  {print}
' "$MAP" "$REF_FASTA" > "$OUT_DIR/$(basename "${REF_FASTA%.fasta}").votu.fasta"

echo "[INFO] FASTA renombrado -> $OUT_DIR/$(basename "${REF_FASTA%.fasta}").votu.fasta"

# 3) Renombrar todas las matrices *_RPK_CPM.txt (columna 1 = ID)
shopt -s nullglob
for f in "$MATS_DIR"/*_RPK_CPM.txt; do
  out="$OUT_DIR/matrices_renamed/$(basename "${f%.txt}").votu.txt"
  # conserva cabecera; renombra IDs de la primera columna con el MAP
  awk -v FS='\t' -v OFS='\t' 'NR==FNR{map[$1]=$2; next}
    FNR==1{print; next}
    {
      id=$1
      if(id in map){$1=map[id]}
      print
    }
  ' "$MAP" "$f" > "$out"
  echo "[OK] $(basename "$f") -> $(basename "$out")"
done
shopt -u nullglob

echo "[DONE] Renombrado aplicado a FASTA y matrices."
