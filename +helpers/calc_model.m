function [confusion_table,accuracy] = calc_model(data, stimuli)

subject_count = size(data, 4);

% Merge subjects and stimuli into single dimension
% This results in a 522x171x(n*m) matrix with n stimuli and m subjects, sorted
% by subjects
data = reshape(data, 522, 171, [], 1);

% Merge 2d pixel values into single dimension
% This results in a (n*m)x(522*171) matrix, which we transpose for pca
data = reshape(data, [], size(data,3))';

% score contains data rotated by loadings
[~,score] = pca(data);

responses = repmat(stimuli, subject_count, 1);
lda_model = fitcdiscr(score(:,1:30), responses);
cv_model = crossval(lda_model, 'KFold', 5);
[label, ~] = kfoldPredict(cv_model);

correct_predictions = length(find(label == responses));
accuracy = correct_predictions / length(label);

[confusion_matrix, order] = confusionmat(label, responses);
confusion_table = array2table(confusion_matrix, ...
    'RowNames', order, ...
    'VariableNames', order);
end

