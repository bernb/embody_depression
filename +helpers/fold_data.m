function folded_data = fold_data(unfolded_data)
%FOLD_DATA Transform k 2d coordinates [(x,y),k] into 2D data (k,z) so that
% every pixel gets it's own column.
% Used to apply ttest over single pixels.
% Input:
%   unfolded_data: (x,y,k) Matrix
%       x,y: pixel coordinates
%       k: figure count
%
% Output:
%   folded_data: (k,z) Matrix
%       k: as above
%       z: x*y linearized (x,y) coordinates
pixel_count = size(unfolded_data, 1) * size(unfolded_data, 2);
figure_count = size(unfolded_data, 3);
folded_data = zeros(figure_count, pixel_count);

for i=1:figure_count
   folded_data(i,:) = reshape(unfolded_data(:,:,i),1, []);
end

end

