process deseq2 {

    label 'medCPU'

    container ''

    publishDir "${params.outputDir}/R", mode: 'copy', overwrite: true, pattern: "*.jpg"

    input:
    path(count_table)

    output:
    path "*.jpg"

    script:
    """
    Rscript ${projectDir}/scripts/DESeq2.R
    """
}