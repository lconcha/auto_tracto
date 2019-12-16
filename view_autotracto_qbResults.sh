#!/bin/bash
source `which my_do_cmd`



help(){
echo "
Show the results of tractography dissection and intersection.
Use:
`basename $0` <n> <tract>

n     : Number of subject (will be expanded to s1, s2, etc.)
tract : Name of structure to view. Examples: UF_L, AF_L, CC_MID, etc.
        If \"all\" is entered, then all results are shown at the same time.

Options:
-show_original     Shows the tck before intersection step.
"
}


n=$1
tract=$2


imagesDir=/misc/mansfield/lconcha/exp/tracto_repro/nobackup
#clean_tracksDir=/misc/mansfield/lconcha/exp/tracto_repro/nobackup/results_2019_11_21_QB_0p90_0p005
clean_tracksDir=/misc/mansfield/lconcha/exp/tracto_repro/results_2019_11_21_busquedaAmpliaFina0p5_ep0p0125_soloClean
orig_tracksDir=/misc/mansfield/lconcha/exp/tracto_repro/results


# start the list of tracts
tload=""




if [ "$#" -lt 2 ]; then
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
  -show_original)
    origTrack=${orig_tracksDir}/s${n}/${tract}.tck
    tload="$tload -tractography.load $origTrack"
  ;;
  esac
done


if [[ "$2" == "all" ]]
then
  doAll=1
else
  doAll=0
fi


if [ $doAll -eq 1 ]
then
  echolor yellow "showing all intersected tracks!"
  for tck in ${clean_tracksDir}/s${n}/*intersect.tck
  do
    tload="$tload -tractography.load $tck"
  done
else
  for tck in ${clean_tracksDir}/s${n}/${tract}*intersect.tck
  do
    tload="$tload -tractography.load $tck"
  done
fi

my_do_cmd mrview ${imagesDir}/s${n}/fa.nii.gz $tload
