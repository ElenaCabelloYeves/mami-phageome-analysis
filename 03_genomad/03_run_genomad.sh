#!/usr/bin/env bash
set -euo pipefail

# 03_run_genomad.sh
# Ejecuta genomad end-to-end sobre un FASTA concatenado.
# Uso:
#   ./03_run_genomad.sh -i contigs_MAMI_final.fasta -o /ruta/salida -d /ruta/genomad_db \
#                       [-t HILOS] [-e /ruta/entorno/conda] [--no-cleanup]
#
# Ejemplo (según tus rutas):
#   ./03_run_genomad.sh \
#     -i /nas02/ucm/elena/MAMI_ENA/contigs/contigs_FINAL/contigs_MAMI_final.fasta \
#     -o /nas02/ucm/elena/genomad_output \
#     -d /nas01/Prometeo_AMarina_MCollado/UK_project/genomad_db \
#     -t 32 -e /home/elena/mambaforge/envs/genomad

INPUT_FASTA=""
OUT_DIR=""
DB_DIR=""
THREADS=16
CONDA_ENV=""
CLEANUP="--cleanup"

# Parseo argumentos
while [[ $# -gt 0 ]]; do
  case "$1" in
    -i) INPUT_FASTA="$2"; shift 2 ;;
    -o) OUT_DIR="$2"; shift 2 ;;
    -d) DB_DIR="$2"; shift 2 ;;
    -t) THREADS="$2"; shift 2 ;;
    -e) CONDA_ENV="$2"; shift 2 ;;
    --no-cleanup) CLEANUP=""; shift 1 ;;
    *) echo "Argumento desconocido: $1" >&2; exit 1 ;;
  end esac
done

# Validaciones
if [[ -z "$INPUT_FASTA" || -z "$OUT_DIR" || -z "$DB_DIR" ]]; then
  echo "Uso: $0 -i INPUT_FASTA -o OUT_DIR -d DB_DIR [-t THREADS] [-e CONDA_ENV] [--no-cleanup]" >&2
  exit 1
fi
if [[ ! -f "$INPUT_FASTA" ]]; then
  echo "No existe INPUT_FASTA: $INPUT_FASTA" >&2; exit 1
fi
mkdir -p "$OUT_DIR"

# Activar conda si se proporciona
if [[ -n "$CONDA_ENV" ]]; then
  # shellcheck disable=SC1091
  source "$(conda info --base)/etc/profile.d/conda.sh"
  conda activate "$CONDA_ENV"
fi

timestamp=$(date +"%Y%m%d_%H%M%S")
LOG="${OUT_DIR}/genomad_${timestamp}.log"

echo "Lanzando geNomad..."
echo "  FASTA:   $INPUT_FASTA"
echo "  OUT:     $OUT_DIR"
echo "  DB:      $DB_DIR"
echo "  THREADS: $THREADS"
echo "  LOG:     $LOG"

# Ejecutar con prioridad baja y sin colgar la sesión
nohup nice -n 10 genomad end-to-end $CLEANUP \
  --threads "$THREADS" \
  "$INPUT_FASTA" \
  "$OUT_DIR" \
  "$DB_DIR" > "$LOG" 2>&1 &

pid=$!
echo "Proceso en background (PID: $pid). Revisa el log: $LOG"
