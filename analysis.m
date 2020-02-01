% ToDo:
% raw_to_matrix ohne inflating der pixel:
% maske hat falsche ecken bei z.B. MDDm

% ToDo:
% Differenzen auf Fehler checken: nm - m
% Sieht aus wie inverse von m

mask = imread('images/mask.png');
mask_indices = find(mask>128);

cg_path = './data/subjects/CG';
m_path = './data/subjects/MDDm';
nm_path = './data/subjects/MDDnm';
emotion_labels = [...
    "Neutral"
    "Anger"
    "Disgust"
    "Happiness"
    "Sadness"
    "Fear"
    "Ground state"
    ];

stimuli = [...
    emotion_labels(2)
    emotion_labels(3)
    emotion_labels(4)
    emotion_labels(3)
    emotion_labels(2)
    emotion_labels(4)
    emotion_labels(5)
    emotion_labels(6)
    emotion_labels(1)
    emotion_labels(6)
    emotion_labels(3)
    emotion_labels(4)
    emotion_labels(6)
    emotion_labels(5)
    emotion_labels(6)
    emotion_labels(4)
    emotion_labels(1)
    emotion_labels(5)
    emotion_labels(1)
    emotion_labels(2)
    emotion_labels(1)
    emotion_labels(2)
    emotion_labels(3)
    emotion_labels(5)
    ];

non_anger_stimuli_indices = find(stimuli ~= 'Anger') + 1;
stimuli_no_anger = stimuli(non_anger_stimuli_indices - 1);

if ~exist('cg_data', 'var') || ...
   ~exist('cg_data_averaged', 'var') || ...
    exist('rebuild_data', 'var')
    [cg_data, cg_data_averaged, cg_avg_left, cg_avg_right] = preprocess_data(cg_path);
    [cg_t_data, cg_t_threshold] = calc_embody_t_values(cg_data_averaged);
end

if ~exist('m_data', 'var') || ...
   ~exist('m_data_averaged', 'var') || ...
    exist('rebuild_data', 'var')
    [m_data, m_data_averaged, m_avg_left, m_avg_right] = preprocess_data(m_path);
    [m_t_data, m_t_threshold] = calc_embody_t_values(m_data_averaged);
end

if ~exist('nm_data', 'var') || ...
   ~exist('nm_data_averaged', 'var') || ...
    exist('rebuild_data', 'var')
    [nm_data, nm_data_averaged, nm_avg_left, nm_avg_right] = preprocess_data(nm_path);
    [nm_t_data, nm_t_threshold] = calc_embody_t_values(nm_data_averaged);
end

cg_m_diff = cg_t_data - m_t_data;
cg_m_t_threshold = helpers.multiple_comparison_correction(cg_m_diff, 30);

cg_nm_diff = cg_t_data - nm_t_data;
cg_nm_t_threshold = helpers.multiple_comparison_correction(cg_nm_diff, 30);

nm_m_diff = nm_t_data - m_t_data;
nm_m_t_threshold = helpers.multiple_comparison_correction(nm_m_diff, 30);

m_nm_diff = m_t_data - nm_t_data;
m_nm_t_threshold = helpers.multiple_comparison_correction(m_nm_diff, 30);

if ~exist('cg_accuracies', 'var') || ...
   ~exist('cg_avg_confusion_table', 'var')
    disp('Calculate mean and SD accuracy for CG');
    trials = 100;
    % Remove ground state
    cg_cleaned = cg_data(:,:,2:end,:);
    [cg_accuracies, cg_avg_confusion_table] = helpers.calc_averaged_model_data(cg_cleaned, stimuli, trials);
    
    % Now also remove anger
    cg_cleaned_no_anger = cg_data(:,:,non_anger_stimuli_indices,:);
    [cg_accuracies_no_anger, cg_avg_confusion_table_no_anger] = helpers.calc_averaged_model_data(cg_cleaned_no_anger, stimuli_no_anger, trials);
end

if ~exist('nm_accuracies', 'var') || ...
   ~exist('nm_avg_confusion_table', 'var')
    disp('Calculate mean and SD accuracy for nm');
    nm_cleaned = nm_data(:,:,2:end,:);
    [nm_accuracies, nm_avg_confusion_table] = helpers.calc_averaged_model_data(nm_cleaned, stimuli, trials);
    
    % Now also remove anger
    nm_cleaned_no_anger = nm_data(:,:,non_anger_stimuli_indices,:);
    [nm_accuracies_no_anger, nm_avg_confusion_table_no_anger] = helpers.calc_averaged_model_data(nm_cleaned_no_anger, stimuli_no_anger, trials);
end

if ~exist('m_accuracies', 'var') || ...
   ~exist('m_avg_confusion_table', 'var')
    disp('Calculate mean and SD accuracy for m');
    m_cleaned = m_data(:,:,2:end,:);
    [m_accuracies, m_avg_confusion_table] = helpers.calc_averaged_model_data(m_cleaned, stimuli, trials);
    
    % Now also remove anger
    m_cleaned_no_anger = m_data(:,:,non_anger_stimuli_indices,:);
    [m_accuracies_no_anger, m_avg_confusion_table_no_anger] = helpers.calc_averaged_model_data(m_cleaned_no_anger, stimuli_no_anger, trials);
end

emotion_order = [...
    "neutral"
    "anger"
    "disgust"
    "happy"
    "sadness"
    "fear"
    "ground_state"
    ];
corr_table = table();
corr_table.('cg_vs_m') = calc_spearman(cg_data_averaged, m_data_averaged, mask);
corr_table.('cg_vs_nm') = calc_spearman(cg_data_averaged, nm_data_averaged, mask);
corr_table.('nm_vs_m') = calc_spearman(nm_data_averaged, m_data_averaged, mask);
corr_table.Properties.RowNames = emotion_order;

% Gather some basic statistical facts about t-values
max(cg_t_data, [], 'all');
min(cg_t_data, [], 'all');

max(nm_t_data, [], 'all');
min(nm_t_data, [], 'all');

max(m_t_data, [], 'all');
min(m_t_data, [], 'all');

for i = 1:size(cg_t_data,3)
    data = cg_t_data(:,:,i);
    m = median(data(~isnan(data)), 'all');
    pixels_over_threshold_count = ...
        length(data(data > cg_t_threshold | data < -cg_t_threshold));
    disp(['Emotion No. ', num2str(i), ':']);
    disp(['median: ', num2str(m)]);
    disp(['Amount of pixels larger/smaller than +/- FDR Threshold: ', ... 
        num2str(pixels_over_threshold_count)]);
    disp(' ');
end
    

for i = 1:size(m_t_data,3)
    data = m_t_data(:,:,i);
    m = median(data(~isnan(data)), 'all');
    pixels_over_threshold_count = ...
        length(data(data > m_t_threshold | data < -m_t_threshold));
    disp(['Emotion No. ', num2str(i), ':']);
    disp(['median: ', num2str(m)]);
    disp(['Amount of pixels larger/smaller than +/- FDR Threshold: ', ... 
        num2str(pixels_over_threshold_count)]);
    disp(' ');
end

for i = 1:size(nm_t_data,3)
    data = nm_t_data(:,:,i);
    m = median(data(~isnan(data)), 'all');
    pixels_over_threshold_count = ...
        length(data(data > nm_t_threshold | data < -nm_t_threshold));
    disp(['Emotion No. ', num2str(i), ':']);
    disp(['median: ', num2str(m)]);
    disp(['Amount of pixels larger/smaller than +/- FDR Threshold: ', ... 
        num2str(pixels_over_threshold_count)]);
    disp(' ');
end

% Take a closer look at left and right sides
cg_avg_left = mean(cg_avg_left, 4);
cg_avg_right = mean(cg_avg_right, 4);
cg_left_sum = sum(cg_avg_left, 'all');
cg_right_sum = sum(cg_avg_right, 'all');
cg_right_left_sum = cg_right_sum + cg_left_sum;
cg_right_part = cg_right_sum / cg_right_left_sum;
cg_left_part = cg_left_sum / cg_right_left_sum;

m_avg_left = mean(m_avg_left, 4);
m_avg_right = mean(m_avg_right, 4);
m_left_sum = sum(m_avg_left, 'all');
m_right_sum = sum(m_avg_right, 'all');
m_right_left_sum = m_right_sum + m_left_sum;
m_right_part = m_right_sum / m_right_left_sum;
m_left_part = m_left_sum / m_right_left_sum;

nm_avg_left = mean(nm_avg_left, 4);
nm_avg_right = mean(nm_avg_right, 4);
nm_left_sum = sum(nm_avg_left, 'all');
nm_right_sum = sum(nm_avg_right, 'all');
nm_right_left_sum = nm_right_sum + nm_left_sum;
nm_right_part = nm_right_sum / nm_right_left_sum;
nm_left_part = nm_left_sum / nm_right_left_sum;

% Test CG LDA model against NM and M data
% ToDo: Refactor everything into own functions
[~, ~, lda_model, ~, loadings, score] = ...
    helpers.calc_model(cg_cleaned, stimuli);
% Apply same transformation as in calc_model to have obversations in rows
% and variables in columns
nm_transformed = reshape(nm_cleaned, 522, 171, [], 1);
nm_transformed = reshape(nm_transformed , [], size(nm_transformed,3))';
nm_transformed = nm_transformed*loadings;
nm_predicted_with_cg_model = predict(lda_model, nm_transformed(:,1:30));
subject_count = size(nm_cleaned, 4);
responses = repmat(stimuli, subject_count, 1);
nm_vs_cg_correct_predictions = length(find(... 
    nm_predicted_with_cg_model == responses));
nm_vs_cg_accuracy = nm_vs_cg_correct_predictions / length(nm_predicted_with_cg_model);
[confusion_matrix, order] = confusionmat(responses, nm_predicted_with_cg_model);
nm_vs_cg_confusion_table = array2table(confusion_matrix, ...
    'RowNames', order, ...
    'VariableNames', order);
nm_vs_cg_confusion_table.Properties.Description = ...
    'left: real class; top: predicted class';

m_transformed = reshape(m_cleaned, 522, 171, [], 1);
m_transformed = reshape(m_transformed , [], size(m_transformed,3))';
m_transformed = m_transformed*loadings;
m_predicted_with_cg_model = predict(lda_model, m_transformed(:,1:30));
subject_count = size(m_cleaned, 4);
responses = repmat(stimuli, subject_count, 1);
m_vs_cg_correct_predictions = length(find(... 
    m_predicted_with_cg_model == responses));
m_vs_cg_accuracy = m_vs_cg_correct_predictions / length(m_predicted_with_cg_model);
[confusion_matrix, order] = confusionmat(responses, m_predicted_with_cg_model);
m_vs_cg_confusion_table = array2table(confusion_matrix, ...
    'RowNames', order, ...
    'VariableNames', order);
m_vs_cg_confusion_table.Properties.Description = ...
    'left: real class; top: predicted class';