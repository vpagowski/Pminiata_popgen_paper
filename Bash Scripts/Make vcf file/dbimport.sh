#!/bin/bash
#
#SBATCH -- insert your batch commands here

ml biology gatk
samples=$(find ./ | sed 's/.\///' | grep -E '.g.vcf.gz$' | sed 's/^/--variant /')
gatk --java-options "-Xmx50g -XX:ParallelGCThreads=20" GenomicsDBImport $(echo $samples) --genomicsdb-workspace-path ./db3 --intervals Pmin_interval.list
