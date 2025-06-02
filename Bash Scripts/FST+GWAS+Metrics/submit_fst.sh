#!/bin/bash
#
#SBATCH -- insert your batch commands here
#generate a large beagle file to work with

#cluster file contains all population assignments - see plink documentation for details.

plink --bfile FINAL_R1_R2_geno0.8_mindpop0.5  --fst --within all_pops.clust --out $1_$2_R2_mindpop0.5_fst --allow-extra-chr --keep-cluster-names $1 $2 --double-id
