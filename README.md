<a name="top"></a>

![Nextflow Version](https://img.shields.io/badge/24.10-white?style=for-the-badge&label=Nextflow&labelColor=green)
![Apptainer Version](https://img.shields.io/badge/1.3.2-white?style=for-the-badge&label=Apptainer&labelColor=blue)
[![RNASeq](https://img.shields.io/badge/RNASeq-Research-orange?style=for-the-badge)](#)
[![License](https://img.shields.io/badge/license-MIT-blue?style=for-the-badge)](#license)


## 📑 Table of Contents
- [About](#about)
- [Setup and Installation](#setup-and-installation)
- [How to Use](#how-to-use)
- [Contributors](#contributors)
- [Contacts](#contacts)

## 🧬 About <a name="about"></a>

**ReproHackathon RNASeq Pipeline** is a collaborative project developed during the ReproHackathon. This RNASeq analysis pipeline, built with [Nextflow](https://www.nextflow.io) and [Apptainer (formerly Singularity)](https://apptainer.org), is designed for reproducible research on the **Staphylococcus aureus** RNASeq dataset under antibiotic stress.

### Key Features
- **High Reproducibility**: Leveraging containers and Nextflow ensures easy deployment and consistent results across systems.
- **Data Analysis**: Includes genome mapping, read counting, and statistical analysis to identify differentially expressed genes (DEGs).
- **Modular Workflow**: Nextflow's flexible design allows for easy customization and expansion of the pipeline.

## 🔧 Setup and Installation <a name="setup-and-installation"></a>

To run the RNASeq pipeline, you need to have the following installed:
- **Nextflow** (v24.10.0 or higher)
- **Apptainer** (v1.3.2 or higher)

### Installation Instructions
```sh
# Clone this repository
git clone https://github.com/username/repo.git](https://github.com/LeoooJR/ReproHackathon.git
cd ReproHackathon

# Set up Apptainer/Nextflow if not already installed
# For Nextflow installation:
curl -s https://get.nextflow.io | bash
# For Apptainer installation, see: https://apptainer.org/docs/getting-started/

# Launch the pipeline
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
- [Mapathe Faye](https://github.com/Mapathefaye)
- [Younget Lévy Meliga](https://github.com/lmeliga)

## 🗨️ Contacts <a name="contacts"></a>

For questions, feel free to reach out to the maintainers through GitHub or connect on LinkedIn.

[Back to top](#top)
