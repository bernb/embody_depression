function image_handle = single_figure(data, color_map, color_limits)

if nargin < 3
    data_max = max(1, max(data, [], 'all'));
    color_limits = [-data_max, data_max];
end
if nargin < 2
    color_map = hot(64);
end

image_handle = imagesc(data, color_limits);
axes = image_handle.Parent;
mask = imread('images/mask.png');

colormap(axes, color_map);
axes.DataAspectRatio = [1 1 1];
axes.Box = 'off';
axes.XColor = 'none';
axes.YColor = 'none';
image_handle.AlphaData = mask;

end

