#!/bin/bash

# --------------------------------------------------
# FASTQC + MULTIQC for MAMI samples (post-trimming)
# Elena Cabello Yeves · IBV-CSIC
# --------------------------------------------------

# Usage:
# bash 01_fastqc_and_multiqc.sh [input_dir] [output_dir]
# If no arguments are provided, defaults will be used:
# input_dir = "trimmed", output_dir = "qc_results"

# Example:
# bash 01_fastqc_and_multiqc.sh trimmed qc_output

# This script assumes that inside "trimmed/" there are subfolders for each sample
# containing .fq, .fastq or .fq.gz files (already trimmed)
# It will create one FastQC report per file, then summarize with MultiQC

# Set variables
input_dir="${1:-trimmed}"
output_dir="${2:-qc_results}"
threads=12
log_file="fastqc_multiqc.log"

echo "Running FastQC and MultiQC..." > "$log_file"
echo "Input: $input_dir" >> "$log_file"
echo "Output: $output_dir" >> "$log_file"

mkdir -p "$output_dir"

# -------------------
# Run FastQC per sample
# -------------------
for subdir in "$input_dir"/*; do
    if [ -d "$subdir" ]; then
        sample_name=$(basename "$subdir")
        fq_files=$(find "$subdir" -type f \( -name "*.fq" -o -name "*.fastq" -o -name "*.fq.gz" \))

        for fq_file in $fq_files; do
            if [ -f "$fq_file" ]; then
                echo "FastQC on $fq_file" >> "$log_file"
                sample_qc_dir="$output_dir/${sample_name}_FASTQC"
                mkdir -p "$sample_qc_dir"
                fastqc "$fq_file" -o "$sample_qc_dir" -t "$threads"
            fi
        done
    fi
done

# -------------------
# Run MultiQC on all results
# -------------------

# Example of original command I used:
# multiqc -n My_FastQC_reports -d /home/elena/nas_prometeo/UK_project/trimmed/FASTQC /home/elena/nas_prometeo/UK_project/trimmed/FASTQC/*

echo "Summarizing results with MultiQC..." >> "$log_file"
mkdir -p "$output_dir/multiqc"
multiqc -n MAMI_FASTQC_MultiQC_Report -o "$output_dir/multiqc" "$output_dir"/*_FASTQC > "$output_dir/multiqc/multiqc_stdout.log" 2>&1

echo "Done. Reports saved to: $output_dir" >> "$log_file"
