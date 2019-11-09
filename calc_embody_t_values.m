function [t_data, t_threshold] = calc_embody_t_values(data)
% Calculates t-values per pixel and applies FDR
%
% Input:
%   data: (nxmxjxs) Matrix
%       n, m: pixel coordinates
%       j: stimuli count
%       s: subject count
%
% Output:
%   t_data: (nxmxj) Matrix
%
% ToDo: Apply mask

% Prepare needed variables
mask=imread('images/mask.png');
in_mask=find(mask>128); % list of pixels inside the mask
mask_pixel_count = length(in_mask);
n = size(data, 1);
m = size(data, 2);
pixel_count = n*m;

subject_count = size(data, 4);
stimuli_count = size(data, 3);
t_data = zeros(n, m, stimuli_count);

for stimuli = 1:stimuli_count
    % First extract all data for a single stimuli
    % Then reshape into (subject_count, pixel_count) matrix
    stimuli_data = squeeze(data(:,:,stimuli,:));
    stimuli_data = reshape(stimuli_data, [], 30)';
    
    % ttest does one test per column, thus making
    % n*m ttests in total
    [~, ~, ~, STATS] = ttest(stimuli_data);
    result = squeeze(STATS.tstat)';
    t_data(:, :, stimuli) = reshape(result, n, m);
end

% Apply FDR
t_threshold = helpers.multiple_comparison_correction(t_data(isfinite(t_data)), subject_count);




