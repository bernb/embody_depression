function figure_handle = data(data, labels, threshold, plot_title)
%DATA plot a row of figures. Values within [-threshold, threshold] will
%appear black.
% Input:
%   (nxmxj) Matrix
%       n, m: pixel coordinates
%       j: plot count
% ToDo: Plots scheinen teilweise oben am Kopf ein wenigabgeschnitten zu sein

figure_handle = figure;
plot_count = size(data, 3);

if nargin < 4
    plot_title = '';
end

figure_handle.Name = plot_title;

if length(labels) ~= plot_count
   warning('Label count not consistent with plot count. Skipping labels.'); 
end

if nargin < 2 || length(labels) ~= plot_count
    use_labels = false;
else
    use_labels = true;
end

num_colors = 64;
data_max = max(data, [], 'all');
if data_max == 0
    color_limits = [-1,1];
else
    color_limits = [-data_max,data_max];
end

if nargin < 3
    hotmap = hot(num_colors);
    coldmap = flipud([hotmap(:,3) hotmap(:,2) hotmap(:,1) ]);
    color_map = [coldmap; hotmap];
    sgtitle('no threshold');
else
    color_map = helpers.plot.color_map(data_max, threshold, num_colors);
    sgtitle(['threshold: ', num2str(threshold)]);
end
    

for n = 1:plot_count
   % We leave one empty to attach colorbar after the loop
   subplot(1, plot_count+1, n); 
   helpers.plot.single_figure(data(:,:,n), color_map, color_limits);
   if use_labels
       title(labels(n));
   end
end
subplot(1, plot_count+1, plot_count+1);
image_handle = helpers.plot.single_figure(data(:,:,n), color_map, color_limits);
axis_handle = image_handle.Parent;
colorbar(axis_handle);
image_handle.Visible = false;
axis_handle.Visible = false;

end

