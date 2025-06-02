#!/bin/bash
#
#SBATCH -- insert your batch commands here

ml biology gatk

gatk --java-options "-Xmx30g -XX:ParallelGCThreads=20" GenotypeGVCFs --intervals Pmin_interval.list \
    -R /path_to/GCF_015706575.1_ASM1570657v1_genomic.fna \
    -V gendb://db3 \ #whatever you'd like database name to be
    -O all_lc_Patiria_genotypes.vcf
