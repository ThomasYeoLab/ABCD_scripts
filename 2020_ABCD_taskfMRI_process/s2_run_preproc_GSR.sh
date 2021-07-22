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
raw_path=${task_proc_dir}/lists/raw_path/${id}.txt
manufacturer=`cat ${task_proc_dir}/lists/manufacturer/${id}.txt`
config_file=${config_folder}/config_${manufacturer}.txt
logfile=${task_proc_dir}/logs/${id}.log    

echo "Start at: `date` " > ${logfile} 2>&1

matlab -nodisplay -nosplash -r "addpath('${root_dir}/utilities'); CBIG_ABCD_task_proc_compute_motion_outlier('${id}','${task_proc_dir}','${raw_path}','${manufacturer}','${FD_th}','${DV_th}','${discard_run}','${discard_seg}','${motion_filter}'); exit;" >> ${logfile} 2>&1

${root_dir}/utilities/CBIG_ABCD_task_fMRI_preprocess.csh -s ${id} -output_d ${task_proc_dir} -anat_s ${id} -anat_d ${recon_dir} -fmrinii ${raw_path} -config ${config_file} >> ${logfile} 2>&1

matlab -nodisplay -nosplash -r "addpath('${root_dir}/utilities'); CBIG_ABCD_proc_task_qc('${id}','${task_proc_dir}',${bbr_thr},${max_FC},${min_length},'${FD_th}','${DV_th}'); exit;" >> ${logfile} 2>&1

${root_dir}/utilities/CBIG_ABCD_task_compute_FC.sh ${id} ${task_proc_dir} ${FD_th} ${DV_th} >> ${logfile} 2>&1

rm -f ${task_proc_dir}/${id}/bold/???/${id}_bld???_task.nii.gz >> ${logfile} 2>&1
rm -f ${task_proc_dir}/${id}/bold/???/${id}_bld???_task_mc.nii.gz >> ${logfile} 2>&1

echo "Finish at: `date`" >> ${logfile} 2>&1
chmod -R 755 ${task_proc_dir}/${id}
