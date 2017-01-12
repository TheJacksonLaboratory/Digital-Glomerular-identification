#!/bin/bash

# makes a list of all *.ndpi files in a directory
ls -1 *.ndpi > ndpi_filelist.txt
FILENUMBER=$(wc -l ndpi_filelist.txt | cut -d' ' -f1)

# writes a script for cluster submission
echo \#!/bin/bash >> parallel_ndpisplit.qsub
echo \#PBS -l nodes=1:ppn=2 >> parallel_ndpisplit.qsub
echo \#PBS -l walltime=12:00:00 >> parallel_ndpisplit.qsub
echo \#PBS -q batch >> parallel_ndpisplit.qsub
echo \#PBS -t 1-$FILENUMBER >> parallel_ndpisplit.qsub
echo module load ndpitools/1.6.5 >> parallel_ndpisplit.qsub
echo cd \$PBS_O_WORKDIR >> parallel_ndpisplit.qsub
echo FILE=\$\(head -n \$PBS_ARRAYID ndpi_filelist.txt \| tail -1\) >> parallel_ndpisplit.qsub
echo ndpisplit -x40 -M10l \$FILE >> parallel_ndpisplit.qsub >> parallel_ndpisplit.qsub

# submits the script to the cluster for processing
qsub parallel_ndpisplit.qsub
