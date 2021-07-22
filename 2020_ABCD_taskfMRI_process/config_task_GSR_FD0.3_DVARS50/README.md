This folder contains the config files used for ABCD rest fMRI processing.
* `config_[scanner name].sh`: these files contains the processing steps of ABCD our ABCD rest fMRI pipeline. We have one config file for each scanner as we skip different number of frames for different scanner as suggested in ABCD release notes.
* `mc_par.sh`: this file contains the motion correction parameters such as FD/DVARS thresholds. Make sure those parameters are the same as in `config_[scanner name].sh`
* qc_thresholds.sh: this file contains the quality control thresholds.
  * bbr_thr: runs with bbr cost greater than <bbr_thr> will be removed
  * max_FC: runs with maximum FD > <maxFD_thr> will be removed
  * min_length: After removing runs that did not pass QC, length of remaining runs will be combined. Entire subject will be removed if the combined length of all runs < min_length
