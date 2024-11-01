#!/usr/bin/env nextflow 

/**
 * Run the featureCounts tool in order to quantify aligned reads in BAM files
 * using a GTF annotation file
 * Input : - BAM files containing sequencing alignements 
 *         - GTF file for genomic annotation
 * Output : - TXT file containing the counting of reads for each gene 
 */


process featureCounts {

    label 'medMem'
    label 'medCPU'

    // Define the Singularity container to be used for running featureCounts
    container 'featurecounts.sif'
    
    // Define the input : path to the bam_files and path to the annotation file
    input:
    path(bam_files), emit: bam
    path(annotation_file)

    // Define the output: the text file containing the count of reads for each gene
    path "*.txt", emit: counts // one txt file per bam file or just one depending on the input

    // Execute featureCounts with the specified number of threads
    script:
    """

    featureCounts -T $task.cpus -a ${annotation_file} -o counts.txt ${bam_files}
    """
}