# auto_tracto

Perform automatic virtual dissection of a full-brain tractogram.

Provide a pre-computed tck file and it will be dissected.
This is an adaptation of AutoPtx and XTRACT to work with MRtrix3. See these links:

https://fsl.fmrib.ox.ac.uk/fsl/fslwiki/AutoPtx

https://fsl.fmrib.ox.ac.uk/fsl/fslwiki/XTRACT


- The adaptation is only partial, as in AutoPtx and XTRACT the seeding of Streamlines   is performed for each bundle. Here, a full tractogram is provided, where the user   had the option to seed with whatever strategy was preferred. It is assumed, however,   that a full-brain seeding approach was used (white matter mask, GM/WM border, etc.)
- Another difference is the use of STOP ROIs, which only make sense if seeding   is performed per bundle, and not if filtering a full tractogram.   STOP ROIs are used, nonetheless, but rather as termination criteria that will truncate   the streamlines. Thus, STOP ROIs should be much larger than usual, to avoid   the appearance of multiple short-length truncated streamlines.
- The quality of the full brain tractogram will determine the quality of bundle separation.   It is highly recommended to provide a tractogram with more than one million streamlines,   and one that has been checked for errors. Strategies such as anatomically-contstrained   tractography (ACT) and spherical deconvolution informed filtering of tractograms (SIFT),   both available in MRTrix3 should aid in obtaining such high-quality tractograms.
