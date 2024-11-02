process samtools {

    label 'medCPU'
    label 'medMem'

    input:
    path(bam)

    output:
    path "${bam.getBaseName()}.bam"

    script:
    """
    samtools sort -@ 2 -o ${bam.getBaseName()}.bam ${bam}
    samtools index  -@ 2 ${bam.getBaseName()}.bam
    """
}