#!/usr/bin/env nextflow

/**
 * This process uses the trim_galore tool to clean up sequences from raw data obtained by sequencing 
 * by removing unwanted parts (adaptators, too short fragments), leading to enhancing analysis quality and fewer 
 * errors and biases.
 */

 process trimgalore {

   container '/ifb/data/mydatalocal/Next/ReproHackathon/recipes/trimgalore.sif'

    // Define the input: FASTQ file on which trimgalore will act
    input:
    tuple val(sra_id), path(fastq_file)

    // Define the output: Fastq file with trimmed reads
    output: 
    path "*_trimmed.fastq.gz"

    // Execute trimgalore
    script:
    """
    cutadapt -q 20 --minimum-length 25 -o ${sra_id}_trimmed.fastq.gz ${fastq_file}
    """
 }