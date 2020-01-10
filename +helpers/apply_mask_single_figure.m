function figure_data = apply_mask_single_figure(figure_data)
%APPLY_MASK_SINGLE_FIGURE Apply mask to single 522x171 figure

mask = imread('images/mask.png');
outside_indices = mask<128;
figure_data(outside_indices) = NaN;
end

