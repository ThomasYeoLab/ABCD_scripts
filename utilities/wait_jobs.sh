#!/bin/bash

# Written by Jianzhong Chen and CBIG under MIT license: https://github.com/ThomasYeoLab/CBIG/blob/master/LICENSE.md

n_limit=$1
job_tag=$2
curr_user=`whoami`
njobs=$( ssh headnode "qstat | grep ${curr_user} | grep ${job_tag} | wc -l" )
while [ $njobs -gt ${n_limit} ]
do
njobs=$( ssh headnode "qstat | grep ${curr_user} | grep ${job_tag} | wc -l" )
sleep 1m
done
