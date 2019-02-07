function [] = noddi_matlab()

if ~isdeployed
  disp('adding paths');
  addpath(genpath('/N/u/brlife/git/jsonlab'))
  addpath(genpath('/N/dc2/projects/lifebid/Concussion/noddi_matlab/niftimatlib-1.2'))
  addpath(genpath('/N/dc2/projects/lifebid/Concussion/noddi_matlab/NODDI_toolbox_v1.01'))
end

config = loadjson('config.json');

dwi = 'dwi.nii.gz';
bvals = fullfile(config.bvals);
bvecs = fullfile(config.bvecs);
mask = 'mask.nii';

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
SaveParamsAsNIfTI('FittedParams.mat','NODDI_roi.mat',mask,'noddi_fit');

exit;
end
