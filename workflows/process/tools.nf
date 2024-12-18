process download {

    container "${projectDir}/apptainer/ubuntu.sif"

    input:
    val(file_name)
    val(url)

    output:
    path "${file_name}"

    script:
    """
    wget -O ${file_name} "${url}"
    """
}