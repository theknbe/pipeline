#!/bin/sh
#
#Kelly Byrne | Silver Lab | UC Berkeley | 2015-09-14

#kb_fsmgz2nii1.sh: calls Freesurfer's recon-all script to generate an automated segmentation of the cortical surface & begins
#process to convert mgz files to nifti

#intended for use with kb_fsmgz2nii2.m in MATLAB
#projHome variable should be user-defined
#required command-line argument: subject ID
#usage example: kb_fsmgz2nii.sh KB_091415

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

export FREESURFER_HOME=/Applications/freesurfer
source $FREESURFER_HOME/SetupFreeSurfer.sh
export SUBJECTS_DIR=/Volumes/passportKB/subjects/gabaMRS

export vol0=T1
export projHome=/Volumes/passportKB/DATA/

# run re-recon all to generate an automated segmentation of the cortical surface
#recon-all -i $projHome/$1/nifti/mprage.nii.gz -subjid $1 -all

# convert T1 to nifti
mri_convert $SUBJECTS_DIR/$1/mri/$vol0.mgz t1.nii.gz

echo "done converting Freesurfer volume"

# move nifti and ribbon to subject directory
cd projHome/$1/nifti
mv $SUBJECTS_DIR/$1/mri/*.nii.gz .
mv $SUBJECTS_DIR/subjects/$1/mri/ribbon.mgz .

# open MATLAB
cd ..
/Applications/MATLAB_R2012b.app/bin/matlab



