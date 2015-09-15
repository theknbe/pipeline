projHome = sprintf('/Volumes/passportKB/DATA/new');
subj = sprintf('MS_050414');

subjID = sprintf(projHome + '/' + subj + '/nifti/ribbon.mgz');
outFile = sprintf(projHome + '/' + subj + '/nifti/t1Class.nii.gz');
fillwithCSF = false;
alignTo = t1FS.nii.gz;
resampleType = [];

fs_ribbon2itk(subjID, outFile, fillwithCSF, alignTo, resampleType);
