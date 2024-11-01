#!/usr/bin/env nextflow

/**
 * This process uses the trim_galore tool to clean up sequences from raw data obtained by sequencing 
 * by removing unwanted parts (adaptators, too short fragments), leading to enhancing analysis quality and fewer 
 * errors and biases.
 */

 process trimgalore {

    label 'medMem'
    label 'medCPU'

    // Define the Singularity container to be used for running the trim_galore tool
    container 'trimgalore.sif'

    // Define the input: FASTQ file on which trimgalore will act
    input:
    path(fastq_file)

    // Define the output: Fastq file with trimmed reads
    output: 
    path "*_trimmed.fastq", emit: trimmed 

    // Execute trimgalore
    script:
    """

    trim_galore -q 20 --phred33 --length 25 ${fastq_file}
    """
 }