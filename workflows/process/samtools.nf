process samtools {

    label 'lowCPU'
    
    container '/ifb/data/mydatalocal/Next/ReproHackathon/recipes/samtools.sif'

    input:
    path(sam)

    output:
    path "${sam.simpleName}.sorted.bam", emit: bamS
    path "${sam.simpleName}.sorted.bam.bai", emit: bamI

    script:
    """
    samtools sort -@ ${task.cpus} -o ${sam.simpleName}.sorted.bam ${sam}
    samtools index  -@ ${task.cpus} ${sam.simpleName}.sorted.bam
    """
}