function [accuracies, avg_confusion_table] = calc_averaged_model_data(data, stimuli, trials)

accuracies = zeros(trials,1);
emotion_count = length(unique(stimuli));
cg_confusion_data = zeros(emotion_count,emotion_count);
for i=1:trials
    % confusion_table can be plotted with imagesc or confusionchart
    [avg_confusion_table, accuracy] = helpers.calc_model(data, stimuli);
    accuracies(i) = accuracy;
    cg_confusion_data = cg_confusion_data + avg_confusion_table{:,:};
    if mod(i,10) == 0
        disp([num2str(i), ' trials completed.']);
    end
end
cg_confusion_data = cg_confusion_data ./ trials;
avg_confusion_table{:,:} = cg_confusion_data;
end

