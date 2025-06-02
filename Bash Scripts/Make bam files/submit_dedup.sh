#!/bin/bash
#
#SBATCH -- insert your batch commands here
#SBATCH --wait #this will prevent the next script from running until previous job finishes

java -jar /path_to/picard.jar MarkDuplicates $1 $2 $3 $4 $5 $6 $7
