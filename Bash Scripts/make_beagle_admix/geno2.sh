#!/bin/bash
#
#SBATCH -- insert your batch commands here
#generate a large beagle file to work with

#FOLLOWING tutorial with modifications from https://github.com/nt246/lcwgs-guide-tutorial/tree/main (cited in manuscipt)

# Run:
#mafs file produced from running angsd in previous step

zcat Pmin_lc_genolike3_e6_maf0.05_LDpruned_R1+R2_minind117.mafs.gz | cut -f 1,2 | tail -n +2 > Test_pos.txt
NS ='cat Test_pos.txt | wc -l' # number used in next script

#Then - worthwile to split into chunks
/path_to/ngsLD/ngsLD --geno Pmin_lc_genolike3_e6_maf0.05_LDpruned_R1+R2_minind117.beagle.gz --probs --pos Test_pos.txt --n_ind 233 --n_sites $NS --max_kb_dist 10 --n_threads 24 --rnd_sample 0.005 --min_maf 0.05 --out ${OUTPUT}.ld
#--rnd_sample flag does not seem to work to downsample, this therefore takes a long time.

#Then follow tutorial for correct ANGSD input formatting
awk -F":" '{print $2}' ${OUTPUT}.ld > ${OUTPUT}_positions.txt
zcat "Pmin_lc_genolike3_e6_maf0.05_LDpruned_R1+R2_minind117.mafs.gz" | awk 'NR==1 || $0 ~ /^[^#]/ {print $1, $2, $3, $4}' > "${OUTPUT}_snp_list.txt"
awk 'NR==FNR {positions[$1]; next} $2 in positions' ${OUTPUT}_positions.txt ${OUTPUT}_snp_list.txt > ${OUTPUT}_snp_list_LDpruned_snps.list
angsd sites index ${OUTPUT}_snp_list_LDpruned_snps.list
