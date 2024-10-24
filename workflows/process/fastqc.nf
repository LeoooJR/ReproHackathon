#!/usr/bin/env nextflow

// Define the FastQC process, responsible for running quality control on FASTQ files
process runfastqc {

    // Specify the computational resources needed for the process
    cpus 4           // Allocate 4 CPU cores for this process
    memory '4 GB'    // Allocate 4 GB of RAM
    time '1h'        // Set a time limit of 1 hour for this process

    // Define the Singularity container to be used for running FastQC
    container 'fastqc_latest.sif'

    // Define the input: a tuple with the sample ID and the path to the FASTQ files
    input:
    tuple val(sample_id), path(fastq_files)

    // Define the output: the FastQC HTML report and ZIP file for each sample
    output:
    path("${sample_id}_fastqc.html"), emit: report   // Emit the FastQC HTML report with the sample ID
    path("${sample_id}_fastqc.zip"), emit: zip       // Emit the FastQC ZIP archive with the sample ID

    // The script section where the command to run FastQC is defined
    script:
    """
    fastqc --threads $task.cpus --outdir ./ ${fastq_files}  // Run FastQC with the specified number of threads
    """
}
