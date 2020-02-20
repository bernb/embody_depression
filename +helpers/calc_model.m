function [confusion_table,accuracy, lda_model, cv_model, pca_loadings, score] = calc_model(data, stimuli)

subject_count = size(data, 4);

% Merge subjects and stimuli into single dimension
% This results in a 522x171x(n*m) matrix with n stimuli and m subjects, sorted
% by subjects
data = reshape(data, 522, 171, [], 1);

% Merge 2d pixel values into single dimension
% This results in a (n*m)x(522*171) matrix, which we transpose for pca
data = reshape(data, [], size(data,3))';

% score contains data rotated by loadings
[pca_loadings, score] = pca(data);

responses = repmat(stimuli, subject_count, 1);
lda_model = fitcdiscr(score(:,1:30), responses);
cv_model = crossval(lda_model, 'KFold', 5);
[label, ~] = kfoldPredict(cv_model);

correct_predictions = length(find(label == responses));
accuracy = correct_predictions / length(label);

% Check if anger stimuli is present
if any(strcmp(stimuli, 'Anger'))
    conf_matrix_order = {'Neutral', 'Anger', 'Disgust', 'Happiness', 'Sadness', 'Fear'};
else
    conf_matrix_order = {'Neutral', 'Disgust', 'Happiness', 'Sadness', 'Fear'};
end
[confusion_matrix, order] = confusionmat(responses, label, 'order', conf_matrix_order);
confusion_table = array2table(confusion_matrix, ...
    'RowNames', order, ...
    'VariableNames', order);
confusion_table.Properties.Description = ...
    'left: real class; top: predicted class';
end

