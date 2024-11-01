nextflow.enable.dsl=2

// Import process
include { downloadfastq } from './process/downloadfastq.nf'
include { fastqc } from './process/fastqc.nf'

workflow {
    // List of SRA identifiers to be processed
    sra_ids = channel.fromList(['SRR10379721','SRR10379722','SRR10379723','SRR10379724','SRR10379725','SRR10379726'])

    // Iterate over each SRA identifier
    // Download FASTQ files for the current SRA identifier
    fastq_file = downloadfastq(sra_ids)

    // Run FastQC on each downloaded FASTQ file
    fastqc(fastq_file)
}
