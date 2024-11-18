nextflow.enable.dsl=2

params.download = true
params.fastq = "${params.outputDir}/FASTQ"
params.refg = 'https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=nuccore&id=CP000253.1&rettype=fasta'
params.gff = 'https://www.ncbi.nlm.nih.gov/sviewer/viewer.cgi?db=nuccore&report=gff3&id=CP000253.1'

// Import process
include { downloadfastq } from './process/downloadfastq.nf'
include { fastqc } from './process/fastqc.nf'
include { trimgalore } from './process/trimgalore.nf'
include { mapping } from './process/bowtie.nf'
include { indexingG } from './process/bowtie.nf'
include { featureCounts } from './process/featurecounts.nf'
include { download as downloadREF } from './process/tools.nf'
include { download as downloadGFF } from './process/tools.nf'
include { samtools } from './process/samtools.nf'

workflow {
    // List of SRA identifiers to be processed
    sra_ids = channel.fromList(['SRR10379721','SRR10379722','SRR10379723','SRR10379724','SRR10379725','SRR10379726'].sort())

    // Iterate over each SRA identifier
    // Download FASTQ files for the current SRA identifier
    if(params.download) {
        fastq_file = downloadfastq(sra_ids)
    }
    else {
        fastq_file = sra_ids.merge(channel.fromPath("${params.fastq}/*.fastq.gz").toSortedList().flatten())
    }

    // Run FastQC on each downloaded FASTQ file
    fastqc(fastq_file)

    // Trimming each download FASTQ file
    trimmedFASTQ = trimgalore(fastq_file)

    if(params.refg ==~ /^http.*/){
        genome = downloadREF("reference.fasta",params.refg)
    }
    else {
        genome = params.refg
    }

    if(params.gff ==~ /^http.*/){
        gff = downloadGFF("reference.gff",params.gff)
    }
    else {
        gff = params.gff
    }

    // Bowtie indexing
    genomeI = indexingG(genome)

    // Bowtie Mapping
    readM = mapping(trimmedFASTQ,genomeI)

    //Samtools
    samtools(readM)

    // FeatureCounts
    featureCounts(samtools.out.bamS.collect(),gff)

}
