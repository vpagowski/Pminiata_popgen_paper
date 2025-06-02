#!/bin/bash
#
#SBATCH -- insert your batch commands here

plink --vcf ${IN_VCF}  --allow-extra-chr --indep-pairwise 200 20 0.5  --out ${PRUNED_VCF} --double-id --set-missing-var-ids @:#[Pmin]

plink --vcf ${IN_VCF} --allow-extra-chr --extract ${PRUNED_VCF}.prune.in --out ${OUTPUT_VCF} --pca --double-id  -—maf 0.05 --make-bed --set-missing-var-ids @:#[Pmin]
