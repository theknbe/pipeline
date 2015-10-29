% kb_initializeVista.m
% 
% Kelly Byrne | Silver Lab | UC Berkeley | 2014-09-22
% modified from code written by the Winawer lab and available at: https://wikis.nyu.edu/display/winawerlab/Initialize+data
%
% requires the VISTA Lab's Vistasoft package - available at: https://github.com/vistalab/vistasoft
%
% initiates an mrVista session for the given subject
%
% required input: user-defined parameters
% desired output: mrInit2_params.mat, mrSESSION.mat, mrSESSION_backup.mat
% ________________________________________________________________________________________________

% user-defined parameters:
subj = 'KB_091615';
sessPath = sprintf('/Volumes/passportKB/DATA/%s', subj);
keepFrames = [12 372; 12 372; 12 372];  % each pair of numbers corresponds to one EPI, the first number indicates the first 
                                        % frame of the scan to keep, the second number indicates the total to keep and will
                                        % be the total number of frames in the clipped time series

% NOTE: you should also modify study-specific file names/paths, and fields in the params struct like
% annotations, scanGroups etc.

% set session path
cd(sessPath)

% set-up functional and par files, inplane, and volume anatomy
epiList = dir(fullfile(sessPath, 'nifti','epi*'));
for run = 1:numel(epiList)
    epiFile{run} = fullfile(sessPath, 'nifti', epiList(run).name); 
    assert(exist(epiFile{run}, 'file')>0);
end

parList = dir(fullfile(sessPath, 'Stimuli', 'Parfiles', '*par'));
for par = 1:numel(parList)
    parFile{par} = fullfile(sessPath, 'Stimuli', 'Parfiles', parList(par).name);
    assert(exist(parFile{par}, 'file')>0);
end

G = exist('nifti/gems.nii.gz');
if G == 2
    inplaneFile = fullfile(sessPath, 'nifti','gems.nii.gz');
elseif G == 0
    inplaneFile = fullfile(sessPath, 'nifti','gems_avg_epi01_mcf.nii.gz');
else
    disp('No inplane file found - try averaging the first EPI scan');
end
assert(exist(inplaneFile, 'file')>0)
 
anatFile = fullfile(sessPath, 'nifti', 't1FS.nii.gz');
assert(exist(anatFile, 'file')>0)

% create general params struct and specify desired parameters 
params = mrInitDefaultParams; 
params.inplane = inplaneFile; 
params.functionals = epiFile; 
params.vAnatomy = anatFile;
params.parfile = parFile;
params.keepFrames = keepFrames;
params.sessionDir = sessPath;
params.subject = subj;
params.annotations = {'localizer' 'plaid1' 'plaid2'};
params.scanGroups = {[1], [2, 3]};

% fix headers
% localizer
ni = readFileNifti('nifti/epi01_localizer_mcf.nii.gz');
ni = niftiCheckQto(ni);
ni.qform = 1;
ni.sform = 1;
ni.freq_dim = 1;
ni.phase_dim = 2;
ni.slice_dim = 3;
ni.slice_end = 15; %(number of slices-1)
ni.slice_duration = 0.0625; %(TR/#slices)
writeFileNifti(ni);

% plaids
ni = readFileNifti('nifti/epi02_plaid1_mcf.nii.gz');
ni = niftiCheckQto(ni);
ni.qform = 1;
ni.sform = 1;
ni.freq_dim = 1;
ni.phase_dim = 2;
ni.slice_dim = 3;
ni.slice_end = 15; %(number of slices-1)
ni.slice_duration = 0.0625; %(TR/#slices)
writeFileNifti(ni);

ni = readFileNifti('nifti/epi03_plaid2_mcf.nii.gz');
ni = niftiCheckQto(ni);
ni.qform = 1;
ni.sform = 1;
ni.freq_dim = 1;
ni.phase_dim = 2;
ni.slice_dim = 3;
ni.slice_end = 15; %(number of slices-1)
ni.slice_duration = 0.0625; %(TR/#slices)
writeFileNifti(ni);

% gems
if G == 2
    ni = readFileNifti('nifti/gems.nii.gz');
else
    ni = readFileNifti('nifti/gems_avg_epi01_mcf.nii.gz');
end
ni = niftiCheckQto(ni);
ni.qform = 1;
ni.sform = 1;
ni.freq_dim = 1;
ni.phase_dim = 2;
ni.slice_dim = 3;
writeFileNifti(ni);

% t1
ni = readFileNifti('nifti/t1FS.nii.gz');
ni = niftiCheckQto(ni);
ni.qform = 1;
ni.sform = 1;
ni.freq_dim = 1;
ni.phase_dim = 2;
ni.slice_dim = 3;
writeFileNifti(ni);

% leave a log file
fid = fopen('headersFixed.txt', 'at');
fprintf(fid, datestr(now));
fclose(fid);

% initialize the session
mrInit(params)

% set vANATOMYPATH
setVAnatomyPath(anatFile);

