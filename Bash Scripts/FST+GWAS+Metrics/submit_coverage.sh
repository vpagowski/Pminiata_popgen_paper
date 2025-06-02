#!/bin/bash
#SBATCH -- insert your batch commands here

#generate average and stdev coverage for each samples
#These values exported to csv from the final plots
samtools depth $1 |  awk '{sum+=$3; sumsq+=$3*$3} END { print "Average = ",sum/NR; print "Stdev = ",sqrt(sumsq/NR - (sum/NR)**2)}' > $2
