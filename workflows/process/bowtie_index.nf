#!/usr/bin/env nextflow

/**
 * This process uses a bowtie genome index from a fasta file. 
 */


process bowtie_index {

    label 'medMem'
    label 'medCPU'

    // Define the Singularity container to be used for running bowtie
    container 'bowtie.sif'

    // Define the input: genome file in FASTA format 
    input:
    path(genome_fasta_file)

    // Define the output: bowtie index files (differents files, same prefix)
    output:
    path "genome_index.*", emit: index

    // Execute bowtie-build
    script: 
    """
    bowtie-build ${genome_fasta_file} genome_index
    """
}