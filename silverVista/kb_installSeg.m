projHome = sprintf('/Volumes/passportKB/DATA');
subj = sprintf('MG_050414');

% install segmentation
vw = initHiddenInplane;
query = 0;
keepAllNodes = true;
filePaths = {'nifti/t1Class.nii.gz'};
numGrayLayers = 3;
kb_installSegmentation(query, keepAllNodes, filePaths, numGrayLayers);

%check segmentation
vo = open3ViewWindow('volume');

