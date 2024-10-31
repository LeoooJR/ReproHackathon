#!/usr/bin/env nextflow

/**
 * This process uses the trim_galore tool to clean up sequences from raw data obtained by sequencing 
 * by removing unwanted parts (adaptators, too short fragments), leading to enhancing analysis quality and fewer 
 * errors and biases.
 */

 process trimgalore {

    // Specify the computational resources needed for the process
    cpus 4           // Allocate 4 CPU cores for this process
    memory '4 GB'    // Allocate 4 GB of RAM
    time '1h'        // Set a time limit of 1 hour for this process

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