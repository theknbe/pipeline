% install segmentation
vw = initHiddenInplane;
query = 0;
keepAllNodes = 0;
filePaths = {'nifti/t1Class.nii.gz'};
numGrayLayers = 3;
installSegmentation(query, keepAllNodes, filePaths, numGrayLayers)

% check segmentation
vo = open3ViewWindow('gray');

