#!/bin/bash

dwi=`jq -r '.dwi' config.json`;
bvals=`jq -r '.dwi' config.json`;
bvecs=`jq -r '.dwi' config.json`;
doadvance=`jq -r '.advancedMask' config.json`;
otherMask=`jq -r '.mask' config.json`;

gunzip ${dwi} ./dwi.nii;

if [ -f $otherMask ];then
	gunzip ${otherMask} ./mask.nii;
else

	if [ -f nodif.nii.gz ];then
		echo "b0 exists. skipping"
	else
		"create b0 image"
		# Create b0
		select_dwi_vols \
			${dwi} \
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

	gunzip nodif_brain_mask.nii.gz mask.nii;
	gunzip nodif_brain.nii.gz brain_extracted.nii;
fi

if [ -f mask.nii ];then
	echo "brainmask and gunzip completed"
	rm -rf *nodif*
else
	echo "output missing"
	exit 1
fi



