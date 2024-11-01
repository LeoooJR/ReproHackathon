#!/usr/bin/env bash

PROFILE='standard,container'

nextflow run main.nf -profile ${PROFILE}