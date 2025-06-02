#!/bin/bash
#where inputs 1 and 2 come from an excel spreadsheet with 1 = chromosome, 2= population, allowing quick loop through
#same master/submit format as our other scripts.
module load biology vcftools

#Make individual scaffold and population VCFs that contain specific scaffold and population
plink --vcf $INPUT_VCF --recode vcf --out ./$2/$1_$2_rev3_mindpop0.5.vcf --allow-extra-chr --double-id --keep-cluster-names $2 --within all_pop.clust

#Generate SweepFinder2 input
vcftools --vcf ./$2/$1_$2_rev3_mindpop0.5.vcf.vcf --counts2 --out ./$2/$1_$2_rev3_mindpop0.5.temp
tail -n+2 ./$2/$1_$2_rev3_mindpop0.5.temp.frq.count | awk -v OFS="\t" '{print $2,$6,$4,"1"}' > ./$2/$1_$2_rev2_mindpop0.5.in
echo -e 'position\tx\tn\tfolded' | cat - ./$2/$1_$2_rev3_mindpop0.5.in > temp && mv temp ./$2/$1_$2_rev3_mindpop0.5.in
echo $1
SweepFinder2 -sg 1000 ./$2/$1_$2_rev3_mindpop0.5.in ./$2/$1_$2_rev3_mindpop0.5.in.out

#R scripts used to plot these output files
