function [activation_data, avg_data, avg_data_left, avg_data_right] = ...
    preprocess_data(basepath)
% Preprocessing of raw emBODY data. If no path is given 'data/subjects' 
% will be used as basepath.
% Function expects mask image at images/mask.png. Note that amount of images per emotion 
% and ordering is hardcoded here.
%
% Input:
% Directory that contains one directory per subject with one csv
% file per image. csv files are created by the 'emBODY' program.
% 
% Output: 
% activation_data: (nxmxkxs)-Matrix
%   s: subject count
%   k: stimuli count
%   n,m: coordinates of clicked pixels
%
% averaged_data: (nxmxjxs)-Matrix
%   n,m,s: as above
%   j: emotion count
%
% Notes:
% * deactivation is subtracted from activation
% * A gauss-filter is applied to inflate the actual clicked points

if nargin < 1
    basepath = 'data/subjects';
end

% get a list of subjects
subjects = helpers.dir(basepath);

if isempty(subjects)
    warning('Could not find any subjects in given directory');
end

for s=1:length(subjects) % loop over the subjects

    % Data loading
    data=helpers.preprocessing.load_subj([basepath '/' subjects(s).name],2);
    
    [diffs, left_side, right_side] = helpers.preprocessing.reconstruct_painting(data);
    
    % Calc average per emotion
    diffs_averaged(:,:,1) = (diffs(:,:,10) + diffs(:,:,18) + diffs(:,:,20) + ...
                    diffs(:,:,22)) / 4; % neutral
    diffs_averaged(:,:,2) = (diffs(:,:,2) + diffs(:,:,6) + diffs(:,:,21) + ...
                    diffs(:,:,23)) / 4; %anger
    diffs_averaged(:,:,3) = (diffs(:,:,3) + diffs(:,:,5) + diffs(:,:,12) + ...
                    diffs(:,:,24)) / 4; %disgust
    diffs_averaged(:,:,4) = (diffs(:,:,4) + diffs(:,:,7) + diffs(:,:,13) + ...
                    diffs(:,:,17)) / 4; % happy
    diffs_averaged(:,:,5) = (diffs(:,:,8) + diffs(:,:,15) + diffs(:,:,19) + ...
                    diffs(:,:,25)) / 4; %sadness
    diffs_averaged(:,:,6) = (diffs(:,:,9) + diffs(:,:,11) + diffs(:,:,14) + ...
                    diffs(:,:,16)) / 4; %fear
    diffs_averaged(:,:,7) =  diffs(:,:,1); %ground state
    
    left_averaged(:,:,1) = (left_side(:,:,10) + left_side(:,:,18) + left_side(:,:,20) + ...
                    left_side(:,:,22)) / 4; % neutral
    left_averaged(:,:,2) = (left_side(:,:,2) + left_side(:,:,6) + left_side(:,:,21) + ...
                    left_side(:,:,23)) / 4; %anger
    left_averaged(:,:,3) = (left_side(:,:,3) + left_side(:,:,5) + left_side(:,:,12) + ...
                    left_side(:,:,24)) / 4; %disgust
    left_averaged(:,:,4) = (left_side(:,:,4) + left_side(:,:,7) + left_side(:,:,13) + ...
                    left_side(:,:,17)) / 4; % happy
    left_averaged(:,:,5) = (left_side(:,:,8) + left_side(:,:,15) + left_side(:,:,19) + ...
                    left_side(:,:,25)) / 4; %sadness
    left_averaged(:,:,6) = (left_side(:,:,9) + left_side(:,:,11) + left_side(:,:,14) + ...
                    left_side(:,:,16)) / 4; %fear
    left_averaged(:,:,7) =  left_side(:,:,1); %ground state
    
    right_averaged(:,:,1) = (right_side(:,:,10) + right_side(:,:,18) + right_side(:,:,20) + ...
                    right_side(:,:,22)) / 4; % neutral
    right_averaged(:,:,2) = (right_side(:,:,2) + right_side(:,:,6) + right_side(:,:,21) + ...
                    right_side(:,:,23)) / 4; %anger
    right_averaged(:,:,3) = (right_side(:,:,3) + right_side(:,:,5) + right_side(:,:,12) + ...
                    right_side(:,:,24)) / 4; %disgust
    right_averaged(:,:,4) = (right_side(:,:,4) + right_side(:,:,7) + right_side(:,:,13) + ...
                    right_side(:,:,17)) / 4; % happy
    right_averaged(:,:,5) = (right_side(:,:,8) + right_side(:,:,15) + right_side(:,:,19) + ...
                    right_side(:,:,25)) / 4; %sadness
    right_averaged(:,:,6) = (right_side(:,:,9) + right_side(:,:,11) + right_side(:,:,14) + ...
                    right_side(:,:,16)) / 4; %fear
    right_averaged(:,:,7) =  right_side(:,:,1); %ground state

    activation_data(:,:,:,s) = diffs;
    avg_data(:,:,:,s) = diffs_averaged;
    avg_data_left(:,:,:,s) = left_averaged;
    avg_data_right(:,:,:,s) = right_averaged;
       
end

end

