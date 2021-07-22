function CBIG_ABCD_proc_rs_qc(id,proc_dir,bbr_thr,maxFD_thr,length_thr,FD_th,DV_th)
%
% CBIG_ABCD_proc_rs_qc(id,proc_dir,bbr_thr,maxFD_thr,length_thr,FD_th,DV_th)
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
%     After removing runs that did not pass QC, length of remaining runs will be combined. Entire subject
%     will be removed if the combined length of all runs < min_length
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
N_runs = length(bolds);
bbr = zeros(N_runs,1);
FD = cell(N_runs,1);
maxFD = zeros(N_runs,1);
length_runs = zeros(N_runs,1);

%% load QC related stats
for i = 1:N_runs
    curr_run = sprintf('%03d',bolds(i));
    bbr_numbers = load([proc_dir '/' id '/bold/' curr_run '/' id '_bld' curr_run '_rest_mc_skip_reg.dat.mincost']);
    bbr(i) = bbr_numbers(1);
    FD{i} = load([proc_dir '/' id '/bold/mc/' id '_bld' curr_run '_rest_mc_motion_outliers_FDRMS']);
    maxFD(i) = max(FD{i});
    outlier = load([proc_dir '/' id '/qc/' id '_bld' curr_run '_FDRMS' FD_th '_DVARS' DV_th '_motion_outliers.txt']);
    length_runs(i) = sum(outlier)*0.8;
end

%% thresholding
pass_qc_flag = and(bbr<bbr_thr,maxFD<maxFD_thr);
length_sum = sum(length_runs(pass_qc_flag));

if length_sum < length_thr
    pass_qc_flag = false(size(pass_qc_flag));
end

%% update bold file
bold_file = [proc_dir '/' id '/logs/' id '.bold'];
if sum(pass_qc_flag) ~= N_runs
    run_left = '';
    for i = 1:N_runs
        curr_run = sprintf('%03d',bolds(i));
        if pass_qc_flag(i)
            run_left = [run_left curr_run ' '];
        end
    end
    fid = fopen([proc_dir '/' id '/logs/' id '_pass_qc.bold'],'wt');
    fprintf(fid,'%s',run_left);
    fclose(fid);
else
    copyfile(bold_file,[proc_dir '/' id '/logs/' id '_pass_qc.bold']);
end

fid = fopen([proc_dir '/' id '/logs/' id '.qcscore'],'wt');
fprintf(fid,'%s',num2str(sum(pass_qc_flag)>0));
fclose(fid);

end
