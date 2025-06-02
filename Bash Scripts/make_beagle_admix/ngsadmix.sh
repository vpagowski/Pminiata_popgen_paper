#!/bin/bash
#
#SBATCH -- insert your batch commands here
#generate a large beagle file to work with

#Where $NUM is 1-5

NGSadmix -P 24 -maxiter 500 -likes $OUTPUT_beagle -K $NUM -o ${OUTPUT_beagle}_ADMIX
