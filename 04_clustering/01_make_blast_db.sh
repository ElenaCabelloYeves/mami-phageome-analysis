#!/usr/bin/env bash
set -euo pipefail

# 01_make_blast_db.sh
# Uso: bash 01_make_blast_db.sh FINAL_virus_all.fna VIRUS_MAMI_db FINAL_modified_virus3.fna
# - Genera FASTA con headers cortos (<50 chars) y sin espacios
# - Crea makeblastdb con -parse_seqids

IN_FASTA="${1:-FINAL_virus_all.fna}"
DB_PREFIX="${2:-VIRUS_MAMI_db}"
OUT_FASTA="${3:-FINAL_modified_virus3.fna}"

# Acorta cabeceras (ajusta sustituciones si necesitas)
#   >sample -> >s
#   length  -> l
#   provirus-> p
#   cov     -> c
#   NODE    -> N
# Elimina espacios y tabuladores en headers por si acaso.
awk '
  BEGIN{OFS=""}
  /^>/{
    hdr=$0
    gsub(/sample/,"s",hdr)
    gsub(/length/,"l",hdr)
    gsub(/provirus/,"p",hdr)
    gsub(/cov/,"c",hdr)
    gsub(/NODE/,"N",hdr)
    gsub(/[ \t]+/,"_",hdr)
    # recorta a 50 chars (manteniendo el ">")
    if (length(hdr)>50) {hdr=substr(hdr,1,50)}
    print hdr
    next
  }
  {print}
' "$IN_FASTA" > "$OUT_FASTA"

# Comprobar unicidad de IDs
dups=$(grep '^>' "$OUT_FASTA" | sed 's/^>//' | sort | uniq -d | head -1 || true)
if [[ -n "$dups" ]]; then
  echo "ERROR: IDs duplicados tras el acortado: $dups" >&2
  exit 1
fi

# Crear base de datos BLAST
makeblastdb -in "$OUT_FASTA" -dbtype nucl -out "$DB_PREFIX" -parse_seqids

echo "OK: DB=$DB_PREFIX  FASTA=$OUT_FASTA"
