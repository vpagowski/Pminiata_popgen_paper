#!/bin/bash
#
#SBATCH -- insert your batch commands here
#generate a large beagle file to work with - in this case a SNP occurs in 117 individuals, 233 in total analyzed

#Also used: minInd = 10 for sex differences

angsd -GL 2 -out Pmin_lc_genolike3_e6_maf0.05_LDpruned_R1+R2_minind117 -nThreads 25 -doGlf 2 -doMajorMinor 1 -SNP_pval 1e-6 -doMaf 1 -bam old_new_bams_rmreseq.filelist -minMaf 0.05 -minInd 117 -minMapQ 25 -minQ 25
