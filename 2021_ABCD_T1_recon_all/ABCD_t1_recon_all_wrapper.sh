#!/bin/bash

# Written by Jianzhong Chen and CBIG under MIT license: https://github.com/ThomasYeoLab/CBIG/blob/master/LICENSE.md
id_list=$1
if [ -z "${id_list}" ];then
    #id_list=$CBIG_REPDATA_DIR/stable_projects/predict_phenotypes/ChenTam2020_TRBPC/lists/release2_subjects_with_rs_and_t1.txt
    id_list=/home/leon_ooi/storage/ABCD/subject_list/ABCD_y2_1sub.txt
fi
# job limit = 100 so we run 100 recon-all in parallel
# modify this to run more/less subjects in parallel
job_limit=100

root_dir="$(dirname "$(dirname "$(readlink -fm "$0")")")"
$root_dir/utilities/CBIG_ABCD_recon_all_submit_jobs.sh $id_list 2 $job_limit
