#!/bin/bash


protocolsFolder=/misc/mansfield/lconcha/exp/tracto_repro/auto_tracto/lanirem/protocols


XTRACTFolder=/misc/mansfield/lconcha/autoPtx/xtract/protocols
autoPtxFolder=/misc/mansfield/lconcha/autoPtx/original/protocols

atlas=${FSLDIR}/data/standard/FMRIB58_FA_1mm.nii.gz

########################
myName=$1
theirName=$2
compareto=$3
doView=0
if [[ "$4" == "view" ]]
then
  doView=1
fi
######################


case "$compareto" in
  xtract)
    otherFolder=$XTRACTFolder
  ;;
  autoptx)
    otherFolder=$autoPtxFolder
  ;;
  *)
    echolor red "Cannot identify protocol $compareto as anything we have to compare to."
    echolor red "  Options are: xtract or autoptx"
    exit 2
  ;;
esac




tmpDir=/tmp/dice_$$
mkdir $tmpDir


## Lanirem protocol
echolor cyan "Collecting files from Lanirem protocol"
mrcat -quiet -axis 3 \
  $protocolsFolder/${myName}/seed* \
  $protocolsFolder/${myName}/target* - | \
  mrcalc -quiet  - 0 -gt - | \
  mrmath -quiet  -axis 3 - sum - | \
  mrcalc -quiet  - 0 -gt $tmpDir/mytargets.mif
mrcalc -quiet  $protocolsFolder/${myName}/exclude.nii.gz 0 -gt \
$tmpDir/myexclude.mif


## The other protocol
echolor cyan "Collecting files from $compareto protocol"
mrcat -quiet  -axis 3 \
  $otherFolder/${theirName}/seed* \
  $otherFolder/${theirName}/target* - | \
  mrcalc -quiet  - 0 -gt - | \
  mrmath -quiet  -axis 3 - sum - | \
  mrcalc -quiet  - 0 -gt $tmpDir/othertargets.mif
mrcalc -quiet  $otherFolder/${theirName}/exclude.nii.gz 0 -gt \
$tmpDir/otherexclude.mif



echolor bold "Calculating dice coefficient for targets"
line=`dice.sh $tmpDir/mytargets.mif  $tmpDir/othertargets.mif`
targetDice=`echo $line | awk '{print $3}' | awk -F= '{print $2}'`
targetmyvol=`echo $line | awk '{print $1}' | awk -F= '{print $2}'`
targettheirvol=`echo $line | awk '{print $2}' | awk -F= '{print $2}'`

echolor bold "Calculating dice coefficient for exclusion regions"
line=`dice.sh $tmpDir/myexclude.mif  $tmpDir/otherexclude.mif`
exDice=`echo $line | awk '{print $3}' | awk -F= '{print $2}'`
exmyvol=`echo $line | awk '{print $1}' | awk -F= '{print $2}'`
extheirvol=`echo $line | awk '{print $2}' | awk -F= '{print $2}'`


if [ $doView -eq 1 ]
then
mrview $atlas \
  -roi.load $tmpDir/mytargets.mif    -roi.colour 0,1,0 -roi.opacity 0.5 \
  -roi.load $tmpDir/othertargets.mif -roi.colour 0,1,0.5 -roi.opacity 0.5 \
  -roi.load $tmpDir/myexclude.mif    -roi.colour 1,0,0 -roi.opacity 0.5 \
  -roi.load $tmpDir/otherexclude.mif -roi.colour 1,0.5,0 -roi.opacity 0.5
fi

echo "|Tract|Derived from|Other name|Lanirem target vol|Other target vol|target Dice|Lanirem exclude vol|Other exclude vol|exclude Dice|"

echo "|$myName|$compareto|$theirName|$targetmyvol|$targettheirvol|$targetDice|$exmyvol|$extheirvol|$exDice|"

rm -fR $tmpDir
