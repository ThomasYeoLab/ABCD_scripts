#!/bin/bash

# Written by Jianzhong Chen and CBIG under MIT license: https://github.com/ThomasYeoLab/CBIG/blob/master/LICENSE.md
id_list=$1
pipeline=$2
if [ -z "${id_list}" ];then
    id_list=$CBIG_REPDATA_DIR/stable_projects/predict_phenotypes/ChenTam2020_TRBPC/lists/release2_subjects_with_rs_and_t1_pass_recon_all.txt
fi
if [ -z "${pipeline}" ];then
    pipeline=rs_GSR_FD0.3_DVARS50
fi

# job limit = 200 so we run 200 rs processing jobs in parallel
# modify this to run more/less subjects in parallel
job_limit=200
root_dir="$(dirname "$(dirname "$(readlink -fm "$0")")")"
config_dir=${root_dir}/2020_ABCD_rsfMRI_process/config_${pipeline}
path_file=${config_dir}/CBIG_ABCD_paths_all.sh
source ${path_file}

LF=${rs_proc_dir}/logs/rs_proc.log
mkdir -p ${rs_proc_dir}/logs
mkdir -p ${rs_proc_dir}/job_err_out
date >> $LF
echo "====SOFTWARE VERSION====" >> $LF
env | grep FREESURFER_HOME >> $LF
env | grep FSL_DIR >> $LF

cd  $root_dir/2020_ABCD_rsfMRI_process/
matlab -nodisplay -nosplash -r "addpath('${root_dir}/utilities'); s1_prepare_rest_input_lists('${id_list}','${rs_data_dir}','${ABCD_table_dir}','${rs_proc_dir}'); exit;" >> $LF 2>&1
for id in `cat $id_list`
do
	errfile=${rs_proc_dir}/job_err_out/${id}.err
	outfile=${rs_proc_dir}/job_err_out/${id}.out
	cmd="${root_dir}/2020_ABCD_rsfMRI_process/s2_run_preproc_GSR.sh ${id} ${path_file} ${config_dir}"
	${CBIG_CODE_DIR}/setup/CBIG_pbsubmit -walltime 6:00:0 -mem 16gb -joberr ${errfile} -jobout ${outfile} -cmd "${cmd}" -name rsPreproc
	ssh headnode "${root_dir}/utilities/wait_jobs.sh ${job_limit} rsPreproc"
done
