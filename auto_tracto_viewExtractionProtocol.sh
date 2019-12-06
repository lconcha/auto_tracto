#!/bin/bash
source `which my_do_cmd`


structure=$1

atlas=${FSLDIR}/data/standard/FMRIB58_FA_1mm.nii.gz
protocolsFolder=/misc/mansfield/lconcha/exp/tracto_repro/auto_tracto/lanirem


exclusions=""
n=`ls ${protocolsFolder}/protocols/${structure}/exclude* | wc -l`
if [ $n -eq 0 ]; then  exclusions=""
else
  for excl in ${protocolsFolder}/protocols/${structure}/exclude*
  do
    exclusions="-roi.load $excl -roi.colour 1,0,0 -roi.opacity 0.5"
  done
fi


seeds=""
n=`ls ${protocolsFolder}/protocols/${structure}/seed* | wc -l`
if [ $n -eq 0 ]; then  seeds=""
else
  for seed in ${protocolsFolder}/protocols/${structure}/seed*
  do
    seeds="-roi.load $seed -roi.colour 0,1,0 -roi.opacity 0.5"
    n=$(( $n +1 ))
  done
fi

targets=""
n=`ls ${protocolsFolder}/protocols/${structure}/target* | wc -l`
if [ $n -eq 0 ]; then  targets=""
else
  for target in ${protocolsFolder}/protocols/${structure}/target*
  do
    targets="-roi.load $target -roi.colour 0,1,0 -roi.opacity 0.5"
    n=$(( $n +1 ))
  done
fi

stops=""
n=`ls ${protocolsFolder}/protocols/${structure}/stop* | wc -l`
if [ $n -eq 0 ]; then  stops=""
else
  for stop in ${protocolsFolder}/protocols/${structure}/stop*
  do
    stops="-roi.load $stop -roi.colour 0,0,1 -roi.opacity 0.5"
    n=$(( $n +1 ))
  done
fi


my_do_cmd mrview $atlas $exclusions $seeds $targets $stops -mode 2
