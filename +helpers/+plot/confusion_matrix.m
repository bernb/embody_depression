function image_handle = confusion_matrix(confusion_table)
% Note: If RGB colors are possible, matlab colormap 'jet' is a good
% alternative.


% If we have 30*25 = 750 trials with 6 emotions, so max. correct answer is
% 750/6 = 120
lim_max = sum(confusion_table{1,:}, 2);
limits = [0 lim_max];

% We color in white everything below chance level (lim_max / emotion_count)
% ToDo: Don't hardcode white limit
graymap = gray;
graymap = flipud(graymap);
map = [ones(12,3); graymap];

figure;
image_handle = imagesc(confusion_table.Variables, limits);
axes = image_handle.Parent;
colorbar(axes);
colormap(axes, map);
end

