#!/usr/bin/env python3
# 01_mapping_bbmap_automatic.py
# Uso:
#   python 01_mapping_bbmap_automatic.py \
#       --reads /ruta/a/FASTQ_DIR \
#       --ref /ruta/a/vOTUs_reference_dataset.fasta \
#       --out /ruta/a/salida_mapping \
#       --threads 24 \
#       --bbmap bbmap.sh
#
# Acepta .fastq/.fq (comprimidos .gz o no). Empareja por _R1 / _R2.

import argparse
from pathlib import Path
import re
import subprocess
import sys

def find_pairs(reads_dir: Path):
    # patrones R1/R2 típicos
    r1_pat = re.compile(r"(.*)_R1(\.fastq|\.fq)(\.gz)?$", re.IGNORECASE)
    files = list(reads_dir.glob("*"))
    pairs = []
    seen = set()
    for f in files:
        m = r1_pat.match(f.name)
        if not m:
            continue
        base = m.group(1)
        suffix = m.group(2) + (m.group(3) or "")
        r1 = f
        r2 = reads_dir / f"{base}_R2{suffix}"
        if r2.exists():
            sample = Path(base).name  # nombre sin _R1
            if sample in seen:
                continue
            seen.add(sample)
            pairs.append((sample, r1, r2))
    return pairs

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--reads", required=True, help="Directorio con FASTQ/FQ (.gz o no)")
    ap.add_argument("--ref", required=True, help="FASTA de referencia (vOTUs)")
    ap.add_argument("--out", required=True, help="Directorio de salida para covstats")
    ap.add_argument("--threads", type=int, default=24)
    ap.add_argument("--bbmap", default="bbmap.sh", help="Comando bbmap.sh en PATH (o ruta absoluta)")
    ap.add_argument("--extra", default="", help="Flags extra a pasar a BBMap (opcional)")
    args = ap.parse_args()

    reads_dir = Path(args.reads).resolve()
    ref = Path(args.ref).resolve()
    outdir = Path(args.out).resolve()
    outdir.mkdir(parents=True, exist_ok=True)

    if not reads_dir.is_dir():
        sys.exit(f"[ERROR] No existe reads dir: {reads_dir}")
    if not ref.exists():
        sys.exit(f"[ERROR] No existe ref FASTA: {ref}")

    pairs = find_pairs(reads_dir)
    if not pairs:
        sys.exit("[ERROR] No se encontraron pares R1/R2 en el directorio.")

    print(f"Encontrados {len(pairs)} pares. Ref: {ref}")
    for sample, r1, r2 in sorted(pairs):
        covstats = outdir / f"{Path(sample).name}_vVOTUs.txt"
        cmd = [
            args.bbmap,
            f"ref={str(ref)}",
            f"in1={str(r1)}",
            f"in2={str(r2)}",
            f"covstats={str(covstats)}",
            f"threads={args.threads}",
            "ambiguous=toss",   # evitar multi-mapeos contados múltiples
            "minid=0.90",      # opcional: identidad mínima (ajusta según tu criterio)
        ]
        if args.extra.strip():
            cmd.extend(args.extra.strip().split())

        print(f"[BBMap] {sample} -> {covstats.name}")
        # Ejecuta BBMap
        try:
            # subprocess.run maneja espacios y .gz sin problema
            res = subprocess.run(cmd, stdout=subprocess.PIPE, stderr=subprocess.STDOUT, text=True)
            if res.returncode != 0:
                print(f"[WARN] BBMap falló para {sample} (code {res.returncode}). Log:\n{res.stdout}")
            else:
                # Chequeo básico: archivo existe y tiene cabecera de covstats
                if not covstats.exists():
                    print(f"[WARN] No se generó {covstats}")
        except FileNotFoundError:
            sys.exit(f"[ERROR] No se encontró bbmap.sh. Prueba con --bbmap /ruta/a/bbmap.sh")

    print("Listo. Revisa los covstats en:", outdir)

if __name__ == "__main__":
    main()
