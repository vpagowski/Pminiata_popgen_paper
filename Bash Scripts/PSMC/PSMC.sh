#!/bin/bash
#Except custom settings for time and interval parameters, this is directly from PSMC and beta-PSMC documentation

ml biology bcftools
ml gcc
ml biology htslib

bcftools mpileup -C50 -f /path_to/GCF_015706575.1_ASM1570657v1_genomic.fna $FINAL_BAM | bcftools call -c - | vcfutils.pl vcf2fq -d 10 -D 150 | gzip > ${FINAL_BAM}_psmc.fq.gz

fq2psmcfa -q20 ./${FINAL_BAM}_psmc.fq.gz > ${FINAL_BAM}.psmcfa  #use compiled programs to generate consensus sequences
splitfa ${FINAL_BAM}.psmcfa > ${FINAL_BAM}_split.psmcfa #for bootstrapping make split rearangements of fasta file
psmc -N25 -p "26*2+4+7+1" -o ${FINAL_BAM}.psmc ${FINAL_BAM}.psmcfa #actual psmc command
seq 100 | xargs -i -n 1 -P 8  echo psmc -N25 -b -p "26*2+4+7+1" -o ${FINAL_BAM}_round_{}.psmc ${FINAL_BAM}_split.psmcfa  | sh #run bootstrap
cat ${FINAL_BAM}.psmc ${FINAL_BAM}_round_*.psmc > ${FINAL_BAM}_combined.psmc
# this output then processed with
psmc_plot.pl -R -u 9.13e-09 -g 5 ${FINAL_BAM}_gen5_9.13e-9 ${FINAL_BAM}_combined_boots.psmc
#generations initially set to 5 years

#For beta-PSMC this is just slightly modified
/path_to/Beta-PSMC/beta-psmc -N25 -r5 -B5 -t15 -o ${FINAL_BAM}_b20.psmc ${FINAL_BAM}.psmcfa -p 20*1 #initial rho set to 5, time intervals default
seq 40 | xargs -i -n 1 -P 8  echo /path_to/Beta-PSMC/beta-psmc -N25 -r5 -B5 -t15 -p 20*1 -o ${FINAL_BAM}_r3_{}.psmc ${FINAL_BAM}_split.psmcfa | sh
