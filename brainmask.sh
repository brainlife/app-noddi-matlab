#!/bin/bash

dwi=`jq -r '.dwi' config.json`;
bvals=`jq -r '.bvals' config.json`;
bvecs=`jq -r '.bvecs' config.json`;
doadvance=`jq -r '.advancedMask' config.json`;
otherMask=`jq -r '.mask' config.json`;

cp -v ${dwi} ./dwi.nii.gz

if [ -f $otherMask ];then
	cp -v ${otherMask} ./mask.nii.gz;
	gunzip ./mask.nii.gz;
else

	if [ -f nodif.nii.gz ];then
		echo "b0 exists. skipping"
	else
		echo "create b0 image"
		# Create b0
		select_dwi_vols \
			dwi.nii.gz \
			${bvals} \
			nodif.nii.gz \
			0;
	fi

	if [ -f nodif_brain.nii.gz ];then
		echo "brainmask exists. skipping"
	else
		echo "brain extraction via bet"
		# Brain extraction before alignment
		bet nodif.nii.gz \
			nodif_brain \
			-f 0.4 \
			-g 0 \
			-m;
	fi

	if [ $doadvance == true ]; then
		fslmaths ${otherMask} -mul nodif_brain_mask.nii.gz nodif_brain_mask.nii.gz
	fi

	gunzip nodif_brain_mask.nii.gz;
	gunzip nodif_brain.nii.gz;
fi

gunzip dwi.nii.gz;
mv nodif_brain_mask.nii mask.nii
mv nodif_brain.nii brain_extracted.nii
if [ -f mask.nii ];then
	echo "brainmask and gunzip completed"
	rm -rf *nodif*
else
	echo "output missing"
	exit 1
fi



