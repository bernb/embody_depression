function image_handle = single_figure(data, color_map, color_limits)

image_handle = imagesc(data, color_limits);
axes = image_handle.Parent;

colormap(axes, color_map);
axes.DataAspectRatio = [1 1 1];
axes.Box = 'off';
axes.XColor = 'none';
axes.YColor = 'none';

end

