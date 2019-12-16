
Tract definitions


# Commissural fibers
## AC (Anterior Commissure)
The AC interconnects both temporal lobes. Selection regions are placed at the midline, where it is easily recognizable above the mamillary bodies, and on axial slices at the level of the cerebral peduncles. The lateral extent of the AC is ill-defined, as the fibers fan out as they enter/exit the temporal lobes, thus the streamlines are truncated on as they extend the equivalent of 32 mm from the midline, This level corresponds roughly to the lateral extent of the lateral ventricles. Exclusion criteria are placed anteriorly, in a coronal slice behid the posterior border of the genu of the corpus callosum; at the level of the cerebellum; and at the brain stem. Derived from XTRACT (ac).

## Corpus callosum (CC)
The corpus callosum is the largest white matter structure in the brain. Obtaining a tractogram of it as a whole is a difficult task, ant it is better delineated if separated into four segments.

### FMI (Forceps minor of corpus callosum)
The FMI contains the streamlines that pass through the genu of the CC. Two inclusion criteria are placed on a coronal slice at the level of the frontal pole. Streamlines must reach both regions to be retained. An exclusion mask limits the entire midline with the exception of the genu of the CC, and also more posteriorly, with a coronal slice at the level of the crus of the fornix. Derived from XTRACT (fmi), which is identical to autoPtx (fmi).

### CC_MID (Corpus Callosum middle portion)
Also known as the body of the CC, interconnects frontal and parietal lobes of one hemisphere to their counterparts in the other hemisphere. As such, selection criteria are drawn axially in the frontal and parietal lobes, and the streamlines must pass through any portion of the mid-sagittal CC. There is no need to draw the anterior and posterior boundaries of the mid-sagittal CC, as the underlying connectivity based on the inclusion criteria automatically performs this division. No streamline should travel downwards around the basal ganglia and internal capsules, nor should they enter the temporal lobe. Not derived from either XTRACT nor autoPTX, defined explicitly.

### FMA (Forceps major of corpus callosum)
The FMA contains the streamlines that pass through the splenium of the CC. Similarly to the FMI, two inclusion regions are placed coronally at each side of the midline, but in the occipital pole. The exlusion criteria includes the midline, but allows the entire CC (no anterior border of the CC is explicitly defined in the exclusion mask), and two regions on a coronal slice at the level of the splenium avoids streamlines going to the temporal lobe, as those constitute the tapetum. Derived from XTRACT (fma), which is nearly equal to autoPtx.

### TAPETUM
The tapetum contains the streamlines that interconnect the temporal lobes throgh the splenium of the CC. The entire CC is used as an inclusion region, and also one at each hemisphere, coronally, at the level of the temporal lobe. Exclusion regions in the cingulum avoid having contamination from CGH. Not derived from either XTRACT nor autoPTX, defined explicitly.


# Association fibers
## AF (Arcuate Fasciculus)
The AF connects the temporal and frontal lobes.  An inclusion region is placed coronally at the level of the corona radiata around the low-FA region where the CC and AF are known to cross, and on an axial slice at the level of the temporo-parietal junction. Exclusion regions avoid the frontal pole, midline and streamlines moving towards the posterior portion of the brain. Modified from XTRACT (af).

## FA (Frontal aslant)
Also known as the anterior transverse system (ATS) is a short fiber system that connects the medial superior frontal cortex to the inferior frontal gyrus and the inferior portion of the precentral gyrus. As such, inclusion regions are drawin underneath the superior frontal gyrus and in the white matter related to the inferior frontal gyrus. Derived from XTRACT (fa).

## FX (Fornix)
Streamlines of the FX interconnect the hippocampus and the mamillary body of the same hemisphere. Inclusion regions are placed at the hippocampus, and in the crus of the FX, where it is easily observed just above the thalamus, surrounded by CSF. Exclusion criteria avoid fibers that enter the AC and extend laterally. The commissural portion of the FX (*psalterium* or *Lyra Davidis*) is not included in this bundle. Adapted from XTRACT (fx); amongst other changes, the crus of the fornix was expanded as an inclusion region.

## IFOF (Inferior fronto-occipital fasciculus)
This very long bundle connects the frontal and occipital lobes. While bundle fans out at each lobe, the streamlines converge in a very discrete portion in the superior aspect of the temporal lobe, just inferior to the external capsule. This is near where streamlines of the UF bend from the temporal towards the frontal lobe, so streamlines traversing to the temporal pole are discarded. It is also common for some frontal fibers to follow the IFOF then deviate towards to the brain stem and cerebellum, but these are also discarded. Taken from XTRACT (ifo), which is nearly identical to autoPtx (ifo); added an extra exclusion region at the cerebellum.

## ILF (Inferior longitudinal fasciculus)
Interconnects the temporal and occipital lobes, traveling through the middle and inferior portions of the temporal lobe, but not through the white matter related to the superior temporal gyrus. Contamination with the CGH and brain stem is avoided with exclusion regions in those areas. Taken from XTRACT (ilf).

## MLF (Middle longitudinal fasciculus)
Connects the temporal lobe with the parietal lobule and occipital lobe. Inclusion regions are located in the white matter related to the parietal lobule and occipital lobe, and another in the white matter related to the superior temporal gyrus. Exclusion regions avoid the midline, the inferior portion of the temporal lobe, and the frontal lobe. Taken from XTRACT (mdlf)

## OR (Optic radiation)
The optic radiation connects the lateral geniculate body to the visual cortex in the occipital lobe. Upon emerging from the geniculate body, it has a short-lived anterior trajectory towards the temporal pole forming Meyer's loop, then bends and directs towards the occipital lobe. Inclusion criteria are a circumscribed ROI of the geniculate body, and a coronal slice in the occipital lobe. While the first ROI is likely to include pontine fibers, the FX and the CGH, the second inclusion criteria is crucial for the selection of the OR alone. Exclusion regions in the midline, the CGH exlcude contanminant streamlines. A final exclusion region is drawn coronally at the temporal pole. This is a difficult ROI, as it has the danger of excluding streamlines in Meyer's loop, which has a variable degree of anterior extent amongst individuals. Taken from XTRACT (or).


## SLF (Superior longitudinal fasciculus)
Three different portions of the SLF have been described, but the bundle is here presented as a whole, without subdivisions. Coronal inclusion criteria are located in the superior, middle and inferior frontal gyri, and in the superior parietal lobule, supramarginal gyrus and angular gyrus. Exclusion criteria include the superior temporal lobe (to avoid the TAPETUM and ILF), the midline and a coronal slice at the level of the thalamus, encompassing all structures inferior to the corpus callosum. Taken from XTRACT, where the SLF is dissected in three portions (slf1, slf2 and slf3); the inclusion regions for the three portions were combined.

## UF (Uncinate fasciculus)
Connects the anterior portions of the temporal and frontal lobes. Two inclusion criteria are located in coronal slices separated by the Sylvian fissure. The Sylvian fissure itself serves an an exclusion region, with additional exclusions at the midline, and at the level of the thalamus (coronal and sagittal). Taken from XTRACT (uf), which is  identical to autoPtx (unc).

## Cingulum
The Cingulum is a very long bundle that connects the temporal, parietal and frontal lobes. It navigates around the corpus callosum, which it cinches. It has a subgenual portion anteriorly, a large fronto-parietal section (CGFP) directly above the CC, and a retrosplenial and temporal portion towards the parahippocampal gyrus (CGH). It is possible to dissect it as a whole, but it is easier and more reliable to do so in portions.

### CG (Cingulum, whole)
Three inclusion criteria are drawn. One just anterior to the genu of the CC, one at the mid-portion of the fronto-parietal CG, and one retro-splenial. Exclusion regions play a major role in dissecting this large bundle, which are drawn in all planes and intended to exclude any streamline crossing the midline, extending laterally towards the temporal lobes (the CG is a medial structure), or towards the most anterior or superior aspects of the frontal lobe, the parietal lobe, and the occipital lobe. The subgenual fibers often move towards the midline and continue through the AC, which are also avoided. Not derived from either autoPtx or XTRACT, but following similar

### CGR (Cingulum, rostral and subgenual)
The most anterior aspect of the CG wraps around the genu of the CC. Anatomically, fibers continue towards the parietal and temporal lobes as the CGFP, but in this dissection the streamlines are truncated as they begin to take a fronto-parietal direction. Inclusion regions are drawn coronally underneath the rostrum of the CC, and at the anterior third of the CGFP.  The ROI at the CGFP will therefore include many streamlines that are also part of the CGFP, but only those reaching the subgenual aspect of the CG are selected, then truncated based on the stop criterion. Exclusion criteria avoid contamination with the AC, UF and other frontal fiber systems. Taken from XTRACT (cbp).

### CGFP (Cingulum, fronto-parietal portion)
This is the longest portion of the CG, continuing the CGR and CGH. Streamlines are truncated to only show the frontoparietal aspect of the CG, anteriorly where the CG begins its antero-posterior trajectory, and posterior to the splenium of the CC, before the streamlines enter the temporal lobe. Three inclusion regions are used, two the previously described extremes of the bundle, and one coronally at the mid-portion of the bundle. Exclusion criteria avoid streamlines that reach the frontal and occipital poles, and the most superior portion of the frontal and parietal lobes. Not derived from either XTRACT nor autoPtx, defined explicitly.


### CGH (Cingulum, parahippocampal portion)
This bundle takes an oblique trajectory in the medial aspect of the temporal lobe. It is located postero-inferior with respect to the FX, and as it travels superior and posteriorly, it diverges from it and cinches the splenium of the CC. Inclusion regions are drawn at the mesial temporal lobe and retrosplenial. As with the other two portions of the CG, the streamlines are artificially truncated, in this case  posterior to the splenium to restrict them to the temporal lobe,  Exclusion regions avoid the occipital pole and the lateral aspects of the temporal lobe. Not derived from either XTRACT nor autoPtx, defined explicitly.

# Projection fibers
## CST (Corticospinal tract)
This long projection fiber interconnects the motor cortex and the brain stem. Anatomically, the fibers extend to the spinal cord, but are not included in the acquisition. A large inclusion region encompasses the pre-and post-central gyri, with another inclusion region drawn at the level of the brain stem. Exclusion regions avoid the cerebellum, midline, and frontal and occipital lobes. Taken from XTRACT (cst), which is in turn nearly identical to autoPtx (cst)


# Summary
|Tract|Derived from|Other name|Lanirem target vol|Other target vol|target Dice|Lanirem exclude vol|Other exclude vol|exclude Dice|
|----|:----:|:----:|:----:|:----:|:----:|:----:|:----:|:----:|
|AC|xtract|ac|1945|1945|1|20963|6720|0.485497|
|FMI|xtract/autoptx|fmi|19195|19195|1|243015|243015|1|
|FMA|xtract/autoptx|fma|18356|18159|0.990716|143355|143355|1|
|CC_MID|None|N/A|32027|N/A|N/A|14677|N/A|N/A|
|TAPETUM|None|N/A|11231|N/A|N/A|13469|N/A|N/A|
|AF_L|xtract|af_l|3003|10557|0.134366|114644|86932|0.00631027|
|FA_L|xtract|fa_l|2400|2400|1|223152|216762|0.452748|
|FX_L|xtract|fx_l|564|173|0.466757|162458|106865|0.490742|
|IFOF_L|xtract/autoptx|ifo_l|29053|28828|0.950917|132873|128694|0.984023|
|ILF_L|xtract|ilf_l|2656|2656|1|91649|86406|0.970442|
|MLF_L|xtract|mdlf_l|8189|8189|1|111152|87743|0.882305|
|OR_L|xtract|or_l|49738|49195|0.994511|376177|376177|1|
|SLF_L|xtract|slf_l|15905|15905|1|207688|194700|0.967723|
|UF_L|xtract/autoptx|uf_l|1355|1368|0.899008|93439|72457|0.476118|
|CG_L|None|N/A|1300|N/A|N/A|97516|N/A|N/A|
|CGR_L|xtract|cbp_l|390|390|1|121501|216762|0.192797|
|CGFP_L|None|N/A|1300|N/A|N/A|121501|N/A|N/A|
|CGH_L|None|N/A|1069|N/A|N/A|121501|N/A|N/A|
|CST_L|xtract|cst_l|83354|83354|1|359998|372690|0.982677|
