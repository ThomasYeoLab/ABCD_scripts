# ABCD_scripts

This folder provides the scripts used to download and process ABCD minimally processed data

## USAGE
- `download/` folder

  This folder provides scripts and instructions to download the ABCD phenotypic and imaging data
  
- `brain_mask/` folder
  
  This folder provides scripts to mask the raw data using the brain mask so we can save the space

- `config/` folder

  * `CBIG_ABCD_proc_tested_config.sh` To replicate the ABCD processing pipeline, you need to follow $CBIG_CODE_DIR/setup/README.md to setup the config file. Instead of using CBIG/setup/CBIG_sample_config.sh, you need to use this file
  * `CBIG_ABCD_paths_t1_fMRI.sh` This file defines the paths that will be used in all the other scripts in this folder. Please change the paths if you want different input or output directories

- folders `2020_ABCD_T1_recon_all/`,`2020_ABCD_rsfMRI_process/`,`2020_ABCD_taskfMRI_process/`

  These 3 folders contain the scripts to retrieve the recon-all, rest-fMRI processing and task-fMRI processing results 

- `utilities` folder

  This folder contains the scripts that are commonly used by other scripts in this folder

## Replicate the ABCD release2.0 image processing
This is for CBIG lab only and the replication steps require sensitive data not allowed to be made public. Steps to replicate the processing are:
1. [optional] Change the paths in the config file `CBIG_ABCD_paths_t1_fMRI.sh`
2. Go to the `download` folder to retrieve the ABCD tabular and imaging data. Place the data according to the config file in step1.
3. Go to the `brain_mask` folder to generate the brain mask of raw fMRI images and mask the raw images
4. Upon successfully completing step3, go to `2020_ABCD_T1_recon_all` folder and retrieve the recon-all results
5. Upon successfully completing step4, go to `2020_ABCD_rsfMRI_process` folder to retrieve the rest fMRI processing results
6. Upon successfully completing step4, go to `2020_ABCD_taskfMRI_process` folder to retrieve the task fMRI processing results
