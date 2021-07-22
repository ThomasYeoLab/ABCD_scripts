#!/bin/bash

# Written by Jianzhong Chen and CBIG under MIT license: https://github.com/ThomasYeoLab/CBIG/blob/master/LICENSE.md

id=$1
output_dir=$2
FD_th=$3
DV_th=$4
rs_script_dir=${CBIG_CODE_DIR}/stable_projects/preprocessing/CBIG_fMRI_Preproc2016
id=${id/NDAR_/NDAR}
bold=`cat ${output_dir}/${id}/logs/${id}_pass_qc.bold`
if [ ! -z "$bold" ];then
    ${rs_script_dir}/CBIG_preproc_FCmetrics_wrapper.csh -s ${id} -d ${output_dir} -bld "${bold}" -BOLD_stem _rest_mc_skip_residc_interp_FDRMS${FD_th}_DVARS${DV_th}_bp_0.009_0.08 -SURF_stem _rest_mc_skip_residc_interp_FDRMS${FD_th}_DVARS${DV_th}_bp_0.009_0.08_fs6_sm6 -OUTLIER_stem _FDRMS${FD_th}_DVARS${DV_th}_motion_outliers.txt -Pearson_r -censor
fi
