#!/usr/bin/env nextflow
/**
 * This process downloads sequencing data from the SRA (Sequence Read Archive) 
 * using the fasterq-dump tool from the SRA Toolkit. The downloaded data 
 * is converted to FASTQ format and compressed using gzip.
 */

process downloadfastq {
    // Define the container for the SRA Toolkit
    container 'sratoolkit_latest.sif'

    input:
    // List of SRA IDs to download
    val sra_id

    output:
    // Emit the SRA ID and the corresponding compressed FASTQ file
    tuple val(sra_id), path("*.fastq.gz")

    script:
    """
    // Use fasterq-dump to download the SRA data and convert it to FASTQ format
    fasterq-dump --threads $task.cpus --progress ${sra_id}
    
    // Compress the FASTQ files using gzip
    gzip *.fastq
    """
}
