#!/bin/bash

########## FMRI PREPROCESSING
id_list=$1
task=$2
scripts_dir=`dirname "$(readlink -f "$0")"`
root_dir="$(dirname "$(dirname "$(readlink -fm "$0")")")"
mkdir -p ${scripts_dir}/logs
for id in `cat $id_list`
do
    id=${id/NDAR_/NDAR}
    cmd="$scripts_dir/CBIG_ABCD_proc_brain_mask.sh ${id} ${task} 50"
    errfile=$scripts_dir/logs/${id}.err
    outfile=$scripts_dir/logs/${id}.out
    ${CBIG_CODE_DIR}/setup/CBIG_pbsubmit -walltime 1:00:0 -mem 2gb -joberr ${errfile} -jobout ${outfile} -cmd "${cmd}" -name mask_raw
    ssh headnode "${root_dir}/utilities/wait_jobs.sh 200 mask_raw"
done
