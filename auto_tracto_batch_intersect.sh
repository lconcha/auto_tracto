#!/bin/bash
source `which my_do_cmd`


imagesDir=/misc/mansfield/lconcha/exp/tracto_repro/nobackup
clean_tracksDir=/misc/mansfield/lconcha/exp/tracto_repro/results_2019_11_21_busquedaAmpliaFina0p5_ep0p0125_soloClean
protocolsFolder=/misc/mansfield/lconcha/exp/tracto_repro/auto_tracto/lanirem
orig_tracksDir=/misc/mansfield/lconcha/exp/tracto_repro/results


structures=`ls -d $protocolsFolder/*/* | xargs basename -a | fmt`


errorFile=/misc/mansfield/lconcha/exp/tracto_repro/nobackup/errors.txt
if [ -f $errorFile ]
then
  rm -f $errorFile
fi
for n in 1 2 3 4 5 6
do
  echolor orange "Subject $n"
  for st in $structures
  do
    echolor cyan "Structure $st"
    origTCK=${orig_tracksDir}/s${n}/${st}.tck
    outTCK=${clean_tracksDir}/s${n}/${st}_fixEnds_qb_intersect.tck
    list_of_tcks=`ls ${clean_tracksDir}/s${n}/${st}_fixEnds_qb_clean*.tck`
    if [ -z "$list_of_tcks" ]
    then
       echolor red "  [ERROR] No file for s${n} $st"
       if [ -f $origTCK ]
       then
         echolor bold "    [INFO] Weird, because the original exists: $origTCK"
         echolor bold "    [INFO] Copying the original to the result."
         cp -v $origTCK  $outTCK
         continue
         #echo "NoQuickBundles $origTCK" >> $errorFile
       else
         echolor red "    [ERROR] The original does not exist, either: $origTCK"
         echo "NoOriginalTCK $origTCK" >> $errorFile
       fi
    fi
    if [ `ls ${clean_tracksDir}/s${n}/${st}_fixEnds_qb_clean*.tck | wc -l` -eq 1 ]
    then
       echolor yellow "  [INFO] Only one tract for s${n} $st. Copying file to result."
       cp -v $list_of_tcks $outTCK
    fi
    my_do_cmd  intersect_tck_streamlines.sh $outTCK $list_of_tcks
  done
  echo ""
done
