function motion_skip = CBIG_ABCD_proc_load_motion(tsvfile,skipframes)

% motion_skip = CBIG_ABCD_proc_load_motion(tsvfile,skipframes)
%
% This function load the ABCD motion tsv file into a matrix and discard the first a few frames
%
% Inputs:
%   - tsv_file:
%     Path of the ABCD motion file
%   - skipframes
%     number of frames to skip
%
% Outputs:
%   - motion_skip
%     A #frame_after_skip*6 matrix. The first 3 are translations and the last 3 are rotations in degree
%
% Written by Jianzhong Chen and CBIG under MIT license: https://github.com/ThomasYeoLab/CBIG/blob/master/LICENSE.md

tsv = tdfread(tsvfile);
motion = [tsv.trans_x,tsv.trans_y,tsv.trans_z, tsv.rot_x,tsv.rot_y,tsv.rot_z];
motion_skip = motion(skipframes:end,:);
