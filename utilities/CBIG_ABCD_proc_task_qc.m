function CBIG_ABCD_proc_task_qc(id,proc_dir,bbr_thr,maxFD_thr,length_thr,FD_th,DV_th)
%
% CBIG_ABCD_proc_task_qc(id,proc_dir,bbr_thr,maxFD_thr,length_thr,FD_th,DV_th)
%
% This function reads some qc measures and then remove runs that failed qc from the bold list
%
% Inputs:
%
%   - id:
%     subject id
%
%   - proc_dir:
%     processing output directory
%
%   - bbr_thr:
%     runs with bbr cost greater than <bbr_thr> will be removed
%
%   - maxFD_thr:
%     runs with maximum FD > <maxFD_thr> will be removed
%
%   - length_thr
%     After removing runs that did not pass QC, length of remaining runs for each task will be combined. Entire task
%     will be removed if the combined length of all runs < min_length for any task
%
%   - FD_th
%     threshold of FD (framewise displacement)
%
%   - DV_th
%     threshold of DVARS
%
%   Outputs:
%     subject bold file `proc_dir/SUBJECT/logs/SUBJECT.bold` will be updated
%     A file `proc_dir/SUBJECT/logs/SUBJECT.qcscore` will be added
%
% Written by Jianzhong Chen and CBIG under MIT license: https://github.com/ThomasYeoLab/CBIG/blob/master/LICENSE.md

bolds = load([proc_dir '/' id '/logs/' id '.bold']);
bolds = arrayfun(@num2str,bolds,'UniformOutput',false);
if ~isempty(bolds)
    N_runs = length(bolds);
    bbr = zeros(N_runs,1);
    FD = cell(N_runs,1);
    maxFD = zeros(N_runs,1);
    length_runs = zeros(N_runs,1);
    
    %% load QC related stats
    for i = 1:N_runs
        curr_run = bolds{i};
        bbr_numbers = load([proc_dir '/' id '/bold/' curr_run '/' id '_bld' curr_run '_task_mc_skip_reg.dat.mincost']);
        bbr(i) = bbr_numbers(1);
        FD{i} = load([proc_dir '/' id '/bold/mc/' id '_bld' curr_run '_task_mc_motion_outliers_FDRMS']);
        maxFD(i) = max(FD{i});
        outlier = load([proc_dir '/' id '/qc/' id '_bld' curr_run '_FDRMS' FD_th '_DVARS' DV_th '_motion_outliers.txt']);
        length_runs(i) = sum(outlier)*0.8;
    end
    
    %% thresholding maxFD and bbr
    pass_qc_flag = and(bbr<bbr_thr,maxFD<maxFD_thr);
    pass_runs = bolds(pass_qc_flag);
    length_pass_runs = length_runs(pass_qc_flag);
    
    %% threshold length and update task bold file
    tasks = {'mid','nback','sst'};
    N_task = length(tasks);
    task_run_numbers = {{'101','102'},{'201','202'},{'301','302'}};
    length_qc = zeros(N_task,1);
    for i = 1:length(tasks)
        length_curr_task = sum(length_pass_runs(contains(pass_runs,task_run_numbers{i})));
        length_qc(i) = length_curr_task>=length_thr;
        if length_curr_task >= length_thr
            pass_runs_curr_task = pass_runs(contains(pass_runs,task_run_numbers{i}));
        else
            pass_runs_curr_task = [];
        end
        update_bold_file(proc_dir,id,pass_runs_curr_task,['.' tasks{i} '.bold']);
    end
    %% update qc score
    fid = fopen([proc_dir '/' id '/logs/' id '.qcscore'],'wt');
    fprintf(fid,'%s',num2str(sum(length_qc)==3));
    fclose(fid);
end

end

function update_bold_file(proc_dir,id,bolds,savename)

bold_file = [proc_dir '/' id '/logs/' id savename];
run_left = '';
N_runs = length(bolds);
for i = 1:N_runs
    run_left = [run_left bolds{i} ' '];
end

fid = fopen(bold_file,'wt');
fprintf(fid,'%s',run_left);
fclose(fid);

end
