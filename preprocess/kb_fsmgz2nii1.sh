#!/bin/sh


export FREESURFER_HOME=/Applications/freesurfer
source $FREESURFER_HOME/SetupFreeSurfer.sh
export SUBJECTS_DIR=/Volumes/passportKB/subjects/gabaMRS

export vol0=T1
export projHome=/Volumes/passportKB/DATA/

# run re-recon all to generate an automated segmentation of the cortical surface
recon-all -i $projHome/$1/nifti/mprage.nii.gz -subjid $1 -all

# convert T1 to nifti
mri_convert $SUBJECTS_DIR/$1/mri/$vol0.mgz t1.nii.gz

echo "done converting Freesurfer volume"

# move nifti and ribbon to subject directory
cd projHome/$1/nifti
mv $FREESURFER_HOME/subjects/$1/mri/*.nii.gz .
mv $FREESURFER_HOME/subjects/$1/mri/ribbon.mgz .

# open MATLAB
cd ..
/Applications/MATLAB_R2012b.app/bin/matlab



