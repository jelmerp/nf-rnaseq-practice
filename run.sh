#!/bin/bash

# Run the pipeline
reads="data/ggal/*_{1,2}.fq"
transcriptome=data/ggal/transcriptome.fa #! abs path needed because transcriptome is used directly (no channel created) 
outdir=results
workdir=work
bash nf-rnaseq.sh "$reads" "$transcriptome" "$outdir" "$workdir" "--dummy1 X --dummy2 Z"
sbatch nf-rnaseq.sh "$reads" "$transcriptome" "$outdir" "$workdir" "--dummy1 X --dummy2 Z"

# Create a Git repo
module load git/2.39.0
git init
echo -e "data/\nwork/\nresults/\n.nextflow*" > .gitignore && cat .gitignore
echo -e "# A practice Nextflow workflow" > README.md  && cat README.md
git add --all && git status
git commit -m "Init commit"
