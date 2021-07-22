# Overview
Functions in this folder performs FreeSurfer reconstruction for all ABCD release2.0.1 subjects with both t1 and rest-fMRI images.

# Replicate ABCD 2020
To replicate ABCD paper, firstly make sure the paths file `../config/CBIG_ABCD_paths_t1_fMRI.sh` are correct and all data are downloaded. `cd` to this folder and run
```
${script_dir}/2020_ABCD_T1_recon_all/ABCD_t1_recon_all_wrapper.sh
```

# Process you own list of subjects
1. make sure the paths in `../config/paths_2020_ABCD_t1_fMRI.sh` are what you want
2. run the wrapper function with your own id list
```
${script_dir}/2020_ABCD_T1_recon_all/ABCD_t1_recon_all_wrapper.sh [your_own_id_list]
```
