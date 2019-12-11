#!/bin/bash


protocolsFolder=/misc/mansfield/lconcha/exp/tracto_repro/auto_tracto/lanirem/protocols


XTRACTFolder=/misc/mansfield/lconcha/autoPtx/xtract/protocols
autoPtxFolder=/misc/mansfield/lconcha/autoPtx/original/protocols


myName=$1
theirName=$2
compareto=$3

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
mrcat -axis 3 \
  $protocolsFolder/${myName}/seed* \
  $protocolsFolder/${myName}/target* - | \
  mrcalc - 0 -gt - | \
  mrmath -axis 3 - sum - | \
  mrcalc - 0 -gt $tmpDir/mytargets.mif
mrcalc $protocolsFolder/${myName}/exclude.nii.gz 0 -gt \
$tmpDir/myexclude.mif

## The other protocol
echolor cyan "Collecting files from $compareto protocol"
mrcat -axis 3 \
  $otherFolder/${theirName}/seed* \
  $otherFolder/${theirName}/target* - | \
  mrcalc - 0 -gt - | \
  mrmath -axis 3 - sum - | \
  mrcalc - 0 -gt $tmpDir/othertargets.mif
mrcalc $otherFolder/${theirName}/exclude.nii.gz 0 -gt \
$tmpDir/otherexclude.mif


ls $tmpDir

rm -fR $tmpDir
