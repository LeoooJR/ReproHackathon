#!/usr/bin/env nextflow

/**
 * This process downloads the reference genome annotations file using wget.
 */

process download_annot {
    // Define the output
    output:
    path 'reference.gff'

    // Execute wget to download 
    script: 
    """

    wget -O reference.gff "https://www.ncbi.nlm.nih.gov/sviewer/viewer.cgi?db=nuccore&report=gff3&id=CP000253.1"
    """
}