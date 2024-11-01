#!/usr/bin/env bash

PROFILE='standard,container'

nextflow run main.nf -profile ${PROFILE} -c /home/ubuntu/data/mydatalocal/Next/ReproHackathon/workflows/config/nextflow.config