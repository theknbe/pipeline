projHome = sprintf('/Volumes/passportKB/DATA/new');
subj = sprintf('MG_050414');

subjID = sprintf(projHome + '/' + subj + '/nifti/ribbon.mgz');
outFile = sprintf(projHome + '/' + subj + '/nifti/T1_class.nii.gz');
fillwithCSF = false;
alignTo = T1.nii.gz;
resampleType = [];

fs_ribbon2itk(subjID, outFile, fillwithCSF, alignTo, resampleType);
