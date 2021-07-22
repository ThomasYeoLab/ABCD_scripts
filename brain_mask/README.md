# Overview
This folder contains the functions used to compute the brain mask of fMRI images. The brain masks will then be used to mask the fMRI images.

The masked fMRI images take much less space than the unmasked ones. Critically, pre-masking the fMRI data will not affect the computation of FC (functional connectivity) matrix (correlation > 0.99 for FC from masked/unmasked fMRI).

# Usage
1. make sure the paths in `../config/CBIG_ABCD_paths_t1_fMRI.sh` are what you want
2. run the wrapper function with the id list. Here, task can be one of the 4 fMRI tasks in ABCD: rs, mid, nabck, sst
```
${script_dir}/brain_mask/CBIG_ABCD_proc_brain_mask_wrappe.sh [id_list] [task]
```
