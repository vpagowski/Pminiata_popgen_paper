#!/bin/bash
#
#SBATCH -- insert your batch commands here
#SBATCH --wait #this will prevent the next script from running until previous job finishes

module load biology bwa
bwa mem -t 20 /path_to_genome/GCF_015706575.1_ASM1570657v1_genomic.fna $1 $2 > $3
