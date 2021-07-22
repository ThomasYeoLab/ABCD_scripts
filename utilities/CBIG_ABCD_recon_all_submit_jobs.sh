#!/bin/bash

# Written by Jianzhong Chen and CBIG under MIT license: https://github.com/ThomasYeoLab/CBIG/blob/master/LICENSE.md

id_list=`readlink -f $1`
timepoint=$2
job_limit=$3
path_file=$4
root_dir="$(dirname "$(dirname "$(readlink -fm "$0")")")"

if [ -z $path_file ];then
    path_file=$root_dir/config/CBIG_ABCD_paths_t1_fMRI_ABCD3.sh
fi
source $path_file

mkdir -p ${recon_dir}/job_err_out
mkdir -p ${recon_dir}/logs
LF="${recon_dir}/logs/recon_all.log"
date >> $LF

echo "====SOFTWARE VERSION====" >> $LF
env | grep FREESURFER_HOME >> $LF
env | grep FSL_DIR >> $LF
env | grep CBIG_SPM_DIR >> $LF

########## recon-all the T1 images
for id in `cat ${id_list}`
do
    id=${id/NDAR_/NDAR}
    echo ${id}
	if [ $timepoint == 1 ]; then
    	   img=${t1_data_dir}/sub-${id}/ses-baselineYear1Arm1/anat/sub-${id}_ses-baselineYear1Arm1_run-01_T1w.nii 
	elif [ $timepoint == 2 ]; then\
	   img=${t1_data_dir}/sub-${id}/ses-2YearFollowUpYArm1/anat/sub-${id}_ses-2YearFollowUpYArm1_run-01_T1w.nii 
	else
	   echo "ERROR: timepoint not recognised, exiting..."
	   exit
	fi

    # if number of jobs exceeds limits, sleep 3m
    $root_dir/utilities/wait_jobs.sh ${job_limit} recon_all

    cmd="cd ${script_dir}; \
    echo Start at: `date` >> ${recon_dir}/logs/${id}.log; \
    recon-all -s ${id} -i ${img} -all -sd ${recon_dir} >> ${recon_dir}/logs/${id}.log 2>&1; \
    echo Finish at: `date` >> ${recon_dir}/logs/${id}.log; \
    chmod -R 755 ${recon_dir}/${id}/ "
    ssh headnode "$CBIG_CODE_DIR/setup/CBIG_pbsubmit -cmd '$cmd' -walltime 20:00:00 \
	-name 'recon_all' -mem 4GB -joberr '${recon_dir}/job_err_out/${id}.err' -jobout '${recon_dir}/job_err_out/${id}.out'" < /dev/null

    sleep 1
done
