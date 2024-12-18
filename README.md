<a name="top"></a>
# ReproHackathon RNASeq Pipeline
[![Nextflow Version](https://img.shields.io/badge/Nextflow-24.10-brightgreen)](https://www.nextflow.io)
[![Apptainer Version](https://img.shields.io/badge/Apptainer-1.3.2-blue)](https://apptainer.org)
[![Bowtie Version](https://img.shields.io/badge/Bowtie-0.12.7-lightgrey)](http://bowtie-bio.sourceforge.net/index.shtml)
[![DESeq2 Version](https://img.shields.io/badge/DESeq2-1.16.1-purple)](https://bioconductor.org/packages/release/bioc/html/DESeq2.html)
[![SRA Toolkit Version](https://img.shields.io/badge/SRA%20Toolkit-3.1.1-green)](https://github.com/ncbi/sra-tools)
[![Trim Galore Version](https://img.shields.io/badge/Trim%20Galore-0.6.10-teal)](https://github.com/FelixKrueger/TrimGalore)
[![FastQC Version](https://img.shields.io/badge/FastQC-0.12.1-blue)](https://www.bioinformatics.babraham.ac.uk/projects/fastqc/)
[![featureCounts Version](https://img.shields.io/badge/featureCounts-1.4.6-orange)](http://bioinf.wehi.edu.au/featureCounts/)
[![Samtools Version](https://img.shields.io/badge/Samtools-1.21-red)](http://www.htslib.org/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://github.com/LeoooJR/ReproHackathon/blob/main/LICENSE.md)
[![GitHub last commit](https://img.shields.io/github/last-commit/LeoooJR/ReproHackathon)](#)
[![Reproducibility](https://img.shields.io/badge/Crucial-Reproducibility-orange)]()

## 📑 Table of Contents
- [About](#about)
- [Setup and Installation](#setup-and-installation)
- [How to Use](#how-to-use)
- [Contributors](#contributors)
- [Contacts](#contacts)


## 🧬 About <a name="about"></a>

**ReproHackathon RNASeq Pipeline** aims to reproduce findings from [*Peyrusson et al.* (Nature Communications, 2020)](https://www.nature.com/articles/s41467-020-15966-7) on the transcriptomic profile of *Staphylococcus aureus* persisters under antibiotic stress. This study highlights how *S. aureus* persisters—cells that tolerate antibiotics without genetic resistance—may contribute to therapeutic failures by acting as reservoirs for recurring infections. Unlike resistant bacteria, persisters adopt a reversible, non-growing state within host cells, possibly due to growth arrest or active stress response mechanisms.

Built with [Nextflow](https://www.nextflow.io) and [Apptainer (formerly Singularity)](https://apptainer.org), this pipeline uses RNA-Seq to study transcriptomic changes and identify factors influencing antibiotic persistence and tolerance. It includes genome mapping, read counting, and differential expression analysis to capture the complex adaptation of *S. aureus* under stress. Key transcriptomic insights from the study include the activation of responses like the stringent response, cell wall stress, SOS, and heat shock responses, which together promote antibiotic tolerance across multiple drug classes.

### Key Features
- **High Reproducibility**: Leveraging containers and Nextflow ensures easy deployment and consistent results across systems.
- **Data Analysis**: Includes genome mapping, read counting, and statistical analysis to identify differentially expressed genes (DEGs).
- **Modular Workflow**: Nextflow's flexible design allows for easy customization and expansion of the pipeline. The apptainer images are also modulairzed and already built and hosted in the cloud.

## 🔧 Setup and Installation <a name="setup-and-installation"></a>

### Requirements
- **Nextflow** `v24.10.0+`
- **Apptainer** `v1.3.2+`
- **Hardware**: 8 cores & 8 GB RAM minimum

### Installation Instructions
```bash
# Clone this repository
git clone https://github.com/LeoooJR/ReproHackathon.git
cd ReproHackathon

# Set up Apptainer/Nextflow if not already installed
# For Nextflow installation:
curl -s https://get.nextflow.io | bash
# For Apptainer installation, see: https://apptainer.org/docs/user/main/quick_start.html#installation
# Using Conda: 
conda install apptainer

# If necessary for Apptainer
sudo apt install uidmap

# Launch the pipeline
chmod +x ./workflow.sh
./workflow.sh --launch
```

## 🚀 How to Use <a name="how-to-use"></a>

### Launch the Pipeline
To start the pipeline, use:
```sh
./workflow.sh <l,-l,launch,--launch>
```

### Additional Commands
- **Get help**: `./workflow.sh <h,-h,help,--help>`
- **Get Nextflow command**: `./workflow.sh <c,-c,cmd,--cmd>`

## 👥 Contributors <a name="contributors"></a>
This project was developed by:
- [Léo Jourdain](https://github.com/LeoooJR)
- [Jaffar Gura](https://github.com/Jaffar-Hussein)
- [Mapathé Faye](https://github.com/Mapathefaye)
- [Lévy Meliga Yonguet](https://github.com/lmeliga)

## 🗨️ Contacts <a name="contacts"></a>

For questions, feel free to reach out to the maintainers through GitHub or connect on LinkedIn.

[Back to top](#top)
