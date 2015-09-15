% kb_initializeVista.m
% 
% Kelly Byrne | 09.22.14
%
% initiates an mrVista session for the given subject
%
% run from subject parent directory
%
% required input: user-defined parameters
% desired output: mrInit2_params.mat, mrSESSION.mat, mrSESSION_backup.mat
% ________________________________________________________________________________________________

% user-defined parameters:
subj = 'MG_050414';
sessPath = sprintf('/Volumes/passportKB/DATA/%s', subj);

% NOTE: you should also edit study-specific fields in the params struct like
% annotations and scan groupings

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
 
anatFile = fullfile(sessPath, 'nifti', 'mprage.nii.gz');
assert(exist(anatFile, 'file')>0)

% create params struct and specify desired parameters 
params = mrInitDefaultParams; 
params.inplane = inplaneFile; 
params.functionals = epiFile; 
params.vAnatomy = anatFile;
params.parfile = parFile;
params.sessionDir = sessPath;
params.subject = subj;
params.annotations = {'localizer' 'plaid1' 'plaid2'};
params.scanGroups = {[1], [2, 3]};

% initialize the session
mrInit(params)
