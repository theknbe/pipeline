#!/bin/sh
#
#Kelly Byrne | Silver Lab | UC Berkeley | 2015-09-14
#modified from code written by the Winawer lab and available at: https://wikis.nyu.edu/display/winawerlab/Freesurfer+autosegmentation

#requires the LCN's recon-all and mri_convert scripts, parts of the Freesurfer package available at: https://surfer.nmr.mgh.harvard.edu/fswiki/DownloadAndInstall 
#requires MATLAB version 2012b (feel free to try with other versions, but beware that I have not), info for Berkeley student licenses available at: https://software.berkeley.edu/MATLAB_FAQs#Acquire
#requires kb_fs_ribbon2itk.m, included in this repository in the silverVista directory

#kb_generateSeg.sh: calls recon-all to generate an automated segmentation of the cortical surface & converts
#mgz files to nifti

#required command-line argument: subject ID
#usage example: kb_fsmgz2nii.sh KB_091415

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#NOTE: you should modify study-specific file names/paths

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
echo " "
echo "done converting t1 classification file: ribbon.mgz ---> t1Class.nii.gz"
echo " "

# copy files to the server so they can be accessed from the windows workstation
# NOTE: if your files are stored on the server (which they typically are) this section can be commented out
mkdir /Volumes/Plata2/MRS_amblyopia/newSegs/$1/
mkdir /Volumes/Plata2/MRS_amblyopia/newSegs/$1/orig
mkdir /Volumes/Plata2/MRS_amblyopia/newSegs/$1/manualEdits
cp $projHome/$1/nifti/t1FS.nii.gz /Volumes/Plata2/MRS_amblyopia/newSegs/$1/orig
cp $niftiDir/t1Class.nii.gz /Volumes/Plata2/MRS_amblyopia/newSegs/$1/orig
echo "case files copied to Plata2 -- manual edits to the segmentation should be performed using ITKGray on Burrata (the windows workstation, currently in 582D)"