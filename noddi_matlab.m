function [] = noddi_matlab(dwi,bvals,bvecs,mask)

%switch getenv('ENV')
%case 'IUHPC'
  disp('loading paths (HPC)')
  addpath(genpath('/N/u/brlife/git/jsonlab'))
  addpath(genpath('/N/dc2/projects/lifebid/Concussion/noddi_matlab/niftimatlib-1.2'))
  addpath(genpath('/N/dc2/projects/lifebid/Concussion/noddi_matlab/NODDI_toolbox_v1.01'))
%case 'VM'
%  disp('loading paths (VM)')
%  addpath(genpath('/usr/local/vistasoft'))
%  addpath(genpath('/usr/local/jsonlab'))
%  addpath(genpath('/usr/local/spm'))
%end

config = loadjson('config.json');

dwi = fullfile(pwd,'dwi.nii');
bvals = fullfile(config.bvals);
bvecs = fullfile(config.bvecs);
mask = fullfile(pwd,'mask.nii');

% create ROI
display("creating ROI")
CreateROI(dwi,mask,'NODDI_roi.mat');

% create protocol
display("creating protocol")
protocol = FSL2Protocol(bvals,bvecs);

% intialize noddi model
display("initialize noddi")
noddi = MakeModel('WatsonSHStickTortIsoV_B0');

% batch fitt noddi model
display("batch fit noddi")
batch_fitting('NODDI_roi.mat',protocol,noddi,'FittedParams.mat',16);

% save noddi files
display("save noddi files")
SaveParamsAsNifti('FittedParams.mat','NODDI_roi.mat',mask,'noddi_fit');

