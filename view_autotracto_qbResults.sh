#!/bin/bash
source `which my_do_cmd`

n=$1
tract=$2
side=$3

imagesDir=/misc/mansfield/lconcha/exp/tracto_repro/nobackup
#clean_tracksDir=/misc/mansfield/lconcha/exp/tracto_repro/nobackup/results_2019_11_21_QB_0p90_0p005
clean_tracksDir=/misc/mansfield/lconcha/exp/tracto_repro/results_2019_11_21_busquedaAmpliaFina0p5_ep0p0125_soloClean
orig_tracksDir=/misc/mansfield/lconcha/exp/tracto_repro/results

tload=""

origTrack=${orig_tracksDir}/s${n}/${tract}_${side}.tck

for tck in ${clean_tracksDir}/s${n}/${tract}_${side}_*intersect.tck
do
  tload="$tload -tractography.load $tck"
done

my_do_cmd mrview ${imagesDir}/s${n}/fa.nii.gz -tractography.load $origTrack $tload
