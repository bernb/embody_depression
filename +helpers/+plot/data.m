function figure_handle = data(data)
% Input:
%   (nxmxj) Matrix
%       n, m: pixel coordinates
%       j: plot count

figure_handle = figure;
plot_count = size(data, 3);

num_colors = 64;
data_max = max(data, [], 'all');
if data_max == 0
    color_limits = [-1,1];
else
    color_limits = [-data_max,data_max];
end
hotmap = hot(num_colors);
coldmap = flipud([hotmap(:,3) hotmap(:,2) hotmap(:,1) ]);
color_map = [coldmap; hotmap];

for n = 1:plot_count
   % We leave one empty to attach colorbar after the loop
   subplot(1, plot_count+1, n); 
   helpers.plot.single_figure(data(:,:,n), color_map, color_limits);
end
subplot(1, plot_count+1, plot_count+1);
image_handle = helpers.plot.single_figure(data(:,:,n), color_map, color_limits);
axis_handle = image_handle.Parent;
colorbar(axis_handle);
image_handle.Visible = false;
axis_handle.Visible = false;

end

