#!/bin/bash

# Written by Jianzhong Chen and CBIG under MIT license: https://github.com/ThomasYeoLab/CBIG/blob/master/LICENSE.md

########## Get input and environment variables
id=$1
path_file=$2
config_folder=$3
root_dir="$(dirname "$(dirname "$(readlink -fm "$0")")")"

source $path_file
source ${config_folder}/qc_thresholds.sh
source ${config_folder}/mc_par.sh

########## FMRI PREPROCESSING

id=${id/NDAR_/NDAR}
echo ${id}
raw_path=${rs_proc_dir}/lists/raw_path/${id}.txt
manufacturer=`cat ${rs_proc_dir}/lists/manufacturer/${id}.txt`
config_file=${config_folder}/config_${manufacturer}.txt
logfile=${rs_proc_dir}/logs/${id}.log    
echo "Start at: `date` " > ${logfile} 2>&1
matlab -nodisplay -nosplash -r "addpath('${root_dir}/utilities'); CBIG_ABCD_rest_proc_compute_motion_outlier('${id}','${rs_proc_dir}','${raw_path}','${manufacturer}','${FD_th}','${DV_th}','${discard_run}','${discard_seg}','${motion_filter}'); exit;" >> ${logfile} 2>&1

${root_dir}/utilities/CBIG_ABCD_rest_fMRI_preprocess.csh -s ${id} -output_d ${rs_proc_dir} -anat_s ${id} -anat_d ${recon_dir} -fmrinii ${raw_path} -config ${config_file} >> ${logfile} 2>&1

matlab -nodisplay -nosplash -r "addpath('${root_dir}/utilities'); CBIG_ABCD_proc_rs_qc('${id}','${rs_proc_dir}',${bbr_thr},${max_FC},${min_length},'${FD_th}','${DV_th}'); exit;" >> ${logfile} 2>&1

${root_dir}/utilities/CBIG_ABCD_rest_compute_FC.csh ${id} ${rs_proc_dir} ${FD_th} ${DV_th} >> ${logfile} 2>&1

rm -f ${rs_proc_dir}/${id}/bold/00*/${id}_bld00*_rest.nii.gz >> ${logfile} 2>&1
rm -f ${rs_proc_dir}/${id}/bold/00*/${id}_bld00*_rest_mc.nii.gz >> ${logfile} 2>&1  

echo "Finish at: `date`" >> ${logfile} 2>&1
chmod -R 755 ${rs_proc_dir}/${id}
