#!/bin/bash


matlab='/home/inb/soporte/fmrilab_software/MatlabR2018a/bin/matlab'

tckOUT=$1
shift


n=1
tcksToIntersect=""
for tck in "$@"
do
  echo "  $n : $tck"
  tcksToIntersect="$tcksToIntersect '$tck',"
  n=$(( $n + 1 ))
done
echo "  Output will be $tckOUT"

# remove last comma
tcksToIntersect=${tcksToIntersect::-1}



$matlab -nodisplay <<EOF
addpath('/misc/mansfield/lconcha/exp/tracto_repro/auto_tracto')
intersect_tck_streamlines('$tckOUT',$tcksToIntersect)
EOF
