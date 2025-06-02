#!/bin/bash
        cat Sample_names.csv | parallel --verbose -j 30 sbatch submit_quality.sh /path_to/{}_L002_R1_001.fastq.gz /path_to/{}_L002_R2_001.fastq.gz -o ./S1_fastq_trim/{} & export pid1=$!
        sh wait.sh $pid1 && cat Sample_names.csv | parallel --verbose -j 30 sbatch submit_fastqc.sh ./S1_fastq_trim/{}-trimmed-pair1.fastq ./S1_fastq_trim/{}-trimmed-pair2.fastq & export pid2=$!
        sh wait.sh $pid1 && cat Sample_names.csv | parallel --verbose -j 30 sbatch submit_bwa.sh ./S1_fastq_trim/{}-trimmed-pair1.fastq ./S1_fastq_trim/{}-trimmed-pair2.fastq ./S3_align_clean/{}.sam  & export pid3=$!
        sh wait.sh $pid3 && cat Sample_names.csv | parallel --verbose -j 40 sbatch submit_sam2bam.sh ./S3_align_clean/{}.sam -o ./S3_align_clean/{}.bam & export pid4=$!
        sh wait.sh $pid4 && cat Sample_names.csv | parallel --verbose -j 40 sbatch submit_sort.sh ./S3_align_clean/{}.bam -o ./S3_align_clean/trim_align_sort_{}.bam & export pid5=$!
        sh wait.sh $pid5 && cat Sample_names.csv | parallel --verbose -j 40 sbatch submit_dedup.sh INPUT= /path_to/S3_align_clean/trim_align_sort_{}.bam VALIDATION_STRINGENCY=LENIENT OUTPUT=/path_to/S3_align_clean/dedup_tas_{}.bam METRICS_FILE=metrics_{}.txt ASSUME_SORTED=true REMOVE_DUPLICATES=true TMP_DIR=/path_to_tmp_folder/ & export pid6=$!
        sh wait.sh $pid6 && cat Sample_names.csv | parallel --verbose -j 30 sbatch submit_rg.sh I=./S3_align_clean/dedup_tas_{}.bam O=./S3_align_clean/ngm_dtas_rg_{}.bam RGID={} RGLB={} RGPL=illumina RGPU={} RGSM={} & export pid7=$!
        sh wait.sh $pid7 && cat Sample_names.csv | parallel --verbose -j 40 sbatch submit_index.sh ./S3_align_clean/ngm_dtas_rg_{}.bam
#where path_to is the directory with fastq.gz files, containing folders S1_fastq_trim and S3_align_clean
