function CBIG_ABCD_task_proc_compute_motion_outlier(id,output_dir,raw_path,manufacturer,FD_th,DV_th,discard_run,discard_seg,motion_filter)

% CBIG_ABCD_task_proc_compute_motion_outlier(id,output_dir,raw_path,manufacturer,FD_th,DV_th,discard_run,discard_seg)
%
% Inputs:
%   - id:
%     subject id
%
%   - output_dir:
%     processing output directory
%   
%   - raw_path:
%     The file containing paths of raw imaging files
%
%   - manufacturer:
%     A string indicate the scanner manufacturer of the images. Choose from: 'Simens','Phillips','GE'
%
%   - FD_th: 
%     the threshold of FDRMS, default is 0.2
%
% 	- DV_th: 
%     the threshold of DVARS, default is 50
%
%   - discard_run:
%     discard run which has more than <discard_run>% frames being outliers. default is 50
%
%   - discard_seg:
%     uncensored segments of data lasting fewer than discard_seg
%     contiguous frames will be removed, default is 5. 
%
%   - motion_filter
%     flag to do respiratory motion filtering or not. 1 for filter and other for not filter.
%
%   Outputs:
%   
%   txt file: SUBJECT_bldXXX_FDRMSxxx_DVARSxxx_motion_outliers.txt, this file contains a Tx1
% 			  vector where 1 means kept, 0 means removed.
%   BOLD file: output_dir/SUBJECT/logs/SUBJECT.bold
%
% Written by Jianzhong Chen and CBIG under MIT license: https://github.com/ThomasYeoLab/CBIG/blob/master/LICENSE.md

addpath([getenv('CBIG_CODE_DIR') '/stable_projects/preprocessing/CBIG_fMRI_Preproc2016/utilities'])

discard_run = str2num(discard_run);
mkdirp([output_dir '/' id '/bold/mc/']);
mkdirp([output_dir '/' id '/qc/']);
mkdirp([output_dir '/' id '/logs/']);
fid = fopen(raw_path);
path = textscan(fid,'%s','Delimiter',' ');
fclose(fid);
path = path{1};

N_run = length(path)/2;
run_number = path(1:2:2*N_run-1);
image_path = path(2:2:2*N_run);
motion_path = strrep(image_path,'bold_brain_masked.nii.gz','motion.tsv');

skip_frame = CBIG_ABCD_proc_get_skip_frame(manufacturer);
fid = fopen(fullfile(output_dir,id,'logs','skip_number.txt'),'wt');
fprintf(fid,num2str(skip_frame));
fclose(fid);

run_left = '';
for i = 1:N_run

    % load motion
    motion_file = motion_path{i};
    run = run_number{i};
    mkdirp([output_dir '/' id '/bold/' run]);
    FD_file = [output_dir '/' id '/bold/mc/' id '_bld' run '_task_mc_motion_outliers_FDRMS'];
    motion_skip = CBIG_ABCD_proc_load_motion(motion_file,skip_frame);
    % motion filtering
    if motion_filter == 1 || motion_filter == '1'
        motion_skip = CBIG_preproc_motion_filtering(motion_skip,'0.8','0.31','0.43');
    end
    motion_par_file = [output_dir '/' id '/bold/' run '/' id '_task_mc.par'];
    dlmwrite(motion_par_file,motion_skip);
    % compute FD
    motion_skip(:,4:6) = 2*pi*motion_skip(:,4:6)/360;
    motion_skip = motion_skip(:,[4:6,1:3]);
    FD_curr_run = CBIG_ABCD_proc_compute_FD_jenk(motion_skip);
    dlmwrite(FD_file,FD_curr_run,'\n');
    
    
    % compute DVARS
    bold_image = image_path{i};
    DVARS_file = [output_dir '/' id '/bold/mc/' id '_bld' run '_task_mc_motion_outliers_DVARS'];
    if ~exist(DVARS_file,'file')
        DVARS_confound = [output_dir '/' id '/bold/mc/' id '_bld' run '_task_mc_motion_outliers_confound_DVARS'];
        tmp_dir = [output_dir '/' id '/bold/mc/tmp_outliers/' run];
        mkdirp(tmp_dir);
        cmd = ['fsl_motion_outliers -i ' bold_image ' -o ' DVARS_confound ' -s ' DVARS_file ' -p ' DVARS_file ' -t ' tmp_dir ' --dvars --nomoco'];
        system(cmd);
        DVARS = dlmread(DVARS_file);
        DVARS = DVARS(skip_frame+1:end);
        dlmwrite(DVARS_file,DVARS,'\n');
    end
    
    % compute outlier
    out_name = [output_dir '/' id '/qc/' id '_bld' run];
    CBIG_preproc_DVARS_FDRMS_Correlation(DVARS_file,FD_file,out_name);
    CBIG_preproc_motion_outliers(DVARS_file,FD_file,FD_th,DV_th,discard_seg,out_name);
    
    % discard runs below threshold
    outlier_file = [out_name '_FDRMS' FD_th '_DVARS' DV_th '_motion_outliers.txt'];
    outlier = load(outlier_file);
    if sum(outlier)/length(outlier) >= 1-discard_run/100
        mc_image = [output_dir '/' id '/bold/' run '/' id '_bld' run '_task_mc.nii.gz'];
        cmd = ['ln -s ' bold_image ' ' mc_image];
        system(cmd);
        run_left = [run_left run ' '];
    end
end

% update bold file
fid = fopen([output_dir '/' id '/logs/' id '.bold'],'wt');
fprintf(fid,'%s',run_left);
fclose(fid);

rmpath([getenv('CBIG_CODE_DIR') '/stable_projects/preprocessing/CBIG_fMRI_Preproc2016/utilities'])

end
