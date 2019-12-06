#!/bin/bash
source `which my_do_cmd`


subj=$1

dataDir=/misc/mansfield/lconcha/exp/tracto_repro/nobackup
#resultsDir=/misc/mansfield/lconcha/exp/tracto_repro/results
resultsDir=/misc/mansfield/lconcha/exp/tracto_repro/nobackup/results_2019_11_21_QB_0p90_0p005




fa=${dataDir}/${subj}/fa.nii.gz
t1=${dataDir}/${subj}/t1.nii.gz



tractoload=""


for tck in ${resultsDir}/${subj}/*_intersect.tck
do
  tractoload=" $tractoload -tractography.load $tck"
done



my_do_cmd  mrview $fa $t1 $tractoload
