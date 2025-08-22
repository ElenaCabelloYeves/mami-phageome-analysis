#!/usr/bin/env python3
# 02_rename_contigs.py
# Uso: python 02_rename_contigs.py /path/base_dir [--copy]
# Ejemplo:
#   python 02_rename_contigs.py /nas02/ucm/elena/MAMI_ENA
#   python 02_rename_contigs.py /nas02/ucm/elena/MAMI_ENA --copy

import argparse
import os
import shutil
from pathlib import Path

def main():
    p = argparse.ArgumentParser()
    p.add_argument("base_dir", help="Directorio base que contiene *_output/")
    p.add_argument("--copy", action="store_true", help="Copiar en lugar de mover")
    args = p.parse_args()

    base = Path(args.base_dir).resolve()
    assert base.is_dir(), f"No existe: {base}"

    n_ok = 0
    for item in base.iterdir():
        if item.is_dir() and item.name.endswith("_output"):
            sample = item.name.replace("_output", "")
            contigs = item / "contigs.fasta"
            if contigs.exists():
                dest = base / f"{sample}.fasta"
                if args.copy:
                    shutil.copy2(contigs, dest)
                else:
                    shutil.move(str(contigs), dest)
                print(f"{'Copiado' if args.copy else 'Movido'}: {contigs} -> {dest}")
                n_ok += 1
            else:
                print(f"Sin contigs.fasta en {item}")
    print(f"Listo. Archivos procesados: {n_ok}")

if __name__ == "__main__":
    main()
