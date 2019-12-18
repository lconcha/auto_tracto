#!/bin/bash

process () {
  
  dataFolder=/Users/ramoncito/Desktop/Datos_/Data_2.0
  resultsFolder=/Users/ramoncito/Desktop/Datos_/Results_auto
  auto_tracto=/Users/ramoncito/Documents/GitHub/auto_tracto/auto_tracto_fnirt.sh
  tmpFolder=/Users/ramoncito/Desktop/Datos_/Temp
  protocolsFolder=/Users/ramoncito/Documents/GitHub/auto_tracto/lanirem
  
  local subject=$1
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

}


subjects="s1 s2 s3 s4 s5 s6"

for subject in $subjects
do
 process "$subject" & done
done
