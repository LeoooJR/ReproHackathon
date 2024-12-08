process multiqc {

    label 'lowCPU'
    
    container "${projectDir}/apptainer/multiqc.sif"
    
    publishDir "${params.outputDir}/MULTIQC", mode: 'symlink', pattern: "multiqc_report.html"
        
    input:
    path(fastqcBT)
    path(fastqcAT)
        
    output:
    path("multiqc_report.html"), emit: report
        
    script:
    """
    multiqc ./
    """   
}