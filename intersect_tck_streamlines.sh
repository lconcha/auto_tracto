#!/bin/bash


matlab='/home/inb/soporte/fmrilab_software/MatlabR2018a/bin/matlab'

tckOUT=$1
shift


tmpDir=/tmp/intersect_$$
mkdir $tmpDir

tcksToIntersect=${tmpDir}/tracks_to_intersect.txt

for tck in "$@"
do
  echo $tck >> $tcksToIntersect
done
echo "  Output will be $tckOUT"


$matlab -nodisplay <<EOF
addpath('/misc/mansfield/lconcha/exp/tracto_repro/auto_tracto');
intersect_tck_streamlines('$tckOUT','$tcksToIntersect')
EOF


rm -fR $tmpDir
