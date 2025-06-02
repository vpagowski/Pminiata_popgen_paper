#!/bin/bash
#
#SBATCH -- insert your batch commands here
module load biology gatk #different in your cluster
gatk --java-options "-Xmx30g -XX:ParallelGCThreads=30" HaplotypeCaller -R /path_to/GCF_015706575.1_ASM1570657v1_genomic.fna -I $1 -O $2 -ERC GVCF
