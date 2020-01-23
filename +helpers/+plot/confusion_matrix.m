function image_handle = confusion_matrix(confusion_table)
% Note: If RGB colors are possible, matlab colormap 'jet' is a good
% alternative.


% If we have 30*25 = 750 trials with 6 emotions, so max. correct answer is
% 750/6 = 120
lim_max = sum(confusion_table{1,:}, 2);
limits = [0 lim_max];
chance_level = round(lim_max / height(confusion_table));
prop_count = length(confusion_table.Properties.VariableNames);

% We color in white everything below chance level (lim_max / emotion_count)
graymap = gray(lim_max - chance_level);
graymap = flipud(graymap);
map = [ones(chance_level,3); graymap];

figure;
image_handle = imagesc(confusion_table.Variables, limits);
axes = image_handle.Parent;
colorbar(axes);
colormap(axes, map);

% Always keep 1:1 aspect ratio
daspect([1 1 1 ]);

% Tick Properties
yticks(1:prop_count);
xticks(1:prop_count);
if prop_count == 6
    xticklabels({'Anger', 'Disgust', 'Happiness', 'Sadness', 'Fear', 'Neutral'});
    yticklabels({'Anger', 'Disgust', 'Happiness', 'Sadness', 'Fear', 'Neutral'});
else
    xticklabels({'Disgust', 'Happiness', 'Sadness', 'Fear', 'Neutral'});
    yticklabels({'Disgust', 'Happiness', 'Sadness', 'Fear', 'Neutral'});
end
xtickangle(45);
axes.TickLength = [0 0];
end

