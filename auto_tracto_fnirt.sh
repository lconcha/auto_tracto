#!/bin/bash
source `which my_do_cmd`
fakeflag=""
export FSLOUTPUTTYPE=NIFTI



## Defaults ################################
autoPtx=/misc/mansfield/lconcha/autoPtx/original
filtering=0
seeding=0
nSeeds=500
CSD=""
tckIN=""
# t1==""
outbase=""
mask=""
fa=""
mat=""
doNull=0
keep_tmp=0
tmpDir=`pwd`/tmpDir_$$
keepROIs=0
minStreamlinesPerVoxel=1
## End Defaults ################################


help() {
echo "
`basename $0`


Perform automatic virtual dissection of a full-brain tractogram.
Provide a pre-computed tck file and it will be dissected.

This is an adaptation of AutoPtx and XTRACT to work with MRtrix3.
See these links:
https://fsl.fmrib.ox.ac.uk/fsl/fslwiki/AutoPtx
https://fsl.fmrib.ox.ac.uk/fsl/fslwiki/XTRACT
- The adaptation is only partial, as in AutoPtx and XTRACT the seeding of Streamlines
  is performed for each bundle. Here, a full tractogram is provided, where the user
  had the option to seed with whatever strategy was preferred. It is assumed, however,
  that a full-brain seeding approach was used (white matter mask, GM/WM border, etc.)
- Another difference is the use of STOP ROIs, which only make sense if seeding
  is performed per bundle, and not if filtering a full tractogram.
  STOP ROIs are used, nonetheless, but rather as termination criteria that will truncate
  the streamlines. Thus, STOP ROIs should be much larger than usual, to avoid
  the appearance of multiple short-length truncated streamlines.
- The quality of the full brain tractogram will determine the quality of bundle separation.
  It is highly recommended to provide a tractogram with more than one million streamlines,
  and one that has been checked for errors. Strategies such as anatomically-contstrained
  tractography (ACT) and spherical deconvolution informed filtering of tractograms (SIFT),
  both available in MRTrix3 should aid in obtaining such high-quality tractograms.


Since this script uses fsl tools (FLIRT, in particular),
please provide volumes in .nii[.gz] format.



ARGUMENTS:
Compulsory:
  -tck <file>       : .tck file (SIFTED, preferraly.)
  -outbase <string> : base name for all your outputs.
  -mask <file>      : Binary mask in subject dwi space.
  -fa <file>        : FA map in subject dwi space. Used for registration to template.


Options:
  -h|-help
  -mat <file>       : It should be a (fnirt) warp volume to transform atlas to subject FA map.
                      Do not supply the extension of the file.
                      Example: subj_atlas2fa_warp
  -doNull           : Do null tractogram (for statistical purposes - unfinished)
  -keep_tmp         : Do not delete temporary directory
  -tmpDir <path>    : Specify location of temporary directory. Default is $tmpDir
  -keepROIs         : Save the include/exclude ROIs to <outbase>
  -autoPtx <path>   : Fill path to auto_ptx protocol directory.
                      Default is $autoPtx.
  -minStreamlinesPerVoxel <int>  Streamlines are truncated if voxel contains
                                 less than this number of streamlines.
                                 Default is $minStreamlinesPerVoxel





LU15 (0N(H4
May, 2016
Rev Oct 2017
Rev Oct 2019
INB, UNAM
lconcha@unam.mx

"
}



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
  -tck)
    tckIN=$2
    shift;shift
    echo "    tckIN is $tckIN"
    filtering=1
   ;;
  -outbase)
    outbase=$2
    shift;shift
    echo "    outbase is $outbase"
  ;;
  -mask)
    mask=$2
    shift;shift
    echo "    mask is $mask"
    ;;
  -fa)
    fa=$2
    shift;shift
    echo "    fa is $fa"
    ;;
  -mat)
    mat=$2
    shift;shift
    echo "    mat is $mat"
  ;;
  -keep_tmp)
    keep_tmp=1
    shift
  ;;
  -tmpDir)
    tmpDir=$2
    shift;shift;
    echo "  tmpDir is $tmpDir"
  ;;
  -keepROIs)
    keepROIs=1
    shift
    echo "  keeping ROIs for inclusion/exclusion criteria"
  ;;
  -autoPtx)
    autoPtx=$2
    shift;shift
    echo "    autoPtx is $autoPtx"
   ;;
   -minStreamlinesPerVoxel)
    minStreamlinesPerVoxel=$2
    echo "  Minimum streamlines per voxel is $minStreamlinesPerVoxel"
    shift;shift
   ;;

  esac
done


## Argument checks
if [ -z $tckIN ];   then echo "Please supply -tck"    ;help;exit 2;fi
if [ -z $mask ];    then echo "Please supply -mask"   ;help;exit 2;fi
if [ -z $outbase ]; then echo "Please supply -outbase";help;exit 2;fi
if [ -z $fa ];      then echo "Please supply -fa"     ;help;exit 2;fi
##### End argument checks


# find the structures and the atlas
structures=`ls -1 $autoPtx/protocols`
atlas=${FSLDIR}/data/standard/FMRIB58_FA_1mm.nii.gz


# Create temp directory
echolor yellow "Creating tmpDir $tmpDir"
mkdir $tmpDir



## Registration of atlas to subject DWI space
echo "[INFO] Checking if We have a transformation between atlas and fa."
if [ ! -z $mat ]
then
  echo "  [INFO] A transformation matrix (or warp) was supplied: $mat"
  mat_atlas2fa=$mat
else
  mat_fa2atlas=${outbase}fa2atlas_warp
  mat_atlas2fa=${outbase}atlas2fa_warp
fi
if [ `imtest $mat_atlas2fa` -eq 0 ]
then
  echo "[INFO] No transformation (or warp) was supplied. Calculating: $mat_atlas2fa"
  cnf=${FSLDIR}/src/fnirt/fnirtcnf/FA_2_FMRIB58_1mm.cnf
  my_do_cmd $fakeflag fnirt --config=$cnf --ref=$atlas --in=$fa --fout=$mat_fa2atlas --iout=${outbase}_fa2atlas -v
  echo " [INFO] Finished registration to atlas"
  my_do_cmd $fakeflag invwarp -v -w $mat_fa2atlas -o $mat_atlas2fa -r $fa
  echo " [INFO] Finished inversion of warp"
  my_do_cmd $fakeflag applywarp -r $fa -i $atlas  -o ${outbase}_atlas2fa -w $mat_atlas2fa
else
  echo "[INFO] Transformation exists: $mat_atlas2fa"
fi






filter(){
  if [ -f ${autoPtx}/protocols/${st}/skip ]
  then
    echo "[INFO] Skipping structure $st because folder it has a skip file: ${autoPtx}/protocols/${st}/skip"
    return 0
  fi
  st=$1
  tckIN=$2
  autoPtx=$3
  outbase=$4
  mat=$5
  tmpDir=$6
  fa=$7
  minStreamlinesPerVoxel=$8
  seed=${autoPtx}/protocols/${st}/seed.nii
  list_of_targets=`imglob ${autoPtx}/protocols/${st}/target*`
  exclude=${autoPtx}/protocols/${st}/exclude.nii
  stop=${autoPtx}/protocols/${st}/stop.nii
  nat_seed=${tmpDir}/${st}_nat_seed.nii
  nat_target=${tmpDir}/${st}_nat_target.nii
  nat_exclude=${tmpDir}/${st}_nat_exclude.nii
  nat_stop=${tmpDir}/${st}_nat_stop.nii
  nat_mask=${tmpDir}/${st}_nat_mask.nii
  summary=${outbase}summary.txt

  i=0
  includes=""
  for f in $seed $list_of_targets
  do
    ii=`zeropad $i 2`
    my_do_cmd $fakeflag applywarp -r $fa -i $f -o ${tmpDir}/${st}_target_${ii}.nii -w $mat_atlas2fa --interp=nn
    includes="$includes -include ${tmpDir}/${st}_target_${ii}.nii"
    i=$(($i+1))
  done

  my_do_cmd $fakeflag applywarp -r $fa -i $exclude -o ${tmpDir}/${st}_exclude_interp.nii -w $mat_atlas2fa --interp=trilinear
  mrcalc  -quiet ${tmpDir}/${st}_exclude_interp.nii 0 -gt - | maskfilter -quiet - dilate    $nat_exclude


# modify the mask according to the stop criterion
if [ `imtest $stop` -eq 1 ]
then
   echo "[INFO] Found $stop"
   my_do_cmd $fakeflag applywarp -r $fa -i $stop    -o ${tmpDir}/${st}_stop_interp.nii    -w $mat_atlas2fa --interp=nn
   mrcalc  -quiet ${tmpDir}/${st}_stop_interp.nii 0 -gt - | maskfilter -quiet - dilate    $nat_stop
   my_do_cmd $fakeflag mrcalc -force -quiet $fa 0 -gt ${tmpDir}/mask.nii
   my_do_cmd $fakeflag mrcalc -force -quiet ${tmpDir}/mask.nii $nat_stop -subtract $nat_mask
 else
   my_do_cmd $fakeflag mrcalc -force $fa 0 -gt $nat_mask
 fi

  this_cmd="tckedit -force \
            $tckIN \
            ${outbase}${st}.tck \
            $includes \
            -mask $nat_mask \
            -exclude $nat_exclude"
  echo $this_cmd > ${tmpDir}/${st}.command
  my_do_cmd $fakeflag $this_cmd
 if [ $minStreamlinesPerVoxel -gt 1 ]
 then
  echolor yellow "[INFO] Truncating streamlines if streamlines in voxel is less than $minStreamlinesPerVoxel"
  my_do_cmd $fakeflag tckmap -force -quiet -template $fa ${outbase}${st}.tck ${tmpDir}/${st}_n.nii
  my_do_cmd $fakeflag mrcalc ${tmpDir}/${st}_n.nii $minStreamlinesPerVoxel -ge ${tmpDir}/${st}_streamlinesMask.nii
  my_do_cmd $fakeflag tckedit -force \
            -mask ${tmpDir}/${st}_streamlinesMask.nii \
            ${outbase}${st}.tck \
            ${outbase}${st}_masked.tck
 fi

 nTcks=`tckinfo -count ${outbase}${st}.tck | grep "actual count" | awk '{print $NF}'`
 echo "$st $nTcks" >> $summary

}
# End of filter



## Main loop
structures=`ls -1 $autoPtx/protocols`
for st in $structures
do
  echo "[INFO] Working on $st"
  if [ $filtering -eq 1 ]
  then
    filter $st $tckIN $autoPtx $outbase $mat_atlas2fa $tmpDir $fa $minStreamlinesPerVoxel
  fi
  echo "..................."
done


## Clean up
if [ $keepROIs -eq 1 ]
then
  echo "[INFO]  Saving ROIs"
  for f in ${tmpDir}/*.nii
  do
    ff=`basename $f`
    echo "  ${outbase}${ff}.gz"
    mrconvert -quiet $f ${outbase}${ff}.gz
  done
  for f in ${tmpDir}/*.command
  do
    ff=`basename $f`
    cp -v $f ${outbase}${ff}
  done
fi


if [ $keep_tmp -eq 0 ]
then
  echo "deleting tmpDir $tmpDir"
  rm -fR $tmpDir
else
  echolor yellow "[INFO] Not deleting tmpDir $tmpDir"
fi
