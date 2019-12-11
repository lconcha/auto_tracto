#!/bin/bash
#source `which my_do_cmd`
# inspiration from https://mailman.bic.mni.mcgill.ca/pipermail/minc-users/2011-August/003183.html

A=$1
B=$2


tmpDir=/tmp/dice_$$
mkdir $tmpDir

mrcalc -quiet $A 0 -gt $tmpDir/A.mif
mrcalc -quiet $B 0 -gt $tmpDir/B.mif


mrcalc -quiet $tmpDir/A.mif $tmpDir/B.mif -mul $tmpDir/and.mif
nA=`mrstats $tmpDir/A.mif -ignorezero -output count`
nB=`mrstats $tmpDir/B.mif -ignorezero -output count`
nAND=`mrstats $tmpDir/and.mif -ignorezero -output count`

#echo " dice = (2 * $nAND) / ($nA + $nB)"
#dice=`echo "(2 * $nAND) / ($nA + $nB)" | bc -l`
dice=`mrcalc 2 $nAND -mul $nA $nB -add -div`

echo "Dice coefficient:"
echo $dice

rm -fR $tmpDir
