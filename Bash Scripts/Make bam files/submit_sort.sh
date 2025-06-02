#!/bin/bash
#
#SBATCH -- insert your batch commands here
#SBATCH --wait #this will prevent the next script from running until previous job finishes

module load biology samtools
samtools sort $1 $2 $3
