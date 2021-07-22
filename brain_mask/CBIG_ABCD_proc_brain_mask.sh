#!/bin/bash
id=$1
task=$2
thr=$3
anat_dir=${ABCD_DIR}/process/y0/recon_all
export SUBJECTS_DIR=$anat_dir
data_dir=${ABCD_DIR}/raw/images

############ process #############
echo $id
for bold in 01 02 03 04
do
	imdir=${data_dir}/sub-${id}/ses-baselineYear1Arm1/func
	imname=sub-${id}_ses-baselineYear1Arm1_task-${task}_run-${bold}_bold
	imfile=${imdir}/${imname}.nii
	maskdir=${imdir}/brainmask
	mkdir -p $maskdir
	if [ -f ${imfile} ];then
		echo "processing ${imfile}"
		fslmaths ${imfile} -Tmean -thr ${thr} -bin ${maskdir}/${imname}_mask_${thr}
		bbregister --bold --s $id --init-fsl --mov $imfile --reg ${maskdir}/${imname}_reg.dat
		mri_vol2vol --reg ${maskdir}/${imname}_reg.dat --targ $anat_dir/$id/mri/brainmask.mgz --mov $imfile --inv --o ${maskdir}/${imname}_bbr_mask.nii.gz
		fslmaths ${maskdir}/${imname}_mask_${thr} -add ${maskdir}/${imname}_bbr_mask -bin ${maskdir}/${imname}_union_mask
		mri_binarize --i ${maskdir}/${imname}_union_mask.nii.gz --o ${maskdir}/${imname}_loose_brain_mask.nii.gz --dilate 2 --min 0.0001
		fslmaths ${imfile} -mas ${maskdir}/${imname}_loose_brain_mask.nii.gz ${imdir}/${imname}_brain_masked.nii.gz
		if [ -f ${imdir}/${imname}_brain_masked.nii.gz ];then
			rm ${imfile}
		fi
	fi
done