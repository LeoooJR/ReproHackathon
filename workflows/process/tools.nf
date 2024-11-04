process download {

    container '/ifb/data/mydatalocal/Next/ReproHackathon/recipes/ubuntu.sif'

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