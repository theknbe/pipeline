% kb_installSeg.m
% 
% Kelly Byrne | Silver Lab | UC Berkeley | 
% modified from code written by the Winawer lab and available at: https://wikis.nyu.edu/display/winawerlab/Initialize+data
%
% requires the VISTA Lab's Vistasoft package - available at: https://github.com/vistalab/vistasoft
%
% initiates an mrVista session for the given subject
%
% required input: user-defined parameters
% desired output: mrInit2_params.mat, mrSESSION.mat, mrSESSION_backup.mat
% ________________________________________________________________________________________________


% close any open windows and open mrVista
clear all; close all;
mrVista;

% install segmentation
vw = initHiddenInplane;
query = 0;
keepAllNodes = 0;
filePaths = {'nifti/t1Class.nii.gz'};
numGrayLayers = 3;
installSegmentation(query, keepAllNodes, filePaths, numGrayLayers)

% check segmentation
vo = open3ViewWindow('gray');

