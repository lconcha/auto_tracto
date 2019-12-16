#!/bin/bash
source `which my_do_cmd`


atlas=${FSLDIR}/data/standard/FMRIB58_FA_1mm.nii.gz
protocolsFolder=/misc/mansfield/lconcha/exp/tracto_repro/auto_tracto/lanirem/protocols/
str=$1
includes=""




help(){
echo "
Use:
`basename $0` <structure>
"
}



if [ "$#" -lt 1 ]; then
  echo "[ERROR] - Not enough arguments"
  help
  exit 2
fi


for arg in "$@"
do
  case "$arg" in
  -h|-help)
    help
    exit 1
  ;;
  esac
done







if [ -d ${protocolsFolder}/${str}_R ]
then
  paired=1
else
  paired=0
fi

if [ $paired -eq 1 ]
then
  echolor yellow "Viewing a paired structure"
  for side in R L
  do
    targets=`ls ${protocolsFolder}/${str}_${side}/target*`
    for t in $targets
    do
      includes="$includes -roi.load $t -roi.colour 0,1,0"
    done
  done
   my_do_cmd mrview $atlas \
    -roi.load ${protocolsFolder}/${str}_R/seed.ni*    -roi.colour 0,0.2,1 \
    -roi.load ${protocolsFolder}/${str}_R/exclude.ni* -roi.colour 1,0,0 \
    -roi.load ${protocolsFolder}/${str}_L/seed.ni*    -roi.colour 0,0,1 \
    -roi.load ${protocolsFolder}/${str}_L/exclude.ni* -roi.colour 1,0.3,0 \
    $includes
else
  echolor yellow "Viewing a structure that is NOT paired"
   targets=`ls ${protocolsFolder}/${str}/target*`
   for t in $targets
   do
     includes="$includes -roi.load $t -roi.colour 0,1,0"
   done
   my_do_cmd mrview $atlas \
    -roi.load ${protocolsFolder}/${str}/seed.ni*    -roi.colour 0,0,1 \
    -roi.load ${protocolsFolder}/${str}/exclude.ni* -roi.colour 1,0,0 \
    $includes
fi
