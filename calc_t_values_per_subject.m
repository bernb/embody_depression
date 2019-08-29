function calc_t_values_per_subject(basepath)

if nargin < 1
    basepath = './output/stimuli_files/';
end

% Prepare needed variables
mask=imread('images/mask.png');
in_mask=find(mask>128); % list of pixels inside the mask
mask_pixel_count = length(in_mask);

all_stimuli = dir([basepath '*reize.mat']); % preprocessed files, obtained by running embody_demo.m

subject_count = length(all_stimuli);
emotion_count = 7; % neutral, anger, digust, happy, sadness, fear, ground

all_stimuli_data = zeros(mask_pixel_count, subject_count, emotion_count);
t_data = zeros(mask_pixel_count, emotion_count);

% Calculate t stats per subject and per emotion
for subject = 1:subject_count
    load([basepath all_stimuli(subject).name], 'reize');
    % reshape 3D matrix intro 2D matrix ( pixels X conditions )
    temp = reshape(reize,[],emotion_count);
    all_stimuli_data(:, subject, :) = temp(in_mask, :);
    for emotion = 1:emotion_count
        [h, ~, ~, stats] = ttest(all_stimuli_data(:,subject,emotion)');
        t_data(:, emotion) = stats.tstat;
        all_t_data = t_data(:);
        all_t_data(~isfinite(all_t_data)) = [];   % getting rid of 
        % anomalies in case of low number of subjects (ie no variance)
        
        % Apply FDR
        df=subject_count - 1;    % degrees of freedom
        P        = 1-cdf('T',all_t_data,df);  % p values
        [pID, pN] = FDR(P,0.05);             % BH FDR
        tID      = icdf('T',1-pID,df);      % T threshold, indep or pos. correl.
        tN       = icdf('T',1-pN,df) ;      % T threshold, no correl. assumptions
    end
end

end