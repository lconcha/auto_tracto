#!/bin/bash
export FSLOUTPUTTYPE=NIFTI_GZ
# TEST=ON
## Defaults ################################
seeding=0
nSeeds=500
CSD=""
tckIN=""
outbase=""
mask=""
fa=""
doNull=0
keep_tmp=0
tmpDir=`pwd`/tmpDir_$$
keepROIs=0
minStreamlinesPerVoxel=1
## End Defaults ################################

function Do_cmd() {
# do_cmd sends command to stdout before executing it.
str="`whoami` @ `uname -n` `date`"
local l_command=""
local l_sep=" "
local l_index=1
while [ ${l_index} -le $# ]; do
    eval arg=\${$l_index}
    if [ "$arg" = "-fake" ]; then
      isFake=1
      arg=""
    fi
    if [ "$arg" = "-no_stderr" ]; then
      stderr=0
      arg=""
    fi
    if [ "$arg" == "-log" ]; then
      nextarg=`expr ${l_index} + 1`
      eval logfile=\${${nextarg}}
      arg=""
      l_index=$[${l_index}+1]
    fi
    l_command="${l_command}${l_sep}${arg}"
    l_sep=" "
    l_index=$[${l_index}+1]
   done
if [[ ${quiet} != TRUE ]]; then echo -e "\033[38;5;118m\n${str}:\nCOMMAND -->  \033[38;5;122m${l_command}  \033[0m"; fi
if [ -z $TEST ]; then $l_command; fi
}
Note(){
echo -e "\t\t$1\t\033[38;5;122m$2\033[0m"
}
Info() {
Col="38;5;75m" # Color code
if [[ ${quiet} != TRUE ]]; then echo  -e "\033[$Col\n[ INFO ]..... $1 \033[0m"; fi
}

help() {
echo -e "
COMMAND:
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

          Requires ANTs v2.3.3   (https://github.com/ANTsX/ANTs)


ARGUMENTS:
    Compulsory:
      -tck <file>       : .tck file (SIFTED, preferraly.)
      -outbase <string> : base name for all your outputs.
      -mask <file>      : Binary mask in subject dwi space.
      -fa <file>        : FA map in subject dwi space. Used for registration to template.


OPTIONS:
      -h|-help
      -keep_tmp         : Do not delete temporary directory
      -tmpDir <path>    : Specify location of temporary directory. Default is $tmpDir
      -keepROIs         : Save the include/exclude ROIs to <outbase>
      -minStreamlinesPerVoxel <int>  Streamlines are truncated if voxel contains
                                     less than this number of streamlines.
                                     Default is $minStreamlinesPerVoxel
      -robust           : This option to runs a more ROBUST SyN registration (More computation time)

USAGE:
    \033[38;5;141m`basename $0`\033[0m  \033[38;5;197m-tck\033[0m <file> \033[38;5;197m-outbase\033[0m <string> \033[38;5;197m-mask\033[0m <file> \033[38;5;197m-fa\033[0m <file>\n


LU15 (0N(H4
May, 2016
Rev Oct 2017
Rev Oct 2019
Modified by rcruces Nov 2020
INB, UNAM
lconcha@unam.mx

"
}

if [ "$#" -lt 2 ]; then
  echo -e "\033[38;5;9m\n[ ERROR ]..... Not enough arguments\033[0m"
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
  ;;
  -outbase)
    outbase=$2
    shift;shift
  ;;
  -mask)
    mask=$2
    shift;shift
  ;;
  -fa)
    fa=$2
    shift;shift
  ;;
  -keep_tmp)
    keep_tmp=1
    shift
  ;;
  -tmpDir)
    tmpDir=$2
    shift;shift;
  ;;
  -keepROIs)
    keepROIs=1
    shift
    echo "  keeping ROIs for inclusion/exclusion criteria"
  ;;
  -robust)
    robust=TRUE
    shift
  ;;
  -minStreamlinesPerVoxel)
    minStreamlinesPerVoxel=$2
    echo "  Minimum streamlines per voxel is $minStreamlinesPerVoxel"
    shift;shift
  ;;
  -*)
    echo "Unknown option ${2}"
    help
    exit 1
  ;;
  esac
done

# -----------------------------------------------------------------------------------------------
## Argument checks
if [ -z $tckIN ];   then echo "Please supply -tck"    ;help;exit 2;fi
if [ -z $mask ];    then echo "Please supply -mask"   ;help;exit 2;fi
if [ -z $outbase ]; then echo "Please supply -outbase";help;exit 2;fi
if [ -z $fa ];      then echo "Please supply -fa"     ;help;exit 2;fi

# -----------------------------------------------------------------------------------------------
echo -e "\n\033[38;5;141m
-------------------------------------------------------------
\tAuto-Tractography segmentation
-------------------------------------------------------------\033[0m"
#	Timer
aloita=$(date +%s)
autoPtx="`dirname $(realpath $0)`/lanirem/protocols"
Note "autoPtx  :" $autoPtx
Note "fa       :" $fa
Note "mask     :" $mask
Note "outbase  :" $outbase
Note "tckIN    :" $tckIN

tckIN=`realpath $tckIN`
mask=`realpath $mask`
outbase=`realpath $outbase`_
fa=`realpath $fa`

# -----------------------------------------------------------------------------------------------
# find the structures and the atlas
structures=`ls -1 $autoPtx`
atlas=${FSLDIR}/data/standard/FMRIB58_FA_1mm.nii.gz

# Create temp directory
Info "Creating tmpDir $tmpDir"
Do_cmd mkdir $tmpDir
here=`pwd`
cd $tmpDir

# -----------------------------------------------------------------------------------------------
## Registration of atlas to subject DWI space
str_fa2atlas=$tmpDir/fa2atlas_
mat_fa2atlas=${str_fa2atlas}0GenericAffine.mat
mat_fa2atlas_warp=${str_fa2atlas}1Warp.nii.gz
mat_fa2atlas_Invwarp=${str_fa2atlas}1InverseWarp.nii.gz

Info "Calculating transformations: FA to FMRIB58_FA_1mm"
if [[ ${robust} == TRUE ]]; then
    Do_cmd antsRegistrationSyN.sh -d 3 -f $atlas -m $fa -o $str_fa2atlas -t s -n 6
else
    Do_cmd antsRegistrationSyNQuick.sh -d 3 -f $atlas -m $fa -o $str_fa2atlas -t s -n 6
fi

Do_cmd antsApplyTransforms -d 3 -e 3 -i $atlas -r $fa -n NearestNeighbor -t [$mat_fa2atlas,1] -t $mat_fa2atlas_Invwarp -o ${outbase}atlas2fa.nii.gz -v -u int

# -----------------------------------------------------------------------------------------------
filter(){
    if [ -f ${autoPtx}/${st}/skip ]
    then
      Info "Skipping structure $st because folder it has a skip file: ${autoPtx}/${st}/skip"
      return 0
    fi
    st=$1
    seed=${autoPtx}/${st}/seed.nii.gz
    target=${autoPtx}/${st}/target.nii.gz
    target2=${autoPtx}/${st}/target_02.nii.gz
    exclude=${autoPtx}/${st}/exclude.nii.gz
    stop=${autoPtx}/${st}/stop.nii.gz
    nat_seed=${tmpDir}/${st}_nat_seed.nii.gz
    nat_target=${tmpDir}/${st}_nat_target.nii.gz
    nat_exclude=${tmpDir}/${st}_nat_exclude.nii.gz
    nat_stop=${tmpDir}/${st}_nat_stop.nii.gz
    nat_mask=${tmpDir}/${st}_nat_mask.nii.gz
    summary=${outbase}summary.txt

    inc_seed=${tmpDir}/${st}_seed.nii.gz
    inc_target=${tmpDir}/${st}_target.nii.gz
    inc_target2=${tmpDir}/${st}_target_02.nii.gz
    exclude_interp=${tmpDir}/${st}_exclude_interp.nii.gz

    # Apply transformations
    Do_cmd antsApplyTransforms -r $fa -i $target -d 3 -e 3 -n GenericLabel -t [$mat_fa2atlas,1] -t $mat_fa2atlas_Invwarp -o $inc_target -v -u int
    Do_cmd antsApplyTransforms -r $fa -i $seed -d 3 -e 3 -n GenericLabel -t [$mat_fa2atlas,1] -t $mat_fa2atlas_Invwarp -o $inc_seed -v -u int
    Do_cmd antsApplyTransforms -r $fa -i $exclude -d 3 -e 3 -n GenericLabel -t [$mat_fa2atlas,1] -t $mat_fa2atlas_Invwarp -o $exclude_interp -v -u int
    if [ -f $target2 ]; then
        Do_cmd antsApplyTransforms -r $fa -i $target2 -d 3 -e 3 -n GenericLabel -t [$mat_fa2atlas,1] -t $mat_fa2atlas_Invwarp -o $inc_target2 -v -u int
        include="$inc_target -include $inc_target2"
    else
        include="$inc_target"
    fi
    mrcalc -quiet $exclude_interp 0 -gt - | maskfilter -force -quiet - dilate $nat_exclude

    # -----------------------------------------------------------------------------------------------
    # modify the mask according to the stop criterion
    if [ `imtest $stop` -eq 1 ]; then
         Info "Found $stop"
         Do_cmd antsApplyTransforms -r $fa -i $stop -d 3 -e 3 -n GenericLabel -t [$mat_fa2atlas,1] -t $mat_fa2atlas_Invwarp -o ${tmpDir}/${st}_stop_interp.nii.gz -v -u int
         mrcalc -quiet ${tmpDir}/${st}_stop_interp.nii.gz 0 -gt - | maskfilter -force -quiet - dilate $nat_stop
         Do_cmd mrcalc -force -quiet $fa 0 -gt ${tmpDir}/mask.nii.gz
         Do_cmd mrcalc -force -quiet ${tmpDir}/mask.nii.gz $nat_stop -subtract $nat_mask
     else
          Do_cmd mrcalc -force $fa 0 -gt $nat_mask
     fi

     Do_cmd tckedit -force \
                $tckIN \
                ${outbase}${st}.tck \
                -include $inc_seed\
                -include $include\
                -mask $nat_mask \
                -exclude $nat_exclude

     if [ $minStreamlinesPerVoxel -gt 1 ]; then
          Info "Truncating streamlines if streamlines in voxel is less than $minStreamlinesPerVoxel"
          Do_cmd tckmap -force -quiet -template $fa ${outbase}${st}.tck ${tmpDir}/${st}_n.nii
          Do_cmd mrcalc ${tmpDir}/${st}_n.nii.gz $minStreamlinesPerVoxel -ge ${tmpDir}/${st}_streamlinesMask.nii
          Do_cmd tckedit -force \
                    -mask ${tmpDir}/${st}_streamlinesMask.nii.gz \
                    ${outbase}${st}.tck \
                    ${outbase}${st}_masked.tck
     fi

     nTcks=`tckinfo -count ${outbase}${st}.tck | grep "actual count" | awk '{print $NF}'`
     echo "$st $nTcks" >> $summary
}
# End of filter

# -----------------------------------------------------------------------------------------------
## Main loop
structures=`ls -1 $autoPtx`
for st in $structures; do
  Info "Working on $st"; filter $st
done

# -----------------------------------------------------------------------------------------------
## Clean up
if [ $keepROIs -eq 1 ]; then
    Info "Saving ROIs"
    for f in ${tmpDir}/*.nii.gz; do
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

if [ $keep_tmp -eq 0 ]; then
    Info "deleting tmpDir $tmpDir"
    Do_cmd rm -fR $tmpDir
else
    Info "Not deleting tmpDir $tmpDir"
fi

# -----------------------------------------------------------------------------------------------
cd $here

# QC notification of completition
lopuu=$(date +%s)
eri=$(echo "$lopuu - $aloita" | bc)
eri=`echo print $eri/60 | perl`

# Notification of completition
echo -e "\n\033[38;5;141m
-------------------------------------------------------------
\tAuto-Tracto ended in \033[38;5;220m `printf "%0.3f\n" ${eri}` minutes \033[38;5;141m
-------------------------------------------------------------\033[0m"
