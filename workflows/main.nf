nextflow.enable.dsl=2

// Import process
include { downloadfastq } from './downloadfastq.nf'
include { runfastqc } from './runfastqc.nf'

workflow {
    // List of SRA identifiers to be processed
    sra_ids = ['SRR10379721']

    // Iterate over each SRA identifier
    sra_ids.each { id ->
        // Download FASTQ files for the current SRA identifier
        fastq_file = downloadfastq(id)

        // Run FastQC on each downloaded FASTQ file
        runfastqc(fastq_file)
    }
}