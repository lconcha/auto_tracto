#!/bin/bash
source `which my_do_cmd`
fakeflag=""

tckIN=$1
fa=$2
tckOUT=$3
min_streamlines=$5

max_iter=200


tmpDir=/tmp/truncate_$$
mkdir $tmpDir


n_unsupported_ends=1


# copy files to tmp folder
my_do_cmd $fakeflag cp -v $tckIN ${tmpDir}/filtered_0.tck
my_do_cmd $fakeflag mrconvert -quiet $fa ${tmpDir}/fa.mif


for iter in `seq 1 $max_iter`
do
  lastiter=$(( $iter -1 ))
  echolor yellow "  Now in iteration $iter ---------------------"
  my_do_cmd $fakeflag tckmap  -quiet -force \
    ${tmpDir}/filtered_${lastiter}.tck \
    -template ${tmpDir}/fa.mif \
    ${tmpDir}/n_streamlines.mif
  my_do_cmd $fakeflag mrcalc  -quiet -force \
    ${tmpDir}/n_streamlines.mif \
    0 -gt  \
    ${tmpDir}/has_streamlines.mif
  my_do_cmd $fakeflag tckmap  -quiet -force \
    ${tmpDir}/filtered_${lastiter}.tck \
    -template ${tmpDir}/fa.mif \
    -ends_only \
    ${tmpDir}/ends.mif
  my_do_cmd $fakeflag mrcalc  -quiet -force \
    ${tmpDir}/n_streamlines.mif \
    2 -lt \
    ${tmpDir}/not_supported.mif
  my_do_cmd $fakeflag mrcalc  -quiet -force \
    ${tmpDir}/not_supported.mif \
    ${tmpDir}/ends.mif -mul \
    ${tmpDir}/unsupported_ends.mif


  n_unsupported_ends=`mrstats ${tmpDir}/unsupported_ends.mif -mask ${tmpDir}/unsupported_ends.mif -output count`
  echolor cyan "  Number of unsupported ends is $n_unsupported_ends"
  if [ $n_unsupported_ends -eq 0 ]
  then
   echolor bold "Reached Convergence"
   break
  fi

  my_do_cmd $fakeflag mrcalc  -quiet  -force \
    ${tmpDir}/has_streamlines.mif \
    ${tmpDir}/unsupported_ends.mif -sub \
    ${tmpDir}/supported_mask.mif
  my_do_cmd $fakeflag tckedit   -force \
    ${tmpDir}/filtered_${lastiter}.tck \
    -mask ${tmpDir}/supported_mask.mif \
    ${tmpDir}/filtered_${iter}.tck

 if [ $iter -eq $max_iter ]
 then
   echolor bold "Reached maximum iterations: $max_iter"
   lastiter=$iter
 fi

done


my_do_cmd $fakeflag  cp ${tmpDir}/filtered_${lastiter}.tck $tckOUT

echo ""
echo " Compare $tckIN with $tckOUT"
tckinfo $tckIN $tckOUT

rm -fR $tmpDir
