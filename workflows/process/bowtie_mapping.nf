#!/usr/bin/env nextflow

/**
 * This process uses bowtie to map reads to a reference genome.
 */


process bowtie_mapping {

    label 'highMem'
    label 'highCPU'

    // Define the Singularity container to be used for running bowtie
    container 'bowtie.sif'

    // Define the input : gzipped FASTQ files with sequenced reads and the bowtie index 
    input: 
    path(fastq_file)
    path(bowtie_index_prefix) // use name given to bowtie-build

    // Define the output : sorted BAM file and BAM index file
    output: 
    path "aligned.bam", emit: bam 
    path "aligned.bam.bai", emit: bai 

    // Execute bowtie (mapping)
    script: 
    """
    bowtie -p $task.cpus -S ${bowtie_index_prefix} <(gunzip -c ${fastq_file}) | \
    samtools sort -@ $task.cpus -o aligned.bam 
    samtools index aligned.bam 
    """

}