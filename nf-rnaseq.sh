#!/bin/bash
#SBATCH --account=PAS0471
#SBATCH --time=1:00:00
#SBATCH --mail-type=END,FAIL
#SBATCH --output=slurm-nf-rnaseq-%j.out
set -euo pipefail

# Settings and constants
WORKFLOW_FILE=/fs/ess/PAS0471/jelmer/teach/misc/2024-06_nextflow/prep/sessions/20240801/rnaseq.nf

# Load the Nextflow Conda environment
module load miniconda3/24.1.2-py310
conda activate /fs/ess/PAS0471/jelmer/conda/nextflow
export NXF_SINGULARITY_CACHEDIR=/fs/ess/PAS0471/containers

# Process command-line arguments
if [[ ! "$#" -eq 4 && ! "$#" -eq 5 ]]; then
    echo "ERROR: wrong number of arguments - you provided $#, while 4 or 5 are required."
    echo "Usage: sbatch nf-rnaseq.sh <fastq-dir> <transcriptome> <outdir> <workdir> [<opts>]"
    exit 1
fi
reads=$1
transcriptome=$2
outdir=$3
workdir=$4
more_opts=${5:-}

# Report
echo "Starting script nf-rnaseq.sh"
date
echo "Dir with input FASTQ files:           $reads"
echo "Reference transcriptome FASTA:        $transcriptome"
echo "Output dir:                           $outdir"
echo "Nextflow work dir:                    $workdir"
[[ -n "$more_opts" ]] && echo "Additional options:                   $more_opts"
echo

# Run the workflow
nextflow run "$WORKFLOW_FILE" \
    --transcriptome_file "$transcriptome" \
    --reads "$reads" \
    --outdir "$outdir" \
    -work-dir "$workdir" \
    -profile slurm \
    -ansi-log false \
    -resume \
    $more_opts

# Report
echo "Done with script nfc-rnaseq.sh"
date
