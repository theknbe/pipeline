% kb_initializeVista.m
% 
% Kelly Byrne | 09.22.14
% modified from code written by the Winawer lab and available at: https://wikis.nyu.edu/display/winawerlab/Initialize+data
%
% initiates an mrVista session for the given subject
%
% run from subject parent directory
%
% required input: user-defined parameters
% desired output: mrInit2_params.mat, mrSESSION.mat, mrSESSION_backup.mat
% ________________________________________________________________________________________________

% user-defined parameters:
subj = 'KB_091615';
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
 
anatFile = fullfile(sessPath, 'nifti', 't1FS.nii.gz');
assert(exist(anatFile, 'file')>0)

% set analysis params for coherence
for scan = 1:numel(epiList)
    coParams{scan} = coParamsDefault;    
        if scan == 1
            coParams{scan}.nCycles = 31;
        else
            coParams{scan}.blockedAnalysis = 0;
        end
end

% set analysis params for GLM
for scan = 1:numel(epiList)
    erParams{scan} = er_defaultParams;
        if scan == 1
            erParams{scan}.eventAnalysis = 1;
            erParams{scan}.detrendFrames = 6;
            erParams{scan}.glmHRF = 2; % SPM difference of gammas
            erParams{scan}.onsetDelta = 3;  % frame offset for this scan (this should be negative if frames were clipped from
                                            % scan start, and positive if extra frames were acquired)
        elseif scan == 2
            erParams{scan}.eventAnalysis = 1;
            erParams{scan}.detrendFrames = 12;
            erParams{scan}.glmHRF = 2; % SPM difference of gammas
            erParams{scan}.onsetDelta = 2; % frame offset
        elseif scan == 3
            erParams{scan}.eventAnalysis = 1;
            erParams{scan}.detrendFrames = 12;
            erParams{scan}.glmHRF = 2; % SPM difference of gammas
            erParams{scan}.onsetDelta = 3; % frame offset
        end
end

% create general params struct and specify desired parameters 
params = mrInitDefaultParams; 
params.inplane = inplaneFile; 
params.functionals = epiFile; 
params.vAnatomy = anatFile;
params.parfile = parFile;
params.coParams = coParams;
params.glmParams = erParams;
%params.applyGlm = 1;
params.sessionDir = sessPath;
params.subject = subj;
params.annotations = {'localizer' 'plaid1' 'plaid2'};
params.scanGroups = {[1], [2, 3]};

% initialize the session
mrInit(params)
