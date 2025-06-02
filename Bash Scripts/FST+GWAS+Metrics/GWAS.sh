#!/bin/bash
#
#SBATCH -- insert your batch commands here

#$FINAL_VCF in bim/bam.bed plink format generated from make vcf file scripts
#corr_pheno - regressed covariates and PCS

plink --bfile $FINAL_VCF --assoc --pheno corr_pheno.txt  --allow-no-sex --allow-extra-chr --out $OUTPUT_corrected_GWAS --remove-fam $OPTIONAL --adjust

#remove fam included when removing Haida Gwaii and Central samples
