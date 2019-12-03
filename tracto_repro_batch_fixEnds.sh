#!/bin/bash



dataDir=/misc/mansfield/lconcha/exp/tracto_repro/nobackup
resultsDir=/misc/mansfield/lconcha/exp/tracto_repro/results



for subj in s1 s2 s3 s4 s5 s6
do
  fa=${dataDir}/${subj}/fa.nii.gz
  for tck in ${resultsDir}/${subj}/*.tck
  do
    f=`basename $tck`
    st=${f%.tck}
     fsl_sub -N ${subj}_${st} -l ${resultsDir}/logs \
       truncate_unsupported_streamline_ends.sh $tck $fa ${tck%.tck}_fixEnds.tck
  done

done
