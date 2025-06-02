#!/bin/bash
#
#SBATCH -- insert your batch commands here
#generate a large beagle file to work with

#FOLLOWING tutorial with modifications from https://github.com/nt246/lcwgs-guide-tutorial/tree/main (cited in manuscipt). This takes very long - split up by chromosome etc.

python /path_to/pcangsd.py -beagle $OUTPUT_beagle -o ${OUTPUT_beagle}_pca -threads 32 -filter removeHGC.txt #added when subset plotting without Haida Gwaii and Central BC

#for plots without scaffold 64 and 65 this scaffold was removed before running this command again
