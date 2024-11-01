nextflow.enable.dsl=2

params.download = true
params.fastq = "${params.outputDir}/FASTQ"

// Import process
include { downloadfastq } from './process/downloadfastq.nf'
include { fastqc } from './process/fastqc.nf'
include { trimgalore } from './process/trimgalore.nf'

workflow {
    // List of SRA identifiers to be processed
    sra_ids = channel.fromList(['SRR10379721','SRR10379722','SRR10379723','SRR10379724','SRR10379725','SRR10379726'])

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

    trimgalore(fastq_file.map { it[1] })
}
