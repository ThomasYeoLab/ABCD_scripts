# Overview
This folder contains the functions used to process the ABCD resting-state fMRI (rsfMRI) images. You can use them to replicate the ABCD paper or process your own subjects with minimal modification.

# Replicate ABCD 2020
To replicate ABCD paper, firstly make sure the paths file `CBIG_ABCD_paths_all.sh` in folder `config_rs_GSR_FD0.3_DVARS50` is correct and all data are downloaded. Then run
```
${script_dir}/2020_ABCD_rsfMRI_process/ABCD_rs_proc_wrapper.sh
```

# Process with a different list of subjects or different pipeline
1. make sure all the processing parameters in the pipeline config folder `config_[pipilne name]/` are what you want. See `config_rs_GSR_FD0.3_DVARS50` for example.
1. make sure the paths in the path file `CBIG_ABCD_paths_all.sh` under the pipeline config folder are what you want. See `config_rs_GSR_FD0.3_DVARS50/CBIG_ABCD_paths_all.sh` for example.

3. run the wrapper function with your own id list
```
${script_dir}/2020_ABCD_rsfMRI_process/ABCD_rs_proc_wrapper.sh [your_own_id_list] [pipeline name]
```

# Usage of individual functions
* `s1_prepare_input_list.m`: this function prepares input lists required for the rest fMRI preprocess pipeline.
* `s2_run_preproc_GSR.sh`: after you have prepared the input lists, you can use this script to run the global signal regression (GSR) pipeline for the ABCD minimally processed rest fMRI images.
