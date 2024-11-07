#!/usr/bin/env nextflow

/**
 * This process uses bowtie to map reads to a reference genome.
 */


process mapping {

    label 'lowMem'
    label 'highCPU'
    label 'retry'

    container '/ifb/data/mydatalocal/Next/ReproHackathon/recipes/bowtie.sif'

    // Define the input : gzipped FASTQ files with sequenced reads and the bowtie index 
    input: 
    path(fastq_file)
    val(bowtie_index_prefix) // use name given to bowtie-build

    // Define the output : sorted BAM file and BAM index file
    output: 
    path "*.sam"

    // Execute bowtie (mapping)
    script: 
    """
    bowtie -p $task.cpus -S ${bowtie_index_prefix} <(gunzip -c ${fastq_file}) > ${fastq_file.simpleName}.sam
    """

}

/**
 * This process uses a bowtie genome index from a fasta file. 
 */

process indexingG {

    label 'lowMem'
    label 'medCPU'

    container '/ifb/data/mydatalocal/Next/ReproHackathon/recipes/bowtie.sif'

    // Define the input: genome file in FASTA format 
    input:
    path(genome_fasta_file)

    // Define the output: bowtie index files (differents files, same prefix)
    output:
    path "genome_index.*"

    // Execute bowtie-build
    script: 
    """
    bowtie-build ${genome_fasta_file} genome_index
    """
}