#!/bin/bash
#
# Here, we'll filter my max-missingness of 50%, but only for populations with sample sizes > 8 included, and applied to each population (rather than entire dataset). This produced better results - few falsely high Fst values due to missing data in specific locations only for some populations.

#Make lists of populations to include
for pop in $(awk '{print $6}' $INPUT.fam | sort | uniq); do   awk -v p="$pop" '$6==p{print $1, $2}' $INPUT.fam > ${pop}.keep;  plink --bfile $INPUT --keep ${pop}.keep --make-bed --out $INPUT_${pop} --allow-extra-chr --double-id;   plink --bfile $INPUT_${pop} --geno 0.5 --make-bed --out $INPUT_${pop}.filtered --allow-extra-chr --double-id --biallelic-only; done

#Now create respective VCFs
for pop in $(awk '{print $6}' $INPUT.fam | sort | uniq); do
   awk -v p="$pop" '$6==p{print $1}' $INPUT.fam > ${pop}.samples

   # Subset VCF and filter by max-missing for this population
   vcftools --gzvcf $INPUT_VCF_after_filters  \
            --keep ${pop}.samples \
            --max-missing 0.5 \
            --recode \
            --recode-INFO-all \
            --out $INPUT_${pop}.filtered
done

#Then, bgzip and tabix each file before merging with plink or bcftools
plink --bfile $INPUT_${pop1}.filtered --merge-list merge_list.txt --make-bed --out merged_all --allow-extra-chr --double-id --biallelic-only

#Finally filter the file again with plink using flags:
--geno 0.8
