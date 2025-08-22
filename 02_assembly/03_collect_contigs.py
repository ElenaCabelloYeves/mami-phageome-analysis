#!/usr/bin/env python3
# 03_collect_contigs.py
# Uso: python 03_collect_contigs.py /path/base_dir [/path/dest_dir] [--copy]
# Ejemplo:
#   python 03_collect_contigs.py /nas02/ucm/elena/MAMI_ENA /nas02/ucm/elena/MAMI_ENA/contigs
#   python 03_collect_contigs.py /nas02/ucm/elena/MAMI_ENA --copy

import argparse
import os
import shutil
from pathlib import Path
import re

def main():
    p = argparse.ArgumentParser()
    p.add_argument("base_dir", help="Directorio base con los <sample>.fasta")
    p.add_argument("dest_dir", nargs="?", default=None, help="Destino para los contigs (por defecto: base_dir/contigs)")
    p.add_argument("--copy", action="store_true", help="Copiar en lugar de mover")
    p.add_argument("--prefix", default="MAMI", help="Prefijo de muestra (default: MAMI)")
    args = p.parse_args()

    base = Path(args.base_dir).resolve()
    dest = Path(args.dest_dir).resolve() if args.dest_dir else (base / "contigs")
    dest.mkdir(parents=True, exist_ok=True)

    # patrón simple: MAMI*.fasta (ajustable)
    pattern = re.compile(rf"^{re.escape(args.prefix)}.*\.fasta$", re.IGNORECASE)

    n_ok = 0
    for f in base.iterdir():
        if f.is_file() and pattern.match(f.name):
            target = dest / f.name
            if args.copy:
                shutil.copy2(f, target)
            else:
                shutil.move(str(f), target)
            print(f"{'Copiado' if args.copy else 'Movido'}: {f} -> {target}")
            n_ok += 1

    print(f"Listo. Contigs en: {dest}  |  Total: {n_ok}")

if __name__ == "__main__":
    main()
