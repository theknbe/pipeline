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
export projHome=/Volumes/passportKB/DATA
export niftiDir=$projHome/$1/nifti
export vol0=T1

# run re-recon all to generate an automated segmentation of the cortical surface
recon-all -i $projHome/$1/nifti/mprage.nii.gz -subjid $1 -all

# convert freesurfer t1 & t1 class files from mgz to nifti
	# NOTE: running MATLAB from the command line with the -r option will only accept string arguments. if you need to pass a non-string argument, simplest
	# solution is to leave the variable undefined here and modify the called m-file to include a default value
mri_convert $SUBJECTS_DIR/$1/mri/$vol0.mgz $projHome/$1/nifti/t1FS.nii.gz
echo "done converting t1 file: T1.mgz ---> t1FS.nii.gz"
export subjID=$SUBJECTS_DIR/$1/mri/ribbon.mgz
export outFile=$niftiDir/t1Class.nii.gz
export fillWithCSF=
export alignTo=$niftiDir/t1FS.nii.gz
export resampleType=
/Applications/MATLAB_R2012b.app/bin/matlab -nosplash -nodesktop -r "try, kb_fs_ribbon2itk('$subjID', '$outFile', '$fillWithCSF', '$alignTo', '$resampleType'); catch; end; exit"
echo "done converting t1 classification file: ribbon.mgz ---> t1Class.nii.gz"



