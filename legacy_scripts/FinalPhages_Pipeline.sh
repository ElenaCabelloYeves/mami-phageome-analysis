#!/bin/bash

# This is a script which explains all the different STEPS of the metagenomics pipeline to extract viruses:
# THIS IS the final pipeline for the 182 samples:

# The architecture is the following: 
/nas02/ucm/elena/MAMI_ENA
MAMI_ENA --> raw data

# STEP 1: Trimming with trim_galore (# Already done as it is part of the raw data from Cell Host paper) 

# STEP 2: After trimming you perform FASTQC

#!/bin/bash

# This is a script to automatically run fastqc in all the samples inside different directories: 
# Main directory containing subdirectories
main_directory="trimmed"

# Loop through subdirectories
for subdir in "$main_directory"/*; do
    if [ -d "$subdir" ]; then
        # Get the sample name from the subdirectory name
        sample_name=$(basename "$subdir")

        # Loop through .fq files in the subdirectory
        for fq_file in "$subdir"/*.fq; do
            if [ -f "$fq_file" ]; then
                # Extract the file name without extension
                file_name=$(basename "$fq_file" .fq)

                # Define the output directory
                output_dir="${subdir}/${sample_name}_FASTQC"

                # Create the output directory if it doesn't exist
                mkdir -p "$output_dir"

                # Run FastQC with the appropriate naming
                fastqc "$fq_file" -o "$output_dir" -t 12
            fi
        done
    fi
done

# STEP 3: Use MULTIQC:

# This is a script to use multiqc:
multiqc -n [name of new directory] -d [path/to/your/directory/where/htmls/are]
multiqc -n My_FastQC_reports -d /home/elena/nas_prometeo/UK_project/trimmed/FASTQC /home/elena/nas_prometeo/UK_project/trimmed/FASTQC/*

# SEGUNDA TANDA MAMI (Funciona en: /nas02/ucm/elena/MAMI_ENA)

#!/bin/bash

# Este es un script para ejecutar FastQC en todos los archivos fastq.gz en el directorio actual y >

# Crear una lista de archivos fastq.gz
fastq_files=(*fastq.gz)

# Ejecutar FastQC en cada archivo fastq.gz
for fq_file in "${fastq_files[@]}"; do
    if [ -f "$fq_file" ]; then
        # Nombre del archivo sin la extensión .fastq.gz
        file_name=$(basename "$fq_file" .fastq.gz)

        # Directorio de salida para FastQC
        output_dir="${file_name}_FASTQC"

        # Crear el directorio de salida si no existe
        mkdir -p "$output_dir"

        # Ejecutar FastQC
        fastqc "$fq_file" -o "$output_dir"
    fi
done

# Ejecutar MultiQC para generar un informe combinado
multiqc .

MultiQC results --> /nas02/ucm/elena/MAMI_ENA/multiqc_report.html


# ASSEMBLY:

# SPAdes_automatic.sh                                         
#!/bin/bash

# Directorio donde se encuentran los archivos .fastq.gz
input_dir="/nas02/ucm/elena/MAMI_ENA"

# Iterar sobre todos los archivos R1.fastq.gz en el directorio
for r1_file in ${input_dir}/*_R1.fastq.gz; do
    # Crear el nombre del archivo R2 correspondiente
    r2_file=${r1_file/_R1.fastq.gz/_R2.fastq.gz}

    # Crear el nombre del directorio de salida
    base_name=$(basename ${r1_file} _R1.fastq.gz)
    output_dir=${input_dir}/${base_name}_output

    # Crear el directorio de salida si no existe
    mkdir -p ${output_dir}

    # Verificar si el directorio fue creado
    if [ ! -d "${output_dir}" ]; then
        echo "Error: no se pudo crear el directorio ${output_dir}"
        exit 1
    fi

    # Ejecutar SPAdes
    nohup nice -n 10 /home/elena/SPAdes/SPAdes-3.15.5-Linux/bin/spades.py -1 ${r1_file} -2 ${r2_file}>

done

# AÚN HAY QUE PROBARLO (creo que ha funcionado):
# RENOMBRAR resultados de contigs.fasta:

import os

def rename_contigs_files(base_directory):
    # Iterar sobre las carpetas en el directorio base
    for folder_name in os.listdir(base_directory):
        folder_path = os.path.join(base_directory, folder_name)
        
        # Verificar si es un directorio
        if os.path.isdir(folder_path):
            # Construir el camino del archivo contigs.fasta
            contigs_file_path = os.path.join(folder_path, "contigs.fasta")
            
            # Verificar si el archivo contigs.fasta existe
            if os.path.isfile(contigs_file_path):
                # Crear el nuevo nombre del archivo
                new_file_name = folder_name.replace("_output", "") + ".fasta"
                new_file_path = os.path.join(base_directory, new_file_name)
                
                # Renombrar el archivo
                os.rename(contigs_file_path, new_file_path)
                print(f"Renombrado {contigs_file_path} a {new_file_path}")
            else:
                print(f"No se encontró contigs.fasta en {folder_path}")

# Ruta del directorio base donde están las carpetas output
base_directory = "/nas02/ucm/elena/MAMI_ENA"
rename_contigs_files(base_directory)


# FUNCIONA SPAdes
# Script para pasar todos los contigs.fasta a un nuevo directorio llamado contigs

import os
import shutil

def move_contig_files(source_dir, dest_dir, file_prefix="MAMI", file_suffix=".fasta", target_folders_suffix="_output"):
    # Ensure the destination directory exists
    os.makedirs(dest_dir, exist_ok=True)
    
    # Walk through the source directory
    for root, dirs, files in os.walk(source_dir):
        if root.endswith(target_folders_suffix):
            for file in files:
                if file.startswith(file_prefix) and file.endswith(file_suffix):
                    source_file = os.path.join(root, file)
                    dest_file = os.path.join(dest_dir, file)
                    shutil.move(source_file, dest_file)
                    print(f"Moved: {source_file} to {dest_file}")

# Define your source and destination directories
source_directory = "/nas02/ucm/elena/MAMI_ENA"
destination_directory = "/nas02/ucm/elena/MAMI_ENA/contigs"

# Call the function
move_contig_files(source_directory, destination_directory)


## * NO HECHO!!!
# Optimizar assembly:
https://bitbucket.org/srouxjgi/scripts_pcrlibs_assembly_optimization/src/master/



# STEP 7: geNomad MGEs

# TAKE ALL THE CONTIGS: 
# STRONG OUTPUT FINISHED
# Take all contig.fasta files and concatenate them 

# To add the name of the sample before each node and create a new file with that:
sed '/^>/ s/>/>sample_814B_/' contigs_814B.fasta > contigs_814B_headers.fasta


# 5-JUL-2024 --> Procesar automáticamente:

#!/bin/bash

# Iterar sobre todos los archivos con el patrón MAMI_*_contigs.fasta
for file in MAMI_*_contigs.fasta; do
  # Extraer el nombre del archivo sin la extensión
  base_name=$(basename "$file" _contigs.fasta)
  # Crear el nuevo nombre de archivo de salida
  output_file="${base_name}_headers.fasta"
  # Usar sed para añadir el prefijo correspondiente a cada línea que comienza con >
  sed "/^>/ s/>/>sample_${base_name}_/" "$file" > "$output_file"
done


# Concatenate all fasta files:
*.fasta > contigs_babies_headers.fasta 

cat *.fasta > contigs_MAMI_final.fasta 


# Activate genomad environment:
conda activate /home/elena/mambaforge/envs/genomad

# RUN GENOMAD WITH ALL THE CONCATENATED CONTIGS:
# 5 jul - 2024

nohup nice -n 10 genomad end-to-end --cleanup 
/nas02/ucm/elena/MAMI_ENA/contigs/contigs_FINAL/contigs_MAMI_final.fasta 
/nas02/ucm/elena/genomad_output  
/nas01/Prometeo_AMarina_MCollado/UK_project/genomad_db > FINAL.log 2>&1 &

# When you already have all your results of geNomad we can map them with BBtools.
# We can take BBMap.sh and the references genomes. 
# We can take the Fw Read of one baby and the Reverse of the baby. 
# Then, we can check Covstats and give the file name and map all the reads --> then we take the txt file (Coverage of each one).
# Then, we create a redundant file with everything (redundance set of viruses).  
# With the output of BBMap we take the 70% genome viruses.  
# We can start to see if that's working for 4 samples.  



# STEP 8: OBTAINING THE vOTUs for REFERENCE DATASETS:


# PROBLEM NEED 50 CHARACTERES MAXIMUM --> I HAVE 69
sed 's/sample/s/g; s/length/l/g; s/provirus/p/g; s/cov/c/g; s/NODE/N/g' contigs_headers_virus.fna > modified_contigs_headers_virus.fna 
sed 's/sample/s/g; s/length/l/g; s/provirus/p/g; s/cov/c/g; s/NODE/N/g' accession_list_nodup.txt > modified_accession_list_nodup.txt
makeblastdb -in modified_contigs_headers_virus.fna -dbtype nucl -out virus_mami_db -parse_seqids
blastdbcmd -db virus_mami_db -entry_batch modified_accession_list_nodup.txt -out extracted_contigs.fasta
blastdbcmd -db virus_mami_db -entry all | grep '^>'


# JULY WITH 182 samples
awk '{$2=""; print $0}' my_clusters_MAMI.tsv | sed 's/_MAMI//g' > my_clusters_MAMI_2.tsv

# THIS IS THE CORRECT ## JULY CORRECT 
# Rapid genome clustering based on pairwise ANI

# First, create a blast+ database:
makeblastdb -in FINAL_modified_virus3.fna -dbtype nucl -out VIRUS_MAMI_db

# Next, use megablast from blast+ package to perform all-vs-all blastn of sequences:
blastn -query FINAL_modified_virus3.fna -db VIRUS_MAMI_db -outfmt '6 std qlen slen' 
-max_target_seqs 10000 -out my_blast_MAMI.tsv -num_threads 24

# Next, calculate pairwise ANI by combining local alignments between sequence pairs:
python anicalc.py -i my_blast_MAMI.tsv -o my_ani_MAMI.tsv

# Finally, perform UCLUST-like clustering using the MIUVIG recommended-parameters (95% ANI + 85% AF):
python aniclust.py --fna FINAL_modified_virus3.fna --ani my_ani_MAMI.tsv --out my_clusters_MAMI.tsv --min_ani 95 --min_tcov 85 --min_qcov 0

# This gives you the vOTUs from all the samples which become the "reference" dataset 

# He hecho esto:
cut -f1 my_ani.tsv > accession_list.txt
sort -u accession_list.txt > accession_list_nodup.txt

makeblastdb -in FINAL_modified_virus3.fna -dbtype nucl -out VIRUS_MAMI_db -parse_seqids
blastdbcmd -db VIRUS_MAMI_db -entry_batch accession_list_nodup.txt -out extracted_contigs.fasta
grep '^>' extracted_contigs.fasta > extracted_contigs.txt

Error: [blastdbcmd] Skipped QNAME

# Hacer esto otro? (Creo que es lo mismo)
cut -f1 my_clusters_MAMI.tsv > accession_list_clusters.txt
sort -u accession_list.txt > accession_list_nodup_clusters.txt

blastdbcmd -db VIRUS_MAMI_db -entry_batch accession_list_nodup_clusters.txt -out extracted_contigs_clusters.fasta

Error: [blastdbcmd] Skipped QNAME



## SEGUIR 22 JULIO (not needed to be changed)


# Rename samples like sample_022B_NODE_14 and take the 1st column of representatives in a file .tsv
# Rename also in FASTA files and I'll have the vOTUs. 
# This will be the REFERENCE DATASET

# Eliminar todo después de NODE (N) y el número:
sed -E 's/(>s_[^_]+_[^_]+_[^_]+)_.*/\1/' extracted_contigs_modified.fasta > extracted_contigs_modified_final.fasta

# This is the REFERENCE DATASET:
# Eliminar todo después de length (l) y el número:
sed 's/\(>s_[^_]\+_N_[^_]\+_l_[0-9]\+\).*/\1/' extracted_contigs_modified.fasta > vOTUs_reference_dataset.fasta 

# Comprobar si hay duplicados en un archivo multifasta:

grep '^>' vOTUs_reference_dataset.fasta | sort | uniq -d



seqkit rmdup -D -s vOTUs_reference_dataset.fasta -o no_duplicates.fasta
[INFO] 0 duplicated records removed



# STEP 9: Mapping 

# Comprobar si existen duplicados tanto en el nombre del header como en la secuencia: 
seqkit rmdup -D -s vOTUs_reference_dataset.fasta -o no_duplicates.fasta

# Comprobar si hay headers con el mismo nombre:
grep '^>' vOTUs_reference_dataset.fasta | sort | uniq -d

# Añadir un _2 al segundo duplicado 
awk '/^>/ && seen[$1]++ {sub(/^>/, "&_2")} 1' vOTUs_reference_dataset.fasta > vOTUs_reference_dataset_no_duplicates.fasta



# Mapear para obtener covstats=006B04H_vVOTUs.txt
# Las secuencias están en /home/elena/nas_prometeo/UK_project/trimmed/DATA/MAMI_DATA
bbmap.sh ref=vOTUs_reference_dataset.fasta in1=/home/elena/nas_prometeo/UK_project/trimmed/DATA/MAMI_DATA/MAMI_006B04H_2_R1_trimmed_1.fq in2=/home/elena/nas_prometeo/UK_project/trimmed/DATA/MAMI_DATA/MAMI_006B04H_2_R2_trimmed_2.fq covstats=006B04H_vVOTUs.txt

# Sacar la cobertura por secuencia:
awk '{print $1, $5}' 006B04H_vVOTUs.txt > coverage_per_sequence.txt


# #NOT NEEDED Sacar los resultados que tengan más de un 70% de cobertura 
awk '$5 > 70 {print}' 006B04H_vVOTUs.txt > coverage_70.txt




# STEP 9: Mapping automatic

# ESTO es lo que FUNCIONA:

# Unzip samples to use BBmap automatic:
nohup nice -n 10 bash -c 'for f in *.gz; do gunzip -c "$f" > "${f%.gz}"; done' > decompress.log 2>&1 &


import os

# Directorio donde se encuentran los archivos de lectura
data_dir = "/nas02/ucm/elena/MAMI_ENA/gz"

# Directorio donde se almacenarán los resultados
output_dir = "/nas02/ucm/elena/genomad_output/mapping"

# Comando para el mapeo con bbmap.sh
bbmap_command = "bbmap.sh ref=/nas02/ucm/elena/genomad_output/mapping/vOTUs_reference_dataset.fasta covstats={} in1={} in2={}"

# Comando para extraer la cobertura por secuencia
awk_command = "awk '{{print $1, $5}}' {} > {}"

# Obtener todos los archivos en el directorio de datos
files = os.listdir(data_dir)

# Filtrar los archivos que terminan en _R1_.fastq o _R1_.fq
r1_files = [file for file in files if file.endswith("_R1.fastq") or file.endswith("_R1.fq")]

# Iterar sobre los archivos _R1_
for r1_file in r1_files:
    # Construir la ruta completa del archivo de lectura _R1_
    read_file_R1 = os.path.join(data_dir, r1_file)
    # Construir la ruta del archivo _R2_
    read_file_R2 = read_file_R1.replace("_R1", "_R2")
    
    # Verificar si el archivo _R2_ existe
    if os.path.exists(read_file_R2):
        # Construir la ruta de salida para el archivo covstats
        covstats_output = os.path.join(output_dir, r1_file.replace("_R1", "").replace(".fq", "_vVOTUs.txt").replace(".fastq", "_vVOTUs.txt"))
        
        # Formatear el comando de mapeo
        bbmap_command_formatted = bbmap_command.format(covstats_output, read_file_R1, read_file_R2)
        
        # Ejecutar el comando de mapeo con bbmap.sh
        exit_code = os.system(bbmap_command_formatted)
        
        # Verificar si el comando de mapeo se ejecutó correctamente
        if exit_code == 0 and os.path.exists(covstats_output):
            # Construir la ruta de salida para el archivo de cobertura por secuencia
            coverage_output = os.path.join(output_dir, r1_file.replace("_R1", "").replace(".fq", "_coverage_per_sequence.txt").replace(".fastq", "_coverage_per_sequence.txt"))
            # Ejecutar el comando de extracción de cobertura por secuencia
            os.system(awk_command.format(covstats_output, coverage_output))
        else:
            print(f"Error processing {r1_file}, BBMap command failed with exit code {exit_code}")
    else:
        print(f"Corresponding _R2_ file for {r1_file} not found.")



nohup python mapping_automatic_final2.py > python_mapping.log 2>&1 &
            
bbmap.sh:
/home/elena/miniconda3/pkgs/bbtools-37.62-0/bbtools/lib



# STEP 10: RPM and CPM matrix
# Generamos un script en python que te permite leer los archivos .txt 
# y calcular el RPM y CPM así como establecer CPM en 0 si la cobertura es inferior al 70%

# HACERLO DE FORMA AUTOMÁTICA:

import os
import pandas as pd

# Directorio donde se encuentran los archivos de entrada
input_directory = '/nas02/ucm/elena/genomad_output/mapping/'

# Directorio donde se guardarán los archivos de salida
output_directory = '/nas02/ucm/elena/genomad_output/mapping/mapping_automatic/'

# Obtener la lista de archivos en el directorio de entrada
input_files = os.listdir(input_directory)

# Iterar sobre cada archivo de entrada
for file in input_files:
    if file.endswith('_vVOTUs.txt'):
        # Leer el archivo de texto sin la primera fila para evitar errores de conversión
        df = pd.read_csv(os.path.join(input_directory, file), delimiter='\t', skiprows=1)

        # Definir manualmente los nombres de las columnas
        df.columns = ['ID', 'Avg_fold', 'Length', 'Ref_GC', 'Covered_percent', 'Covered_bases', 'Plus_reads', 'Minus_reads', 'Read_GC', 'Median_fold', 'Std_Dev']

        # Convertir las columnas relevantes a tipos numéricos
        numeric_columns = ['Avg_fold', 'Length', 'Ref_GC', 'Covered_percent', 'Covered_bases', 'Plus_reads', 'Minus_reads', 'Read_GC', 'Median_fold', 'Std_Dev']
        df[numeric_columns] = df[numeric_columns].astype(float)

        # Calcular el total de conteos para cada muestra
        df['RPK'] = (df['Plus_reads'] + df['Minus_reads']) / df['Length']

        # Calcular el total de RPK para todas las lecturas en la muestra
        total_rpk = df['RPK'].sum()

        # Calcular el factor de escala "per million"
        scaling_factor = total_rpk / 1_000_000

        # Calcular el CPM para cada lectura
        df['CPM'] = df['RPK'] / scaling_factor

        # Establecer a cero el CPM para muestras con cobertura inferior a 1x y 70%
        df.loc[(df['Covered_percent'] < 70) | (df['Avg_fold'] < 1), ['RPK', 'CPM']] = 0

        # Guardar el DataFrame actualizado en un nuevo archivo de texto con el nombre correcto en el directorio de salida
        output_file = file.replace('_vVOTUs.txt', '_RPK_CPM.txt')
        df.to_csv(os.path.join(output_directory, output_file), sep='\t', index=False)

# Commands to compress all fastq files in fq.gz and then delete the originals:
nohup nice -n 10 sh -c 'find /nas01/Prometeo_AMarina_MCollado/UK_project/trimmed/DATA/MAMI_DATA -type f -name "*.fq" -exec sh -c '\''gzip -c "{}" > "{}.gz" && rm -f "{}"'\'' \;' > compression_log.txt 2>&1 &


# Things-to-do

1) Count/per million
2) Abundance/sample vOTUs --> 95% ANI and 70% coverage
3) alfa diversity --> Between mothers / babies in different time points. 
    Is the diversity different? Viral groups? Mothers had antibiotics/no antibiotics 
    - vaginal/no vaginal --> Intersection
4) VIBRANT AMGs
5) PLOTS NMDS
6) Phage-host interaction --> + MAGs better for the database --> iPHoP


# Hecho el día 25 de septiembre: 
# CHECKV para comprobar la calidad de los assemblies: 
nohup nice -n 15 checkv end_to_end contigs_MAMI_final.fasta /nas02/ucm/elena/MAMI_ENA/contigs/contigs_FINAL -d /home/elena/checkv-db-v1.5/ -t 8 > checkv_output.log 2>&1 &

# Monitorizar el proceso:
tail -f checkv_output.log


# 19 de septiembre

# Tenemos un script llamado: NMDS_Plots_Elena.Rmd con plots de resultados
# Tenemos ya 182 archivos de tipo RPM_CPM y los pasamos al ordenador en la carpeta 
# "~/Escritorio/FINAL_MAPPING_JULY/RPK_CPM/nueva_nomenclatura/output"

# Mediante un script denominado renombrar2.sh renombramos los IDs de forma que aparezcan como vOTU1,
# vOTU2, etc. 

#!/bin/bash

# Directorio con archivos .txt
input_dir="/home/usuario/Escritorio/FINAL_MAPPING_JULY/RPK_CPM/nueva_nomenclatura"
output_dir="/home/usuario/Escritorio/FINAL_MAPPING_JULY/RPK_CPM/nueva_nomenclatura/output"

# Crear el directorio de salida si no existe
mkdir -p "$output_dir"

# Contador de vOTUs
counter=1

# Iterar sobre todos los archivos .txt en el directorio
for file in "$input_dir"/*.txt; do
    # Extraer el nombre del archivo
    filename=$(basename "$file")
    output_file="$output_dir/simplified_$filename"

    # Crear un archivo temporal para procesar
    temp_file=$(mktemp)

    # Leer el archivo y reemplazar IDs
    awk -F'\t' -v OFS='\t' -v counter="$counter" '
    NR==1 {print; next}  # Imprimir la cabecera
    {
        id=$1
        # Asignar nuevo ID vOTU para todos los IDs
        if (!(id in ids)) {
            ids[id] = "vOTU" counter++
        }
        new_id = ids[id]

        # Si el ID contiene "|p_", añadir "|provirus" al nuevo ID
        if (id ~ /\|p_/) {
            new_id = new_id "|provirus"
        }

        $1 = new_id
        print
    }' "$file" > "$temp_file"

    # Mover el archivo temporal al archivo de salida
    mv "$temp_file" "$output_file"

    # Mensaje de confirmación
    echo "Archivo procesado y guardado: $output_file"
done

echo "Renombrado completado."

# 15 octubre

# iPhoP installation from: https://bitbucket.org/srouxjgi/iphop/src/main/
# Database located in: /nas02/ucm/elena/iPHoP_db/Aug_2023_pub_rw

iphop predict --fa_file my_input_phages.fasta --db_dir path/to/iphop_db/Sept_2021_pub/ --out_dir iphop_output/
nohup nice -n 10 iphop predict --fa_file /nas02/ucm/elena/genomad_output/contigs_MAMI_final_summary/contigs_MAMI_final_virus.fna --db_dir /nas02/ucm/elena/iPHoP_db/Aug_2023_pub_rw --out_dir /nas02/ucm/elena/iphop_output > iphop_predict.log 2>&1 &



# 17 de octubre CheckV after assemblies: 


nohup nice -n 15 checkv end_to_end contigs_MAMI_final_virus.fna 
/nas02/ucm/elena/genomad_output/contigs_MAMI_final_summary/checkv_results 
-d /home/elena/checkv-db-v1.5/ -t 8 > checkv_aftergenomad.log 2>&1 &

pip install bacphlip

# Comandos de bacphlip: 
# Corrido en salas, porque koch no era compatible en la instalación:
nohup nice -n 10 bacphlip -i FINAL_modified_virus4.fna  
--multi_fasta > bacphlip.log 2>&1 & 


# Segundo intento el 18 de octubre del 2024
nohup nice -n 10 bacphlip -i Filtered_FINAL_viruses.fna  
--multi_fasta > bacphlip_filtered.log 2>&1 & 


nohup nice -n 10 
/nas02/ucm/elena/genomad_output/contigs_MAMI_final_summary/FINAL_modified_virus3.fna > 
taxmyphage.log 2>&1 &


# 22 de octubre del 2024

# He matado sin querer el proceso de iPHoP. 
nohup nice -n 10 iphop predict --fa_file /nas02/ucm/elena/genomad_output/contigs_MAMI_final_summary/contigs_MAMI_final_virus.fna --db_dir /nas02/ucm/elena/iPHoP_db/Aug_2023_pub_rw --out_dir /nas02/ucm/elena/iphop_output > iphop_predict.log 2>&1 &


Estoy pensando en hacer:
nohup nice -n 10 iphop predict --fa_file /nas02/ucm/elena/genomad_output/contigs_MAMI_final_summary/contigs_MAMI_final_virus.fna --db_dir /home/elena/iPHoP_db/Aug_2023_pub_rw --out_dir /home/elena/iphop_output > iphop_predict_22oct.log 2>&1 &

# He matado el proceso sin querer pero como desde la nas todo va más lento estoy haciéndolo de nuevo en hom
# He copiado esto para tener el input de los datos:
cp -rp /nas02/ucm/elena/genomad_output/contigs_MAMI_final_summary/contigs_MAMI_final_virus.fna /home/elena/data_for_iPHoP/

# Estoy copiando la base de datos de iPHoP a home
cp -rp /nas02/ucm/elena/iPHoP_db/ /home/elena 

# Cuando se copie y esto acabe haré lo siguiente:
nohup nice -n 10 iphop predict --fa_file /home/elena/data_for_iPHoP/contigs_MAMI_final_virus.fna --db_dir /home/elena/iPHoP_db/Aug_2023_pub_rw --out_dir /home/elena/iphop_output > iphop_predict_22oct.log 2>&1 &

# TAXMYPHAGE FUNCIONA
nohup nice -n 10 taxmyphage run -i /nas02/ucm/elena/genomad_output/contigs_MAMI_final_summary/FINAL_modified_virus3.fna -o /nas02/ucm/elena/taxmyphage_results --no-figures > taxmyphage_final.log 2>&1 &


## LO ÚLTIMO QUE SE HA HECHO DE IPHOP ES ESTO:
nohup nice -n 10 iphop predict --fa_file /home/elena/iphop_run/FINAL_vOTUs_viruses_MAMI.fna --db_dir /nas02/ucm/elena/iPHoP_db/Aug_2023_pub_rw --out_dir /home/elena/iphop_output2 > iphop_predict_23oct_version2.log 2>&1 &
# He vuelto a redireccionar a la base de datos inicial por si la otra no se ha descargado bien, a comprobar.


# PASOS para cambiar los headers del multifasta original FINAL_modified_virus3.fna a FINAL_vOTUs_viruses_MAMI.fna

awk 'NR==FNR {map[$1]=$2; next} /^>/ {id=substr($0, 2); if (id in map) {sub(/>(.*)/, ">" map[id]);} print; next} {print}' mapping.txt FINAL_modified_virus3.fna > FINAL_vOTUs_viruses_MAMI.fna
grep '^>' FINAL_vOTUs_viruses_MAMI.fna # print headers

# TAXMYPHAGE TEST
nohup nice -n 10 taxmyphage run -i /nas02/ucm/elena/viruses/test_MAMI.fna -o /nas02/ucm/elena/taxmyphage_results --threads 10 --no-figures --db_folder /home/elena/miniconda3/envs/taxmyphage/lib/python3.12/site-packages/taxmyphage/database > taxmyphage_run_23oct.log 2>&1 &

# TAXMYPHAGE ALL
nohup nice -n 10 taxmyphage run -i /nas02/ucm/elena/viruses/FINAL_vOTUs_viruses_MAMI.fna -o /nas02/ucm/elena/taxmyphage_results --threads 10 --no-figures --db_folder /home/elena/miniconda3/envs/taxmyphage/lib/python3.12/site-packages/taxmyphage/database > taxmyphage_run_23oct_all.log 2>&1 &


# 24 OCTUBRE
nohup nice -n 15 iphop predict --fa_file /home/elena/iphop_run/FINAL_vOTUs_viruses_MAMI.fna --db_dir /nas02/ucm/elena/iPHoP_db/Aug_2023_pub_rw --out_dir /home/elena/iphop_output > iphop_predict_24oct.log 2>&1 &

# Filtrado 10kb
seqkit seq -m 10000 FINAL_vOTUs_viruses_MAMI.fna > FINAL_vOTUs_viruses_MAMI_filtrado_10kb.fna
# Remove gaps
seqkit seq -m 10000 -g FINAL_vOTUs_viruses_MAMI.fna > FINAL_vOTUs_viruses_MAMI_filtrado_10kb.fna


# IPHOP:
nohup nice -n 15 iphop predict --fa_file /home/elena/iphop_run/FINAL_vOTUs_viruses_MAMI_filtrado_10kb.fna --db_dir /nas02/ucm/elena/iPHoP_db/Aug_2023_pub_rw --out_dir /home/elena/iphop_output_10kb > iphop_predict_24oct_10kb.log 2>&1 &

# TAXMYPHAGE:
# It works: 
nohup nice -n 10 taxmyphage run -i /nas02/ucm/elena/viruses/FINAL_vOTUs_viruses_MAMI_filtrado_10kb.fna -o /nas02/ucm/elena/taxmyphage_results_10kb --threads 10 --no-figures --db_folder /home/elena/miniconda3/envs/taxmyphage/lib/python3.12/site-packages/taxmyphage/database > taxmyphage_run_24oct_10kb.log 2>&1 &

# TAXMYPHAGE Similarity:
nohup nice -n 10 taxmyphage similarity -i /nas02/ucm/elena/viruses/FINAL_vOTUs_viruses_MAMI_filtrado_10kb.fna -o /nas02/ucm/elena/taxmyphage_results_10kb_similarity --threads 10 --no-figures --db_folder /home/elena/miniconda3/envs/taxmyphage/lib/python3.12/site-packages/taxmyphage/database > taxmyphage_run_25oct_10kb_similarity.log 2>&1 &


## 25 octubre BACPHLIP:
nohup nice -n 10 bacphlip -i FINAL_vOTUs_viruses_MAMI_filtrado_10kb.fna --multi_fasta > bacphlip_filtrado_10kb.log 2>&1 &


# 28 Octubre:
# Hacer RPK CPM matrices solo para 10 kb: 
grep '^>' FINAL_vOTUs_viruses_MAMI_filtrado_10kb.fna > headers_filtrado_10kb.txt

# Tener en cuenta que los originales tienen | y los nuevos _
sed 's/>//g' headers_filtrado_10kb.txt > headers_limpio.txt
grep -wFf headers_limpio.txt mapping2.txt > vOTUs_correspondencia.txt

# PROCESAR de todos los fagos a solo los de 10kb:
# 1) Coger headers de fasta 10kb
# 2) A partir de ahí, de mapping.txt hacer archivo igual pero con los headers de 10kb
# 3) En el folder con los txt hacer nuevos archivos con solo los headers nuevos y ponerlo en un nuevo folder


mkdir /home/usuario/Escritorio/FINAL_MAPPING_JULY/RPK_CPM/nueva_nomenclatura/filtrados


/home/usuario/Escritorio/FINAL_MAPPING_JULY/RPK_CPM/nueva_nomenclatura/filtrar10kb.sh
#!/bin/bash

# Definir rutas
input_dir="/home/usuario/Escritorio/FINAL_MAPPING_JULY/RPK_CPM/nueva_nomenclatura"
output_dir="/home/usuario/Escritorio/FINAL_MAPPING_JULY/RPK_CPM/nueva_nomenclatura/filtrados"
correspondence_file="vOTUs_correspondencia.txt"

# Crear el directorio de salida si no existe
mkdir -p "$output_dir"

# Leer los IDs de vOTUs desde la primera columna del archivo de correspondencia
vOTUs=$(awk '{print $1}' "$input_dir/$correspondence_file")

# Iterar sobre cada archivo .txt en el directorio de entrada
for file in "$input_dir"/*.txt; do
    # Definir el archivo de salida
    output_file="$output_dir/$(basename "$file")"
    
    # Inicializar el archivo de salida
    > "$output_file"

    # Filtrar usando grep para buscar en la columna ID
    for vOTU in $vOTUs; do
        # Usar grep para buscar en la primera columna
        grep "^$vOTU" "$file" >> "$output_file"
    done

    # Verificar si el archivo de salida está vacío
    if [ -s "$output_file" ]; then
        echo "Coincidencias encontradas y guardadas en: $(basename "$output_file")"
    else
        echo "No se encontraron coincidencias en: $(basename "$file"). Archivo creado vacío."
        # Si deseas eliminar archivos vacíos, descomentar la siguiente línea
        # rm "$output_file"
    fi
done

# Copiar un archivo.fasta desde un servidor a otro: 
scp /nas02/ucm/elena/MAMI_ENA/contigs/contigs_FINAL/contigs_MAMI_final.fasta elena@salas.ibv.csic.es:/home/elena/VIBRANT/

# 31 octubre intentando instalar VIBRANT 
# Aquí está el log: /home/elena/VIBRANT/databases
# Seguir URGENTE con gráficas importantes 
# TODO en salas pero no funciona bien 

# 27 noviembre, VIBRANT cargado en salas:
nohup nice -n 10 python3 VIBRANT_run.py -i /home/elena/VIBRANT2/contigs_MAMI_final.fasta -folder /home/elena/VIBRANT2 -t 8 > /home/elena/VIBRANT2/vibrant_output.log 2>&1 &

# Si tienes un archivo donde las tabulaciones no están bien:
sed 's/\bNo\s\+terminal\s\+repeats\b/No_terminal_repeats/g' input_file.tsv > output_file_corrected.tsv


## 12 de diciembre del 2024

Tengo el dataframe final en:
/home/usuario/Escritorio/MAMI_Paper_2024/final_table/FINAL_TABLE_ALL/final_data_forplots.csv
# We have all the results from genomad, CPM_RPM Mapping, iPHoP, VIBRANT, taxmyphage no similarity option, bacphlip 


# AMGs --> place where I have all the information about this:
"~/Escritorio/MAMI_Paper_2024/Results/VIBRANT/AMG_Distribution_by_Metabolism_and_Group.png"
