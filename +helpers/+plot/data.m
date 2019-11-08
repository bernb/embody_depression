function figure_handle = data(data)
% Input:
%   (nxmxj) Matrix
%       n, m: pixel coordinates
%       j: plot count

figure_handle = figure;
plot_count = size(data, 3);

num_colors = 64;
data_max = max(data, [], 'all');
color_limits = [-data_max,data_max];
hotmap = hot(num_colors);
coldmap = flipud([hotmap(:,3) hotmap(:,2) hotmap(:,1) ]);
hotcoldmap = [coldmap; hotmap];

for n = 1:plot_count
   % We leave one empty to attach colorbar after the loop
   subplot(1, plot_count+1, n); 
   helpers.plot.single_figure(data(:,:,n), hotcoldmap, color_limits);
end
image_handle = imagesc(ones(size(data(:,:,1))), color_limits);
axis_handle = image_handle.Parent;
colorbar(axis_handle);
image_handle.Visible = false;
axis_handle.Visible = false;

end

