/**
 * Run the featureCounts tool in order to quantify aligned reads in BAM files
 * using a GTF annotation file
 * Input : - BAM files containing sequencing alignements 
 *         - GFF file for genomic annotation
 * Output : - TXT file containing the counting of reads for each gene 
 */


process featureCounts {

    label 'medCPU'

    container ''

    publishDir "${params.outputDir}/FEATURECOUNTS", mode: 'symlink', pattern: "featureCounts.txt"
    
    // Define the input : path to the bam_files and path to the annotation file
    input:
    path(bam_files)
    path(annotation_file)

    // Define the output: the text file containing the count of reads for each gene
    output:
    path "*.txt" // one txt file per bam file or just one depending on the input

    // Execute featureCounts with the specified number of threads
    script:
    """
    featureCounts -t gene -g ID -F GFF -T $task.cpus -a ${annotation_file} -o featureCounts.txt ${bam_files}
    """
    
}