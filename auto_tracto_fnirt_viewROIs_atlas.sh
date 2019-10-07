#!/bin/bash


atlas=${FSLDIR}/data/standard/FMRIB58_FA_1mm.nii.gz
str=$1
includes=""




if [ -d ${str}_R ]
then
  paired=1
else
  paired=0
fi

if [ $paired -eq 1 ]
then
  echo "Viewing a paired structure"
  for side in R L
  do
    targets=`ls ${str}_${side}/target*`
    for t in $targets
    do
      includes="$includes -roi.load $t -roi.colour 0,1,0"
    done
  done
   mrview $atlas \
    -roi.load ${str}_R/seed.ni*    -roi.colour 0,0.2,1 \
    -roi.load ${str}_R/exclude.ni* -roi.colour 1,0,0 \
    -roi.load ${str}_L/seed.ni*    -roi.colour 0,0,1 \
    -roi.load ${str}_L/exclude.ni* -roi.colour 1,0.3,0 \
    $includes
else
   targets=`ls ${str}/target*`
   for t in $targets
   do
     includes="$includes -roi.load $t -roi.colour 0,1,0"
   done
   mrview $atlas \
    -roi.load ${str}/seed.ni*    -roi.colour 0,0,1 \
    -roi.load ${str}/exclude.ni* -roi.colour 1,0,0 \
    $includes
fi
