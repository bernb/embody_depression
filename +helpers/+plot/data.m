function figure_handle = data(data, labels, threshold, plot_title, flip_colors)
%DATA plot a row of figures. Values within [-threshold, threshold] will
%appear black.
% Input:
%   (nxmxj) Matrix
%       n, m: pixel coordinates
%       j: plot count
% ToDo: Plots scheinen teilweise oben am Kopf ein wenigabgeschnitten zu sein

figure_handle = figure;
plot_count = size(data, 3);

if nargin < 5
    flip_colors = false;
end

if nargin < 4
    plot_title = '';
end

figure_handle.Name = plot_title;

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
    color_limits = [floor(-data_max),ceil(data_max)];
end

if nargin < 3
    hotmap = hot(num_colors);
    coldmap = flipud([hotmap(:,3) hotmap(:,2) hotmap(:,1) ]);
    color_map = [coldmap; hotmap];
else
    color_map = helpers.plot.color_map(data_max, threshold, num_colors);
end

if flip_colors
    color_map = flipud(color_map);
end
    
tiledlayout(1,plot_count, 'TileSpacing', 'compact');
for n = 1:plot_count
    nexttile;
    helpers.plot.single_figure(data(:,:,n), color_map, color_limits);
    if use_labels
        t = title(labels(n), 'FontSize', 22);
        set(t, 'Rotation', 90.0, 'VerticalAlignment', 'middle', 'HorizontalAlignment', 'left');
    end
end
c = colorbar(gca);
c.FontSize = 22;
c.FontWeight = 'bold';

if use_labels
    figure_position = [0 0 1000 575];
else
    figure_position = [0 0 1000 400];
end

figure_handle.Position = figure_position;
end

