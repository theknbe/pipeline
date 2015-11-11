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
subj = sprintf('JM_092914');
sessPath = sprintf('%s/%s', projHome, subj);

% open a connection to the mesh server
% GUI will appear asking to allow incoming connections, this is OK - allow it!
% to stop the GUI from appearing, add a signature to the mrMeshMac application and server executable
% see the website below (specifically answers 2 & 3) for helpful information about this process 
% http://apple.stackexchange.com/questions/3271/how-to-get-rid-of-firewall-accept-incoming-connections-dialog
cd(sessPath)
close all;
mrmStart(1,'localhost');

% build and inflate left hemisphere mesh
% 3 GUIs will appear - the first is the build parameters, you can accept the default values. the second should ask for 
% confirmation that the appropriate class file was found. the third will ask you to save the pial surface for the
% hemisphere you're working on, our naming convention is lh_pial for the left hemisphere 
open3ViewWindow('gray')
fName = fullfile(projHome, filesep, subj, 'nifti/t1Class.nii.gz');
VOLUME{1} = meshBuild(VOLUME{1}, 'left');  
MSH = meshVisualize( viewGet(VOLUME{1}, 'Mesh') );  
MSH = meshSet(MSH,'smooth_iterations',600);
MSH = meshSet(MSH,'smooth_relaxation',0.5);
MSH = meshSet(MSH,'smooth_sinc_method',0);
MSH = meshSmooth(MSH);
MSH = meshColor(MSH);
filename='nifti/lh_inflated.mat';
verbose=1;
mrmWriteMeshFile(MSH, filename, verbose)

% build and inflate right hemisphere mesh
% 3 GUIs will appear - the first is the build parameters, you can accept the default values. the second should ask for 
% confirmation that the appropriate class file was found. the third will ask you to save the pial surface for the
% hemisphere you're working on, our naming convention is rh_pial for the right hemisphere 
open3ViewWindow('gray')
fName = fullfile(projHome, filesep, subj, 'nifti/t1Class.nii.gz');
VOLUME{2} = meshBuild(VOLUME{2}, 'right');  MSH = meshVisualize( viewGet(VOLUME{2}, 'Mesh') );  
MSH = meshSet(MSH,'smooth_iterations',600);
MSH = meshSet(MSH,'smooth_relaxation',0.5);
MSH = meshSet(MSH,'smooth_sinc_method',0);
MSH = meshSmooth(MSH);
MSH = meshColor(MSH);
filename='nifti/rh_inflated.mat';
mrmWriteMeshFile(MSH, filename, verbose)

% close windows and connection to the mesh server
mrmCloseWindow(1001,'localhost');
mrmCloseWindow(1003,'localhost');
PATH = getenv('PATH');
setenv('PATH', [PATH ':/usr/local/bin']);
unix('kb_mrmClose.sh');