#!/bin/bash




dataFolder=/misc/mansfield/lconcha/exp/tracto_repro/nobackup
resultsFolder=/misc/mansfield/lconcha/exp/tracto_repro/results
auto_tracto=/misc/mansfield/lconcha/exp/tracto_repro/auto_tracto/auto_tracto_fnirt.sh
tmpFolder=/misc/mansfield/lconcha/exp/tracto_repro/tmp
protocolsFolder=/misc/mansfield/lconcha/exp/tracto_repro/auto_tracto/lanirem

subjects="s1 s2 s3 s4 s5 s6"

for subject in $subjects
do
  tckIN=${dataFolder}/${subject}/tracking-probabilistic.tck
  thisOutFolder=$resultsFolder/${subject}
  mask=${dataFolder}/${subject}/mask-brain.nii.gz
  fa=${dataFolder}/${subject}/fa.nii.gz
  this_tmpDir=${tmpFolder}/${subject}_$$

  if [ ! -d $thisOutFolder ]
  then
     mkdir $thisOutFolder
  fi

  $auto_tracto \
    -tck $tckIN \
    -mask $mask \
    -fa $fa \
    -outbase  $thisOutFolder/ \
    -keepROIs \
    -tmpDir $this_tmpDir \
    -autoPtx $protocolsFolder


  for cmdfile in $thisOutFolder/*.command
  do
    sed "s|${this_tmpDir}/||g" $cmdfile | sed 's|.nii |.nii.gz |g' | sed 's|.nii$|.nii.gz|' >  ${cmdfile%.command}_command.txt
    rm -f $cmdfile
  done

done
