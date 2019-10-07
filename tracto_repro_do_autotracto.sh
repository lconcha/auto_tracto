#!/bin/bash




dataFolder=/misc/mansfield/lconcha/exp/tracto_repro/nobackup/Data_2.0
resultsFolder=/misc/mansfield/lconcha/exp/tracto_repro/results
auto_tracto=/misc/mansfield/lconcha/exp/tracto_repro/code/auto_tracto_fnirt.sh


subject=s2

tckIN=${dataFolder}/${subject}/tracking-probabilistic.tck
thisOutFolder=$resultsFolder/${subject}
mask=${dataFolder}/${subject}/mask-brain.nii.gz
fa=${dataFolder}/${subject}/fa.nii.gz

if [ ! -d $thisOutFolder ]
then
  echo mkdir $thisOutFolder
fi

echo $auto_tracto \
  -tck $tckIN \
  -mask $mask \
  -fa $fa \
  -outbase  $thisOutFolder \
  -keepROIs
