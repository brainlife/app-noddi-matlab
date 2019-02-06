#!/bin/bash
module load matlab/2017a

mkdir compiled

cat > build.m <<END
addpath(genpath('/N/u/brlife/git/jsonlab'))
addpath(genpath('/N/dc2/projects/lifebid/Concussion/noddi_matlab/niftimatlib-1.2'))
addpath(genpath('/N/dc2/projects/lifebid/Concussion/noddi_matlab/NODDI_toolbox_v1.01'))
mcc -m -R -nodisplay -d compiled noddi_matlab
exit
END
matlab -nodisplay -nosplash -r build
