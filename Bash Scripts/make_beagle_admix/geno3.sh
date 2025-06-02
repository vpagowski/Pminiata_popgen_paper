#!/bin/bash
#
#SBATCH -- insert your batch commands here

#FOLLOWING tutorial with modifications from https://github.com/nt246/lcwgs-guide-tutorial/tree/main (cited in manuscipt). This takes very long - split up by chromosome etc.

angsd -GL 2 -out $OUTPUT_beagle -nThreads 25 -doGlf 2 -doMajorMinor 3 -doMaf 1 -doPost 1 -doIBS 1 -doCounts 1 -doCov 1 -makeMatrix 1 -sites ${OUTPUT}_unlinked_pruned_positions_LDpruned_snps.list -bam old_new_bams_rmreseq.filelist -minInd 117 -minMapQ 20 -minQ 20 -minMaf 0.05
