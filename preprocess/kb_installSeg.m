% kb_installSeg.m
% 
% Kelly Byrne | Silver Lab | UC Berkeley | 2015-09-27 
% modified from code written by the Winawer lab and available at: https://wikis.nyu.edu/display/winawerlab/Install+segmentation
%
% requires the VISTA Lab's Vistasoft package - available at: https://github.com/vistalab/vistasoft
%
% installs an existing cortical segmentation into an existing mrSESSION
%
% required input: user-defined parameters
% desired output: open gray window (if the installation fails, the window will not open)
% ________________________________________________________________________________________________

% user-defined parameters:
query = 0;
keepAllNodes = 0;
filePaths = {'nifti/t1Class.nii.gz'}; %path from working directory to the classification file
numGrayLayers = 3;

% close any open windows and open mrVista
clear all; close all;
mrVista;

% install segmentation
vw = initHiddenInplane;
installSegmentation(query, keepAllNodes, filePaths, numGrayLayers)

% check segmentation
vo = open3ViewWindow('gray');

