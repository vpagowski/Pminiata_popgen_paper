#!/bin/bash

INPUT=paired_pops.csv #contains csv with pop1,pop2 - list of pairs to consider
OLDIFS=$IFS
IFS=','
[ ! -f $INPUT ] && { echo "$INPUT file not found"; exit 99; }
while read p1 p2
      do sbatch submit_fst.sh ${p1} ${p2}
done < $INPUT
IFS=$OLDIFS
