function [activation_data, averaged_data] = preprocess_data(basepath)
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
    
    resmat = helpers.preprocessing.reconstruct_painting(data);
    
    % Calc average per emotion
    reize(:,:,1) = (resmat(:,:,10) + resmat(:,:,18) + resmat(:,:,20) + ...
                    resmat(:,:,22)) / 4; % neutral
    reize(:,:,2) = (resmat(:,:,2) + resmat(:,:,6) + resmat(:,:,21) + ...
                    resmat(:,:,23)) / 4; %anger
    reize(:,:,3) = (resmat(:,:,3) + resmat(:,:,5) + resmat(:,:,12) + ...
                    resmat(:,:,24)) / 4; %disgust
    reize(:,:,4) = (resmat(:,:,4) + resmat(:,:,7) + resmat(:,:,13) + ...
                    resmat(:,:,17)) / 4; % happy
    reize(:,:,5) = (resmat(:,:,8) + resmat(:,:,15) + resmat(:,:,19) + ...
                    resmat(:,:,25)) / 4; %sadness
    reize(:,:,6) = (resmat(:,:,9) + resmat(:,:,11) + resmat(:,:,14) + ...
                    resmat(:,:,16)) / 4; %fear
    reize(:,:,7) =  resmat(:,:,1); %ground state

    activation_data(:,:,:,s) = resmat;
    averaged_data(:,:,:,s) = reize;
       
end

end

