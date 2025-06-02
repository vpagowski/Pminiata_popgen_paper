In this folder you will find scripts used to produce the final vcf file used in the analysis. We tested lots of different filtering parameters - so note this includes just the filtering used for the final analysis - if modifying these scripts be sure to adjust your filtering as necessary or perform a sensitivity analysis to see how different filters impact data. 

The order of operations is:
submit_GVCF.sh 
dbimport.sh
genotype.sh
filter1.sh
ld_prune.sh
filter2.sh
filter3.sh



