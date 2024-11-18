#!/usr/bin/env bash

# Variables
PROFILE='standard,container'
CONFIG=./config/nextflow.config
DOWNLOAD=true
REF="https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=nuccore&id=CP000253.1&rettype=fasta"
GFF=""
IMAGES_NAMES=('ubuntu.sif' 'sratoolkit.sif' 'fastqc.sif' 'trimgalore.sif' 'bowtie.sif' 'samtools.sif' 'featurecounts.sif' 'DESeq2.sif')
IMAGES_PATH=("https://storage.googleapis.com/rrnaseq/ubuntu.sif" "https://storage.googleapis.com/rrnaseq/sratoolkit.sif" \
            "https://storage.googleapis.com/rrnaseq/fastqc.sif" "https://storage.googleapis.com/rrnaseq/trimgalore.sif" \
            "https://storage.googleapis.com/rrnaseq/bowtie.sif" "https://storage.googleapis.com/rrnaseq/samtools.sif" \
            "https://storage.googleapis.com/rrnaseq/featurecounts.sif" "https://storage.googleapis.com/rrnaseq/DESeq2.sif")
BUCKET="https://storage.googleapis.com/rrnaseq/"
MD5SUM_FILE=".MD5SUM"
PROCESS_FILES=("main.nf" "tools.nf" "downloadfastq.nf" "fastqc.nf" "trimgalore.nf" \
            "bowtie.nf" "samtools.nf" "featurecounts.nf" "deseq2.nf")
PROCESS_DIR="process"
CONFIG_FILE="nextflow.config"
NEXTFLOW_DEV_VERSION="24.10"
ERROR=0
WARNING=0
SUCCESS=0
ERROR_ANSI="\e[31m"
WARNING_ANSI="\e[33m"
SUCCESS_ANSI="\e[32m"
STATE_ANSI="\e[35m"
RESET_ANSI="\e[0m"

# Function
function download {
    wget -O "./apptainer/$1" "$2"
    if [ $? -eq 0 ]; then
        echo -e "${SUCCESS_ANSI}SUCCESS${RESET_ANSI}: $1 file has been successfully downloaded"
        return 0
    else
        echo -e "${ERROR_ANSI}ERROR${RESET_ANSI}: $1 file has not been successfully downloaded"
        return 1
    fi
}

function checksum {
    # Check md5sum
    grep "${1}" "${2}" | md5sum -c --status
    if [ $? -eq 0 ]; then
        echo -e "${SUCCESS_ANSI}SUCCESS${RESET_ANSI}: ${1} integrity has been verified"
        return 0
    else
        echo -e "${WARNING_ANSI}WARNING${RESET_ANSI}: ${1} integrity has not been successfully verified"
        return 1
    fi
}

case $1 in
    -l|l|--launch|launch)
        # Images directory
        echo -e "${STATE_ANSI}STATE${RESET_ANSI}: checking apptainer files availability..."
        if [ ! -d apptainer ]; then
            mkdir apptainer
        fi

        # Download images
        for IMAGE_NAME in ${IMAGES_NAMES[@]}; do
            if [ ! -f apptainer/${IMAGE_NAME} ]; then
                URL="${BUCKET}${IMAGE_NAME}"
                echo -e "${STATE_ANSI}STATE${RESET_ANSI}: downloading ${IMAGE_NAME} file..."
                download "${IMAGE_NAME}" "${URL}" && ((++SUCCESS)) || ((++ERROR))
            else
                echo -e "${SUCCESS_ANSI}SUCCESS${RESET_ANSI}: ${IMAGE_NAME} has been found locally .... no download are attempted"
                ((++SUCCESS))
            fi 
        done

        # Is binary md5sum available ?
        if [ ${ERROR} -eq 0 ]; then
            echo -e "${SUCCESS_ANSI}SUCCESS${RESET_ANSI}: all apptainer images have been found locally or downloaded"
            which md5sum > /dev/null
            if [ $? -eq 0 ]; then
                echo -e "BINARY: md5sum .... ${SUCCESS_ANSI}yes${RESET_ANSI}"
                if [ -f ".MD5SUM" ]; then
                    cd apptainer \
                    && echo "Moving to ${PWD}" \
                    && echo -e "${STATE_ANSI}STATE${RESET_ANSI}: checking images md5sum..."
                    for IMAGE_NAME in ${IMAGES_NAMES[@]}; do
                        URL="${BUCKET}${IMAGE_NAME}"
                        checksum ${IMAGE_NAME} "../${MD5SUM_FILE}" || (echo "ATTEMPT: donwloading image file from the cloud repository" \
                        && download ${IMAGE_NAME} ${URL} \
                        && (checksum ${IMAGE_NAME} "../${MD5SUM_FILE}" || (echo -e "${ERROR_ANSI}ERROR${RESET_ANSI}: ${IMAGE_NAME} integrity cannot be approved\n\
                        Pipeline can still be launched manually looking at the help" && ((++ERROR)) )))
                    done
                    cd .. \
                    && echo "Moving to ${PWD}"
                else
                    echo -e "${WARNING_ANSI}WARNING${RESET_ANSI}: MD5SUM file not found: cannot check images validity"
                    ((++WARNING))
                fi  
            else
                echo -e "BINARY: md5sum .... ${ERROR_ANSI}no${RESET_ANSI}"
                echo -e "${WARNING_ANSI}WARNING${RESET_ANSI}: md5sum binary not found: cannot check images validity"
                ((++WARNING))
            fi
        else
            echo -e "${STATE_ANSI}STATE${RESET_ANSI}: apptainer images missing .... skipping md5sum check"
        fi

        # Is config file available ?
        echo -e "${STATE_ANSI}STATE${RESET_ANSI}: checking nextflow config file availability..."
        if [ -d config ]; then
            if [ ! -f config/nextflow.config ]; then
                echo -e "FILE: ${CONFIG_FILE} .... ${ERROR_ANSI}no${RESET_ANSI}"
                echo -e "${ERROR_ANSI}ERROR${RESET_ANSI}: ${CONFIG_FILE} has not been found in the workflow directory"
                ((++ERROR))
            else
                echo -e "FILE: ${CONFIG_FILE} .... ${SUCCESS_ANSI}yes${RESET_ANSI}"
                echo -e "${SUCCESS_ANSI}SUCCESS${RESET_ANSI}: ${CONFIG_FILE} has been found in the workflow directory"
                ((++SUCCESS))
            fi
        else
            echo -e "${ERROR_ANSI}ERROR${RESET_ANSI}: the config directory has not been found"
            ((++ERROR))
        fi

        # Are all nextflow process available ?
        echo -e "${STATE_ANSI}STATE${RESET_ANSI}: checking nextflow process files availability..."
        which sed > /dev/null
        SED_BIN=$?
        if [ -d process ];then
            PROC_2_CONT=0
            for PROCESS_FILE in ${PROCESS_FILES[@]}; do
                if [[ ${PROCESS_FILE} == "main.nf" ]]; then
                    if [ -f ${PROCESS_FILE} ]; then
                        echo -e "FILE: ${PROCESS_FILE} .... ${SUCCESS_ANSI}yes${RESET_ANSI}"
                        ((++SUCCESS))
                    else
                        echo -e "FILE: ${PROCESS_FILE} .... ${ERROR_ANSI}no${RESET_ANSI}"
                        ((++ERROR))
                    fi
                else
                    if [ -f "${PROCESS_DIR}/${PROCESS_FILE}" ]; then
                        echo -e "FILE: ${PROCESS_FILE} .... ${SUCCESS_ANSI}yes${RESET_ANSI}"
                        ((++SUCCESS))
                        # Ensure path to container is correct
                        if [ ${SED_BIN} -eq 0 ]; then
                            echo -e "Ensuring path(s) to container in ${PROCESS_FILE} is/are correct..."
                            echo -e "Path to ${IMAGES_NAMES[${PROC_2_CONT}]}: ${PWD}/apptainer/${IMAGES_NAMES[${PROC_2_CONT}]}"
                            sed -i "/container /c\    container \'${PWD}/apptainer/${IMAGES_NAMES[${PROC_2_CONT}]}\'" "${PROCESS_DIR}/${PROCESS_FILE}"
                        fi
                    else
                        echo -e "FILE: ${PROCESS_FILE} .... ${ERROR_ANSI}no${RESET_ANSI}"
                        ((++ERROR))
                    fi
                    ((++PROC_2_CONT))
                fi
            done
        else
            echo -e "${ERROR_ANSI}ERROR${RESET_ANSI}: the process directory has not been found"
            ((++ERROR))
        fi

        # Is Nextflow binary available ?
        echo -e "${STATE_ANSI}STATE${RESET_ANSI}: checking nextflow availability..."
        which nextflow > /dev/null
        if [ $? -eq 0 ]; then
            echo -e "BINARY: nextflow ... ${SUCCESS_ANSI}yes${RESET_ANSI}"
            ((++SUCCESS))
            echo -e "${STATE_ANSI}STATE${RESET_ANSI}: checking nextflow version..."
            NEXTFLOW_HOST_VERSION=$(nextflow -v)
            echo "Nextflow version: ${NEXTFLOW_HOST_VERSION}"
            if (echo ${NEXTFLOW_HOST_VERSION} | grep ${NEXTFLOW_DEV_VERSION}); then
                echo -e "${SUCCESS_ANSI}SUCCESS${RESET_ANSI}: nextflow host version is in sync with the devel version "
                ((++SUCCESS))
            else
                echo -e "${WARNING_ANSI}WARNING${RESET_ANSI}: nextflow host version is not in sync with the devel version "
                ((++WARNING))
            fi
        else
            echo -e "BINARY: nextflow ... ${ERROR_ANSI}no${RESET_ANSI}" \
            && echo -e "${ERROR_ANSI}ERROR${RESET_ANSI}: nextflow binary not found: cannot launch pipeline"
            ((++ERROR))
        fi

        # Is Apptainer binary available ?
        echo -e "${STATE_ANSI}STATE${RESET_ANSI}: checking apptainer availability..."
        which apptainer > /dev/null
        if [ $? -eq 0 ]; then
            echo -e "BINARY: apptainer ... ${SUCCESS_ANSI}yes${RESET_ANSI}"
            ((++SUCCESS))
        else
            echo -e "BINARY: apptainer ... ${ERROR_ANSI}no${RESET_ANSI}" \
            && echo -e "${ERROR_ANSI}ERROR${RESET_ANSI}: apptainer binary not found: cannot launch pipeline"
            ((++ERROR))
        fi

        # Launch Nextflow Pipeline
        echo -e "SUMMARY: ${SUCCESS} ${SUCCESS_ANSI}success(es)${RESET_ANSI}, ${WARNING} ${WARNING_ANSI}warning(s)${RESET_ANSI}, ${ERROR} ${ERROR_ANSI}error(s)${RESET_ANSI}"
        if [ ${ERROR} -eq 0 ]; then
            echo -e "${STATE_ANSI}STATE${RESET_ANSI}: Lauching pipeline..."
            nextflow run main.nf -profile ${PROFILE} -c ${CONFIG} --download ${DOWNLOAD} --refg ${REF}
        else
            echo -e "${STATE_ANSI}STATE${RESET_ANSI}: pipeline cannot be launched"
            echo "Solve the error(s) and try executing the launcher"
            echo "Attempting to launch the pipeline manually is possible but be aware that the proper functioning of pipeline is not assured"
        fi
        ;;
    -c|c|--cmd|cmd)
        echo -e "nextflow run main.nf -profile ${PROFILE} -c ${CONFIG} --download ${DOWNLOAD} --refg \"${REF}\""
        ;;
    -h|h|--help|help)
        echo "Nextflow pipeline to execute a RNASeq analysis"
        echo "Written by leo.jourdain@etu-upsaclay.fr, jaffar.gura@etu-upsaclay.fr, mappathe.faye@etu-upsaclay.fr, levy@etu-upsaclay.fr"
        echo "Repository: https://github.com/LeoooJR/ReproHackathon"
        echo "Arguments:"
        echo -e "\t-l|l|--launch|launch): launch the RNASeq pipeline"
        echo -e "\t-c|c|--cmd|cmd): generate the nextflow command to launch the pipeline manually"
        echo -e "\t-h|h|--help|help): get help about the RNASeq pipeline"
        ;;
    *)
        echo "Invalid option: try help for more information"
        ;;
esac
