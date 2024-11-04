#!/usr/bin/env nextflow

/**
 * Define the FastQC process, responsible for running quality control on FASTQ files
 * It takes FASTQ files as input and generates a quality report in HTML format 
 * and a compressed ZIP file containing detailed analysis results.
 */

process fastqc {

    label 'lowMem'
    label 'lowCPU'

    container '/ifb/data/mydatalocal/Next/ReproHackathon/recipes/fastqc.sif'

    publishDir "${params.outputDir}/FASTQC/DEFAULT", mode: 'symlink', pattern: "*_fastqc.*"

    // Define the input: a tuple with the sample ID and the path to the FASTQ files
    input:
    tuple val(sample_id), path(fastq_file)

    // Define the output: the FastQC HTML report and ZIP file for each sample
    output:
    // Emit the FastQC HTML report with the sample ID
    path("${sample_id}_fastqc.html"), emit: report   
    // Emit the FastQC ZIP archive with the sample ID
    path("${sample_id}_fastqc.zip"), emit: zip       

    //Execute FastQC with the specified number of threads and output directory
    script:
    """
    fastqc --threads $task.cpus --outdir ./ ${fastq_file} 
    """
}
