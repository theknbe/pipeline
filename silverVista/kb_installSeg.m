projHome = sprintf('/Volumes/passportKB/DATA/new');
subj = sprintf('MG_050414');

% install segmentation
vw = initHiddenInplane;
query = 0;
keepAllNodes = false;
filePaths = {'nifti/t1_class.nii.gz'};
numGrayLayers = 3;
installSegmentation(query, keepAllNodes, filePaths, numGrayLayers);

%check segmentation
vo = open3ViewWindow('volume');

