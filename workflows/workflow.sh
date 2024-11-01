#!/usr/bin/env bash

PROFILE='standard,container'
CONFIG=/ifb/data/mydatalocal/Next/ReproHackathon/workflows/config/nextflow.config

nextflow run main.nf -profile ${PROFILE} -c ${CONFIG}
