function skip_number = CBIG_ABCD_proc_get_skip_frame(manufacturer)
%
% skip_number = CBIG_ABCD_proc_get_skip_frame(manufacturer)
% 
% This function returns the number of frames to discard given the scanner manufacturer
% The number of frames to discard follows the suggestion on ABCD release notes
%
% Inputs:
%   - manufacturer:
%     The manufacturer of scanner, choose from: 'Siemens', 'Philips', 'GEDV25', 'GEDV25'
% 
% Outputs:
%   - skip_number
%     The first N frames will be discarded when process the image as scanner is not stablized for the first a few frames
%
% Written by Jianzhong Chen and CBIG under MIT license: https://github.com/ThomasYeoLab/CBIG/blob/master/LICENSE.md

if strcmp(manufacturer,'Siemens')
    skip_number = 8;
elseif strcmp(manufacturer,'Philips')
    skip_number = 8;
elseif strcmp(manufacturer,'GEDV25')
    skip_number = 5;
elseif strcmp(manufacturer,'GEDV26')
    skip_number = 16;
else
    disp(manufacturer);
    error('manufacturer not recognized');
end
