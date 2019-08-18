function plot_data(data, plot_title)
%PLOT_DATA Visualize input data as single person plot

if nargin == 1
    plot_title = '';
end

mask=imread('images/mask.png');

M=0.2;%M=max(abs(resmat(:))); % max range for colorbar
NumCol = 64;
hotmap = hot(NumCol);
coldmap = flipud([hotmap(:,3) hotmap(:,2) hotmap(:,1) ]);
hotcoldmap = [coldmap; hotmap];

axis('off');
set(gcf,'Color',[1 1 1]);
fh=imagesc(data,[-M,M]);
axis('off');
axis equal
colormap(hotcoldmap);
set(fh,'AlphaData',mask)
title(plot_title, 'FontSize', 6);

end

