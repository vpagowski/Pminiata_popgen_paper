#!/bin/bash
#
#SBATCH -- insert your batch commands here

module load biology vcftools
vcftools --vcf all_lc_Patiria_genotypes.vcf --remove-indels --maxDP 100 --mac 4 --minQ 20 --maf 0.02 --recode --stdout  > all_lc_Patiria_genotypes_part1.vcf_filtermaf0.02.vcf
# maf actually set to 0.05 in subsequent filters, may need to bgzip and tabix file for next steps
