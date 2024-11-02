#!/usr/bin/env bash

PROFILE='standard,container'
CONFIG=/ifb/data/mydatalocal/Next/ReproHackathon/workflows/config/nextflow.config
DOWNLOAD=true
REF="https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=nuccore&id=CP000253.1&rettype=fasta"

nextflow run main.nf -profile ${PROFILE} -c ${CONFIG} --download ${DOWNLOAD} --refg ${REF}
