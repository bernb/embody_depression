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
end

for emotion = 1:emotion_count
    [~, ~, ~, t_stats] = ttest(all_stimuli_data(:,:,emotion)');
    t_data(:, emotion) = t_stats.tstat;
end

all_t_data = t_data(:);
% getting rid of anomalies due to low number of demo subjects (ie no variance)
all_t_data(~isfinite(all_t_data)) = [];


df=subject_count - 1;    % degreeso of freedom
P        = 1-cdf('T',all_t_data,df);  % p values
[pID pN] = FDR(P,0.05);             % BH FDR
tID      = icdf('T',1-pID,df);      % T threshold, indep or pos. correl.
tN       = icdf('T',1-pN,df) ;      % T threshold, no correl. assumptions

tvals_for_plot = zeros(size(mask,1), size(mask,2), emotion_count);
for condit=1:emotion_count
    temp=zeros(size(mask));
    temp(in_mask)=t_data(:,condit);
    temp(~isfinite(temp))=0; % we set nans and infs to 0 for display
    max(temp(:))
    tvals_for_plot(:,:,condit)=temp;
end

tvals_for_plot(abs(tvals_for_plot) < tID) = 0;

for i=1:7
    figure;
    plot_data(tvals_for_plot(:,:,i));
end


end