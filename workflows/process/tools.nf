process download {

    input:
    val(file_name)
    path(url)

    output:
    path "${file_name}"

    script:
    """
    wget -O ${file_name} ${url}
    """
}