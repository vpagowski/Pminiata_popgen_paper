#!/bin/bash
#
#
plink --bfile ${INPUT_COMBINED_FILES} --recode vcf --geno 0.8 --out ${FINAL_VCF} --allow-extra-chr 
