#!/usr/bin/env python3
# 02_rpk_cpm_calculation.py
# Uso:
#   python 02_rpk_cpm_calculation.py \
#       --covstats /ruta/a/salida_mapping \
#       --out /ruta/a/rpk_cpm_out \
#       --combine
#
# Crea: *_RPK_CPM.txt por muestra y (si --combine) matrices CPM/RPK anchas.

import argparse
from pathlib import Path
import pandas as pd

COV_COLS = ['ID','Avg_fold','Length','Ref_GC','Covered_percent','Covered_bases',
            'Plus_reads','Minus_reads','Read_GC','Median_fold','Std_Dev']

def load_covstats(path: Path) -> pd.DataFrame:
    # covstats de BBMap tiene una fila de cabecera con '#ID ...'
    # usamos skiprows=1 y asignamos columnas manualmente
    df = pd.read_csv(path, sep='\t', skiprows=1, header=None, names=COV_COLS)
    # Tipos numéricos
    num_cols = [c for c in COV_COLS if c not in ['ID']]
    df[num_cols] = df[num_cols].apply(pd.to_numeric, errors='coerce')
    return df

def compute_rpk_cpm(df: pd.DataFrame) -> pd.DataFrame:
    # RPK: (Plus_reads + Minus_reads) / Length
    df = df.copy()
    df['Total_reads'] = (df['Plus_reads'].fillna(0) + df['Minus_reads'].fillna(0))
    # Evita div/0: si Length<=0, RPK=0
    df['RPK'] = df.apply(lambda r: (r['Total_reads'] / r['Length']) if r['Length'] and r['Length'] > 0 else 0.0, axis=1)
    total_rpk = df['RPK'].sum()
    # Si no hay lectura alguna, evita división por 0
    if total_rpk > 0:
        scaling = total_rpk / 1_000_000.0
        df['CPM'] = df['RPK'] / scaling
    else:
        df['CPM'] = 0.0
    # Filtros: <70% cobertura o <1x → RPK=CPM=0
    mask_zero = (df['Covered_percent'] < 70) | (df['Avg_fold'] < 1)
    df.loc[mask_zero, ['RPK','CPM']] = 0.0
    return df

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--covstats", required=True, help="Dir con *_vVOTUs.txt (covstats)")
    ap.add_argument("--out", required=True, help="Dir de salida")
    ap.add_argument("--combine", action="store_true", help="Escribir matrices anchas CPM/RPK combinadas")
    args = ap.parse_args()

    cov_dir = Path(args.covstats).resolve()
    outdir = Path(args.out).resolve()
    outdir.mkdir(parents=True, exist_ok=True)

    files = sorted(cov_dir.glob("*_vVOTUs.txt"))
    if not files:
        raise SystemExit(f"[ERROR] No se encontraron *_vVOTUs.txt en {cov_dir}")

    per_sample = []
    for f in files:
        sample = f.name.replace("_vVOTUs.txt", "")
        df = load_covstats(f)
        df2 = compute_rpk_cpm(df)
        # Guarda por muestra
        out_file = outdir / f"{sample}_RPK_CPM.txt"
        df2.to_csv(out_file, sep='\t', index=False)
        # subset para combinar
        per_sample.append(df2[['ID','RPK','CPM']].assign(Sample=sample))

    if args.combine:
        big = pd.concat(per_sample, ignore_index=True)

        # Matriz CPM (ancha)
        cpm_wide = big.pivot_table(index='ID', columns='Sample', values='CPM', fill_value=0.0)
        rpk_wide = big.pivot_table(index='ID', columns='Sample', values='RPK', fill_value=0.0)

        cpm_wide.to_csv(outdir / "CPM_matrix.tsv", sep='\t')
        rpk_wide.to_csv(outdir / "RPK_matrix.tsv", sep='\t')

        # Lista de “presentes” por muestra (CPM>0)
        presence = (cpm_wide > 0).astype(int)
        presence.to_csv(outdir / "presence_absence_matrix.tsv", sep='\t')

    print("Listo. Salida
