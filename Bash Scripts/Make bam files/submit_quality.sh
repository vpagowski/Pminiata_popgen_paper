#!/bin/bash
#
#SBATCH -- insert your batch commands here
#SBATCH --wait #this will prevent the next script from running until previous job finishes

skewer -m pe -Q 20  -x adapter.fa --end-quality 28 $1 $2 $3 $4
