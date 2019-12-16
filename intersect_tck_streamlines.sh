#!/bin/bash


matlab='/home/inb/soporte/fmrilab_software/MatlabR2018a/bin/matlab'

tckOUT=$1
shift


tmpDir=/tmp/intersect_$$
mkdir $tmpDir

tcksToIntersect=${tmpDir}/tracks_to_intersect.txt

for tck in "$@"
do
<<<<<<< HEAD
  #echolor yellow "  $n : $tck"
  tcksToIntersect="$tcksToIntersect '$tck',"
  n=$(( $n + 1 ))
done
echo "  Output will be $tckOUT"

# remove last comma
tcksToIntersect=${tcksToIntersect::-1}


#cmd="addpath('/misc/mansfield/lconcha/exp/tracto_repro/auto_tracto');
#intersect_tck_streamlines('$tckOUT',$tcksToIntersect);"

#echolor bold "Going into matlab"
#echo $cmd

#$matlab -nodisplay $cmd

$matlab -nodisplay <<EOF
addpath('/misc/mansfield/lconcha/exp/tracto_repro/auto_tracto');
intersect_tck_streamlines('$tckOUT',$tcksToIntersect)
=======
  echo $tck >> $tcksToIntersect
done
echo "  Output will be $tckOUT"


$matlab -nodisplay <<EOF
addpath('/misc/mansfield/lconcha/exp/tracto_repro/auto_tracto');
intersect_tck_streamlines('$tckOUT','$tcksToIntersect')
>>>>>>> devel
EOF


rm -fR $tmpDir
