function calc_embody_t_values(data, basepath)

if nargin < 2
    basepath = './output/stimuli_files/';
end

% Prepare needed variables
mask=imread('images/mask.png');
in_mask=find(mask>128); % list of pixels inside the mask
mask_pixel_count = length(in_mask);

subject_count = size(data,4);

% Obtain informations independent of variable names in mat-file
first_subject_struct = load(data(1).name);
data_count = size(first_subject_struct.(data_name), 3);

all_stimuli_data = zeros(mask_pixel_count, subject_count, data_count);

t_data = zeros(mask_pixel_count, data_count);

% load preprocessed data 'reize' and 'resmat' into *_data variables
for subject = 1:subject_count
   load([basepath data(subject).name], data_varname);
   
   % reshape 3D matrix intro 2D matrix ( pixels X conditions )
   temp = reshape(reize,[],emotion_count);
   %temp_single = reshape(resmat,[], stimuli_count);
   
   all_stimuli_data(:, subject, :) = temp(in_mask, :);
   %single_stimuli_data(:, subject, :) = temp_single(in_mask, :);
end

for emotion = 1:emotion_count
    [~, ~, ~, stats] = ttest(all_stimuli_data(:,:,emotion)');
    t_data(:, emotion) = stats.tstat;
end

% Reshaping for FDR
alltdata = t_data(:);

% Apply FDR
t_threshold = helpers.multiple_comparison_correction(alltdata, subject_count);

t_data(abs(t_data) < t_threshold) = 0;

% reshaping the tvalues into images
tvals_for_plot=zeros(size(mask,1),size(mask,2),emotion_count);
for condit=1:emotion_count
    temp=zeros(size(mask));
    temp(in_mask)=t_data(:,condit);
    temp(~isfinite(temp))=0; % we set nans and infs to 0 for display
    tvals_for_plot(:,:,condit)=temp;
    csvwrite(sprintf('output/t_values/tvals_exp_tine.%d.csv', condit),temp);
end

assignin('base', 'tvals_for_plot', tvals_for_plot);
tvals_for_plot_einzel = tvals_for_plot;

plot_t_maps(tvals_for_plot, tvals_for_plot_einzel, emotion_count, stimuli_count, mask);





