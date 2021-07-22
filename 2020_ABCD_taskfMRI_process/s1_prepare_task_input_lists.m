function s1_prepare_task_input_lists(id_list,task_data_dir,ABCD_table_dir,task_proc_dir)
%
% s1_prepare_task_input_lists(id_list,task_data_dir,ABCD_table_dir,task_proc_dir)
%
% This function prepares input lists required for the rest fMRI preprocess pipeline
%
% Inputs:
%   - id_list
%     A string. Path of a text file containing the subject IDs you want to check the download
%
%   - task_data_dir:
%     A string. The directory where the task images of all subjects are saved.
%
%   - ABCD_table_dir:
%     A string. The directory where the ABCD tabular files are saved.
%
%   - task_proc_dir:
%     A string. The directory where the processing outputs will be
%
% Outputs:
%   For each subject, a txt file storing the paths of the subjects'
%   rest images will be created under task_proc_dir. A txt file storing its
%   scanner will aslo be created.
%
% Written by Jianzhong Chen and CBIG under MIT license: https://github.com/ThomasYeoLab/CBIG/blob/master/LICENSE.md

if ~exist(fullfile(task_proc_dir,'lists','manufacturer'),'dir')
    system(['mkdir -p ' fullfile(task_proc_dir,'lists','manufacturer')]);
end

if ~exist(fullfile(task_proc_dir,'lists','raw_path'),'dir')
    system(['mkdir -p ' fullfile(task_proc_dir,'lists','raw_path')]);
end

id_all = CBIG_text2cell(id_list);
id_all = strrep(id_all,'NDAR_','NDAR');

%% write the list of raw image paths
for i = 1:length(id_all)
    id = id_all{i};
    files = dir([task_data_dir '/sub-' id '/ses-baselineYear1Arm1/func/*brain_masked.nii.gz']);
    fid = fopen(fullfile(task_proc_dir,'lists','raw_path',[id '.txt']),'wt');
    n_mid = 100;
    n_nback = 200;
    n_sst = 300;
    for j = 1:length(files)
        file = files(j);
        file = file.name;
        if contains(file,'mid')
            n_mid = n_mid+1;
            fprintf(fid,'%03d %s\n',n_mid,[task_data_dir '/sub-' id '/ses-baselineYear1Arm1/func/' file]);
        elseif contains(file,'nba')
            n_nback = n_nback+1;
            fprintf(fid,'%03d %s\n',n_nback,[task_data_dir '/sub-' id '/ses-baselineYear1Arm1/func/' file]);
        elseif contains(file,'sst')
            n_sst = n_sst+1;
            fprintf(fid,'%03d %s\n',n_sst,[task_data_dir '/sub-' id '/ses-baselineYear1Arm1/func/' file]);
        elseif contains(file,'rest')
            ;
        else
            error([id ': task not recognized']);
        end
    end
    fclose(fid);
end

%% write the list containing scanner of image files
% images of diferent scanners will have different number of frames skipped
mri_file = fullfile(ABCD_table_dir,'abcd_mri01.txt');
mri_table = readtable(mri_file,'Delimiter','\t');

subjectkey = table2cell(mri_table(:,'subjectkey'));
scanner_all = table2cell(mri_table(:,'mri_info_softwareversion'));
id_all = strrep(id_all,'NDAR','NDAR_');
for i = 1:length(id_all)
    id = id_all{i};
    index = strcmp(subjectkey,id);
    scanner_curr_sub = scanner_all(index);
    scanner = unique(scanner_curr_sub);
    if length(scanner) > 1
        error(['scaner of ' id ' not unique']);
    end
    
    scanner = scanner{1};
    if strcmp(scanner,'syngo MR E11')
        manufacturer = 'Siemens';
    elseif strcmp(scanner,'5.3.0\5.3.0.0')||strcmp(scanner,'5.3.0\5.3.0.3')||strcmp(scanner,'5.3.1\5.3.1.0')||...
            strcmp(scanner,'5.3.1\5.3.1.1')||strcmp(scanner,'5.4.0\5.4.0.1')
        manufacturer = 'Philips';
    elseif strcmp(scanner,'25\LX\MR Software release:DV25.0_R02_1549.b')||...
            strcmp(scanner,'27\LX\MR Software release:DV25.1_R01_1617.b')
        manufacturer = 'GEDV25';
    elseif strcmp(scanner,'27\LX\MR Software release:DV26.0_EB_1707.b')||...
            strcmp(scanner,'27\LX\MR Software release:DV26.0_R01_1725.a')||...
            strcmp(scanner,'27\LX\MR Software release:DV26.0_R02_1810.b')
        manufacturer = 'GEDV26';
    else
        error(['scanner of ' id ' not recognized']);
    end
    
    id = strrep(id,'NDAR_','NDAR');
    fid = fopen(fullfile(task_proc_dir,'lists','manufacturer',[id '.txt']),'wt');
    fprintf(fid,'%s',manufacturer);
    fclose(fid);
end

end
