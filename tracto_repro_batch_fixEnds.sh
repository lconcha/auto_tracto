#!/bin/bash

dataFolder=/Users/ramoncito/Desktop/Datos_/Data_2.0
resultsFolder=/Users/ramoncito/Desktop/Datos_/Results_auto



for subj in s1 s2 s3 s4 s5 s6
do
  fa=${dataFolder}/${subj}/fa.nii.gz
  for tck in ${resultsFolder}/${subj}/*.tck
  do
    f=`basename $tck`
    st=${f%.tck}
     fsl_sub -N ${subj}_${st} -l ${resultsFolder}/logs \
       truncate_unsupported_streamline_ends.sh $tck $fa ${tck%.tck}_fixEnds.tck
  done

done
