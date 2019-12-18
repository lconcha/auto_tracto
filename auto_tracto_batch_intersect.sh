#!/bin/bash
source `which my_do_cmd`

output_clean=/Users/ramoncito/Desktop/Datos_/Cleans/Results_auto
protocolsFolder=/Users/ramoncito/Documents/GitHub/auto_tracto/lanirem
resultsFolder==/Users/ramoncito/Desktop/Datos_/Results_auto

structures=`ls -d $protocolsFolder/*/* | xargs basename -a | fmt`


errorFile=${output_clean}/errors.txt
if [ -f $errorFile ]
then
  rm -f $errorFile
fi
for n in 5
do
  echolor orange "Subject $n"
  for st in $structures
  do
    echolor cyan "Structure $st"
    origTCK=${resultsFolder}/s${n}/${st}.tck
    outTCK=${output_clean}/s${n}/${st}_fixEnds_qb_intersect.tck
    list_of_tcks=`ls ${output_clean}/s${n}/${st}_fixEnds_qb_clean*.tck`

    echo ${list_of_tcks}
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
