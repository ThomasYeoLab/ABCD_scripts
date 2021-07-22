#!/bin/bash

# Written by Jianzhong Chen and CBIG under MIT license: https://github.com/ThomasYeoLab/CBIG/blob/master/LICENSE.md
id_list=$1
pipeline=$2
if [ -z "${id_list}" ];then
    id_list=$CBIG_REPDATA_DIR/stable_projects/predict_phenotypes/ChenTam2020_TRBPC/lists/release2_subjects_pass_rs.txt
fi
if [ -z "${pipeline}" ];then
    pipeline=task_GSR_FD0.3_DVARS50
fi

# job limit = 200 so we run 200 task processing jobs in parallel
# modify this to run more/less subjects in parallel
job_limit=200
root_dir="$(dirname "$(dirname "$(readlink -fm "$0")")")"
config_dir=${root_dir}/2020_ABCD_taskfMRI_process/config_${pipeline}
path_file=${config_dir}/CBIG_ABCD_paths_all.sh
source ${path_file}

LF=${task_proc_dir}/logs/task_proc.log
mkdir -p ${task_proc_dir}/logs
mkdir -p ${task_proc_dir}/job_err_out
date >> $LF
echo "====SOFTWARE VERSION====" >> $LF
env | grep FREESURFER_HOME >> $LF
env | grep FSL_DIR >> $LF

cd  $root_dir/2020_ABCD_taskfMRI_process/

matlab -nodisplay -nosplash -r "addpath('${root_dir}/utilities'); s1_prepare_task_input_lists('${id_list}','${task_data_dir}','${ABCD_table_dir}','${task_proc_dir}'); exit;" >> $LF 2>&1

for id in `cat $id_list`
do
	errfile=${task_proc_dir}/job_err_out/${id}.err
	outfile=${task_proc_dir}/job_err_out/${id}.out
	cmd="${root_dir}/2020_ABCD_taskfMRI_process/s2_run_preproc_GSR.sh ${id} ${path_file} ${config_dir}"
	${CBIG_CODE_DIR}/setup/CBIG_pbsubmit -walltime 6:00:0 -mem 16gb -joberr ${errfile} -jobout ${outfile} -cmd "${cmd}" -name taskProc
	ssh headnode "${root_dir}/utilities/wait_jobs.sh ${job_limit} taskProc"
done
