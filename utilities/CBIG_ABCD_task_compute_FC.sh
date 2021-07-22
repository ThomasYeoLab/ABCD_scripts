#!/bin/bash

# Written by Jianzhong Chen and CBIG under MIT license: https://github.com/ThomasYeoLab/CBIG/blob/master/LICENSE.md

id=$1
output_dir=$2
FD_th=$3
DV_th=$4
proc_scripts_dir=${CBIG_CODE_DIR}/stable_projects/preprocessing/CBIG_fMRI_Preproc2016
mid_bold=`cat ${output_dir}/${id}/logs/${id}.mid.bold`
nback_bold=`cat ${output_dir}/${id}/logs/${id}.nback.bold`
sst_bold=`cat ${output_dir}/${id}/logs/${id}.sst.bold`
qc_score=`cat ${output_dir}/${id}/logs/${id}.qcscore`

if [ $qc_score -eq 1 ];then

	echo mid
	${proc_scripts_dir}/CBIG_preproc_FCmetrics_wrapper.csh -s ${id} -d ${output_dir} -bld "${mid_bold}" -BOLD_stem _task_mc_skip_residc_interp_FDRMS${FD_th}_DVARS${DV_th}_bp_0.009_0.08 -SURF_stem _task_mc_skip_residc_interp_FDRMS${FD_th}_DVARS${DV_th}_bp_0.009_0.08_fs6_sm6 -OUTLIER_stem _FDRMS${FD_th}_DVARS${DV_th}_motion_outliers.txt -Pearson_r -censor
	mv ${output_dir}/${id}/FC_metrics/Pearson_r/${id}_task_mc_skip_residc_interp_FDRMS${FD_th}_DVARS${DV_th}_bp_0.009_0.08_fs6_sm6_all2all.mat ${output_dir}/${id}/FC_metrics/Pearson_r/${id}_task_mc_skip_residc_interp_FDRMS${FD_th}_DVARS${DV_th}_bp_0.009_0.08_fs6_sm6_all2all_mid.mat

	echo nback
	${proc_scripts_dir}/CBIG_preproc_FCmetrics_wrapper.csh -s ${id} -d ${output_dir} -bld "${nback_bold}" -BOLD_stem _task_mc_skip_residc_interp_FDRMS${FD_th}_DVARS${DV_th}_bp_0.009_0.08 -SURF_stem _task_mc_skip_residc_interp_FDRMS${FD_th}_DVARS${DV_th}_bp_0.009_0.08_fs6_sm6 -OUTLIER_stem _FDRMS${FD_th}_DVARS${DV_th}_motion_outliers.txt -Pearson_r -censor
	mv ${output_dir}/${id}/FC_metrics/Pearson_r/${id}_task_mc_skip_residc_interp_FDRMS${FD_th}_DVARS${DV_th}_bp_0.009_0.08_fs6_sm6_all2all.mat ${output_dir}/${id}/FC_metrics/Pearson_r/${id}_task_mc_skip_residc_interp_FDRMS${FD_th}_DVARS${DV_th}_bp_0.009_0.08_fs6_sm6_all2all_nback.mat

	echo sst
	${proc_scripts_dir}/CBIG_preproc_FCmetrics_wrapper.csh -s ${id} -d ${output_dir} -bld "${sst_bold}" -BOLD_stem _task_mc_skip_residc_interp_FDRMS${FD_th}_DVARS${DV_th}_bp_0.009_0.08 -SURF_stem _task_mc_skip_residc_interp_FDRMS${FD_th}_DVARS${DV_th}_bp_0.009_0.08_fs6_sm6 -OUTLIER_stem _FDRMS${FD_th}_DVARS${DV_th}_motion_outliers.txt -Pearson_r -censor
	mv ${output_dir}/${id}/FC_metrics/Pearson_r/${id}_task_mc_skip_residc_interp_FDRMS${FD_th}_DVARS${DV_th}_bp_0.009_0.08_fs6_sm6_all2all.mat ${output_dir}/${id}/FC_metrics/Pearson_r/${id}_task_mc_skip_residc_interp_FDRMS${FD_th}_DVARS${DV_th}_bp_0.009_0.08_fs6_sm6_all2all_sst.mat

fi
