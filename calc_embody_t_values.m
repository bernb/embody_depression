function calc_embody_t_values(basepath)

if nargin < 1
    basepath = './output/stimuli_files/';
end

mask=imread('images/mask.png');
in_mask=find(mask>128); % list of pixels inside the mask
mask_pixel_count = length(in_mask);

all_stimuli = dir([basepath '*reize.mat']); % preprocessed files, obtained by running embody_demo.m
single_stimuli = dir([basepath '*preprocessed.mat']);

subject_count = length(all_stimuli);
emotion_count = 7; % neutral, anger, digust, happy, sadness, fear, ground
stimuli_count = 25; % number of pictures / stimuli used

all_stimuli_data = zeros(mask_pixel_count, subject_count, emotion_count);
single_stimuli_data = zeros(mask_pixel_count, subject_count, stimuli_count);

t_data = zeros(mask_pixel_count, emotion_count);
t_data_single = zeros(mask_pixel_count, emotion_count);

% load preprocessed data 'reize' and 'resmat' into *_data variables
for subject = 1:subject_count
   load([basepath all_stimuli(subject).name], 'reize');
   load([basepath single_stimuli(subject).name], 'resmat');
   
   % reshape 3D matrix intro 2D matrix ( pixels X conditions )
   temp = reshape(reize,[],emotion_count);
   temp_single = reshape(resmat,[], stimuli_count);
   
   all_stimuli_data(:, subject, :) = temp(in_mask, :);
   single_stimuli_data(:, subject, :) = temp_single(in_mask, :);
end

for emotion = 1:emotion_count
    [~, ~, ~, stats] = ttest(all_stimuli_data(:,:,emotion)');
    t_data(:, emotion) = stats.tstat;
end

for stimuli = 1:stimuli_count
   [~, ~, ~, stats] = ttest(single_stimuli_data(:, :, stimuli)');
   t_data_single(:, stimuli) = stats.tstat;
end

% reshaping the tvalues into images
tvals_for_plot=zeros(size(mask,1),size(mask,2),emotion_count);
for condit=1:emotion_count
    temp=zeros(size(mask));
    temp(in_mask)=t_data(:,condit);
    temp(~isfinite(temp))=0; % we set nans and infs to 0 for display
    tvals_for_plot(:,:,condit)=temp;
    csvwrite(sprintf('output/t_values/tvals_exp_tine.%d.csv', condit),temp);
end

tvals_for_plot_einzel=zeros(size(mask,1),size(mask,2),stimuli_count);
for condit=1:stimuli_count
    temp=zeros(size(mask));
    temp(in_mask)=t_data_single(:,condit);
    temp(~isfinite(temp))=0; % we set nans and infs to 0 for display
    tvals_for_plot_einzel(:,:,condit)=temp;
    csvwrite(sprintf('output/t_values/tvals_exp_tine_alle_stimuli.%d.csv', condit),temp);
end

plot_t_maps(tvals_for_plot, tvals_for_plot_einzel, emotion_count, stimuli_count, mask);





