# Overview
Functions in this folder performs FreeSurfer reconstruction for all ABCD release3.0.1 subjects with both t1 and rest-fMRI images.

# Process you own list of subjects
1. make sure the paths in `../config/paths_2020_ABCD_t1_fMRI_ABCD3.sh` are what you want
2. run the wrapper function with your own id list
```
${script_dir}/2021_ABCD_T1_recon_all/ABCD_t1_recon_all_wrapper.sh [your_own_id_list]
```
