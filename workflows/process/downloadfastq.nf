#!/usr/bin/env nextflow
/**
 * This process downloads sequencing data from the SRA (Sequence Read Archive) 
 * using the fasterq-dump tool from the SRA Toolkit. The downloaded data 
 * is converted to FASTQ format and compressed using gzip.
 */

process downloadfastq {

    label 'highCPU'
    label 'medMem'

    input:
    // List of SRA IDs to download
    each sra_id

    output:
    // Emit the SRA ID and the corresponding compressed FASTQ file
    tuple val(sra_id), path("*.fastq.gz")

    script:
    """
    # Use fasterq-dump to download the SRA data and convert it to FASTQ format
    fasterq-dump --threads 4 --progress ${sra_id}
    
    # Compress the FASTQ files using gzip
    gzip *.fastq
    """
}
