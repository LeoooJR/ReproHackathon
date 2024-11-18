#!/usr/bin/env nextflow
/**
 * This process downloads sequencing data from the SRA (Sequence Read Archive) 
 * using the fasterq-dump tool from the SRA Toolkit. The downloaded data 
 * is converted to FASTQ format and compressed using gzip.
 */

process downloadfastq {

    label 'medCPU'

    container ''

    publishDir "${params.outputDir}/FASTQ", mode: 'copy', overwrite: true, pattern: "*.fastq.gz"

    input:
    // List of SRA IDs to download
    val sra_id

    output:
    // Emit the SRA ID and the corresponding compressed FASTQ file
    tuple val(sra_id), path("*.fastq.gz")

    script:
    """
    prefetch --progress ${sra_id}

    # Use fasterq-dump to download the SRA data and convert it to FASTQ format
    /sratoolkit.3.1.1-ubuntu64/bin/fasterq-dump --threads $task.cpus --progress ${sra_id}
    
    # Compress the FASTQ files using pigz
    pigz -p $task.cpus *.fastq
    """
}
