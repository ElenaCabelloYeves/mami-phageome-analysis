#!/bin/bash

# ---------------------------
# SPAdes Assembly Automation
# ---------------------------
# Usage: bash 01_spades_assembly.sh /path/to/fastq_dir /path/to/spades.py
# ---------------------------

# Check input args
if [ "$#" -lt 2 ]; then
    echo "Usage: $0 <input_fastq_dir> <path_to_spades>"
    exit 1
fi

# Variables from user input
input_dir="$1"
spades_bin="$2"
threads=12
log_file="spades_assembly.log"

echo "Starting SPAdes assembly in $input_dir..." > "$log_file"

for r1_file in "$input_dir"/*_R1.fastq.gz; do
    r2_file="${r1_file/_R1.fastq.gz/_R2.fastq.gz}"

    if [[ ! -f "$r2_file" ]]; then
        echo "Warning: R2 not found for $r1_file. Skipping." >> "$log_file"
        continue
    fi

    sample_name=$(basename "$r1_file" _R1.fastq.gz)
    output_dir="${input_dir}/${sample_name}_output"
    mkdir -p "$output_dir"

    echo "Running SPAdes for $sample_name..." >> "$log_file"

    nohup nice -n 10 "$spades_bin" \
        -1 "$r1_file" \
        -2 "$r2_file" \
        -t "$threads" \
        -o "$output_dir" \
        > "${output_dir}/spades_${sample_name}.out" 2>&1 &

    echo "SPAdes launched for $sample_name" >> "$log_file"
done

echo "All SPAdes jobs submitted." >> "$log_file"
