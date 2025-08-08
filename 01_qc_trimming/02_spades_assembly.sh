#!/bin/bash

# ---------------------------
# SPAdes for assembly automation (MAMI project)
# ---------------------------
# Author: Elena Cabello Yeves – IBV-CSIC
# Usage: bash 01_spades_assembly.sh /path/to/fastq_dir /path/to/spades.py
# ---------------------------

# Check arguments
if [ "$#" -lt 2 ]; then
    echo "Usage: $0 <input_fastq_dir> <path_to_spades.py>"
    echo "Example: bash 01_spades_assembly.sh /nas02/ucm/elena/MAMI_ENA /home/elena/SPAdes/SPAdes-3.15.5-Linux/bin/spades.py"
    exit 1
fi

# Input parameters
input_dir="$1"
spades_bin="$2"

# Number of threads per sample
threads=12

# General log file
log_file="spades_assembly.log"
echo "Starting SPAdes assembly in $input_dir..." > "$log_file"

# Loop over all R1 files
for r1_file in "${input_dir}"/*_R1.fastq.gz; do
    # Derive corresponding R2 file
    r2_file="${r1_file/_R1.fastq.gz/_R2.fastq.gz}"

    # Check if R2 exists
    if [[ ! -f "$r2_file" ]]; then
        echo "R2 not found for $r1_file. Skipping." >> "$log_file"
        continue
    fi

    # Get sample name (without _R1)
    sample_name=$(basename "$r1_file" _R1.fastq.gz)

    # Create output folder
    output_dir="${input_dir}/${sample_name}_output"
    mkdir -p "$output_dir"

    # Run SPAdes with nohup and nice
    echo "Running SPAdes for $sample_name..." >> "$log_file"
    nohup nice -n 10 "$spades_bin" \
        -1 "$r1_file" \
        -2 "$r2_file" \
        -t "$threads" \
        -o "$output_dir" \
        > "${output_dir}/spades_${sample_name}.out" 2>&1 &

    echo "SPAdes launched for $sample_name" >> "$log_file"
done

echo "All SPAdes jobs submitted. Monitor with 'tail -f $log_file'" >> "$log_file"
