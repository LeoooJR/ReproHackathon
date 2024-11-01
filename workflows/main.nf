nextflow.enable.dsl=2

// Import process
include { downloadfastq } from './process/downloadfastq.nf'
include { fastqc } from './process/fastqc.nf'

workflow {
    // List of SRA identifiers to be processed
    sra_ids = ['SRX7080617','SRX7080616','SRX7080615','SRX7080614','SRX7080613','SRX7080612']

    // Iterate over each SRA identifier
    sra_ids.each { id ->
        // Download FASTQ files for the current SRA identifier
        fastq_file = downloadfastq(id)

        // Run FastQC on each downloaded FASTQ file
        fastqc(fastq_file)
    }
}