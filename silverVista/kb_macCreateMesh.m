projHome = sprintf('/Volumes/passportKB/DATA/new');
subj = sprintf('MG_050414');

% build left hemisphere mesh
close all;
windowID = mrmStart(1, 'localhost');

fName = fullfile(projHome, filesep, subj, 'nifti/t1_class.nii.gz');
msh = meshBuildFromNiftiClass(fName, 'left');
msh = meshSmooth(msh);
msh = meshColor(msh);

save lh_pial.mat msh
clear msh

% build right hemisphere mesh 

fName = fullfile(projHome, filesep, subj, 'nifti/t1_class.nii.gz');
msh = meshBuildFromNiftiClass(fName, 'right');
msh = meshSmooth(msh);
msh = meshColor(msh);

save rh_pial.mat msh
clear msh

% inflate and display LH

load lh_pial.mat
msh = meshSet(msh,'smooth_iterations',600);
msh = meshSet(msh,'smooth_relaxation',0.5);
msh = meshSet(msh,'smooth_sinc_method',0);
msh = meshSmooth(msh);
meshVisualize(msh);

save lh_inflated.mat msh
clear msh

% inflate and display RH

load rh_pial.mat
msh = meshSet(msh,'smooth_iterations',600);
msh = meshSet(msh,'smooth_relaxation',0.5);
msh = meshSet(msh,'smooth_sinc_method',0);
msh = meshSmooth(msh);
meshVisualize(msh);

save rh_inflated.mat msh
clear msh