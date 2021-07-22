function id_download_fail = ABCD_check_download(id_list,image_table,mod,data_dir)

% id_download_fail = ABCD_check_download(id_list,image_table,mod,data_dir)
%
% This function checks if all the images of a subject on the image table 
% have been downloaded to the data directory
%
% Inputs:
%   - id_list
%     A string. Path of a text file containing the subject IDs you want to check the download
%
%   - image_table
%     A string. Path of the image table `fmriresults01.txt`
%
%   - mod
%     A string. Image modality you downloaded and want to check
%     Choose from: 't1','t2','dwi','rs','mid','nback','sst'
%
%   - data_dir
%     A string. The directory you  downloaded the images to
%
% Outputs:
%   - id_download_fail
%     A cell table. The subject IDs that the # images on the image table and the # images 
%     downloaded on the data dir don't match
%
% Written by Jianzhong Chen and CBIG under MIT license: https://github.com/ThomasYeoLab/CBIG/blob/master/LICENSE.md

%% define the keywords of each imaging modality in iamge table `fmriresults01.txt`
keywords.t1 = 'MPROC-T1';
keywords.t2 = 'MPROC-T2';
keywords.dwi = 'MPROC-DTI';
keywords.rs = 'rsfMRI';
keywords.mid = 'MID-fMRI';
keywords.nback = 'nBack-fMRI';
keywords.sst = 'SST-fMRI';

%% read image table
[id_all,N_sub] = CBIG_text2cell(id_list);
image_all = CBIG_parse_delimited_txtfile(image_table,{'subjectkey','derived_files'},{},{},{},'"');

%% check image download
id_download_fail = [];
for i = 1:N_sub
    id = id_all{i};
    ind = strcmp(id,image_all(:,1));
    images = image_all(ind,2);
    % remove duplicate entry in the table
    image_name = cellfun(@(s) s(40:end),images,'UniformOutput',false);
    image_name = unique(image_name);
    
    n_image_in_table = sum(contains(image_name,keywords.(mod)));
    id = strrep(id,'NDAR_','NDAR');
    switch mod
        case 't1'
            cmd = ['find ' data_dir '/sub-' id ' -name *T1w.nii | wc -l'];
        case 't2'
            cmd = ['find ' data_dir '/sub-' id ' -name *T2w.nii | wc -l'];
        case 'dwi'
            cmd = ['find ' data_dir '/sub-' id ' -name *dwi.nii | wc -l'];
        case 'rs'
            cmd = ['find ' data_dir '/sub-' id ' -name *rest*.nii | wc -l'];
        case 'mid'
            cmd = ['find ' data_dir '/sub-' id ' -name *mid*.nii | wc -l'];
        case 'nback'
            cmd = ['find ' data_dir '/sub-' id ' -name *nback*.nii | wc -l'];
        case 'sst'
            cmd = ['find ' data_dir '/sub-' id ' -name *sst*.nii | wc -l'];
        otherwise
            error('mod not supported');
    end
    
    [~,n_im] = system(cmd);
    n_downloaded = str2num(n_im);
    if ~isequal(n_downloaded, n_image_in_table)
        id_download_fail{end+1} = id;
    end
end

id_download_fail = strrep(id_download_fail,'NDAR','NDAR_');
