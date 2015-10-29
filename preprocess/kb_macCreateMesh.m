% kb_macCreateMesh.m
% 
% Kelly Byrne | Silver Lab | UC Berkeley | 2015-09-28
% modified from code written by the VISTA lab and available at: http://web.stanford.edu/group/vista/cgi-bin/wiki/index.php/Mesh#Creating_a_mesh
%
% builds and saves a smoothed and inflated mesh for each hemispheres
%
% required input: user-defined parameters
% desired output: lh_pial.mat, rh_pial.mat, lh_inflated.mat rh_inflated.mat
% ________________________________________________________________________________________________

% user-defined parameters:
projHome = sprintf('/Volumes/passportKB/DATA');
subj = sprintf('KB_091615');

% open a connection to the mesh server
% GUI will appear asking to allow incoming connections, this is OK - allow it!
% to stop the GUI from appearing, add a signature to the mrMeshMac application and server executable
% see the website below (specifically answers 2 & 3) for helpful information about this process 
% http://apple.stackexchange.com/questions/3271/how-to-get-rid-of-firewall-accept-incoming-connections-dialog
close all;
mrmStart(1,'localhost');

% build left hemisphere mesh
fName = fullfile(projHome, filesep, subj, 'nifti/t1Class.nii.gz');
msh = meshBuildFromNiftiClass(fName, 'left');
msh = meshSmooth(msh);
msh = meshColor(msh);

save lh_pial.mat msh
clear msh

% build right hemisphere mesh 
fName = fullfile(projHome, filesep, subj, 'nifti/t1Class.nii.gz');
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

save lh_inflated.mat msh
clear msh

% inflate and display RH
load rh_pial.mat
msh = meshSet(msh,'smooth_iterations',600);
msh = meshSet(msh,'smooth_relaxation',0.5);
msh = meshSet(msh,'smooth_sinc_method',0);
msh = meshSmooth(msh);

save rh_inflated.mat msh
clear msh

% close windows and connection to the mesh server
mrmCloseWindow(1001,'localhost');
mrmCloseWindow(1003,'localhost');
mrmCloseWindow(1005,'localhost');
mrmCloseWindow(1007,'localhost');
PATH = getenv('PATH');
setenv('PATH', [PATH ':/usr/local/bin']);
unix('kb_mrmClose.sh');