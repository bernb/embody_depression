function data = apply_mask(data)
%APPLY_MASK Set NaN to (522x171xkxj) data outside of mask

for i=1:size(data, 3)
    for j=1:size(data, 4)
        data(:,:,i,j) = helpers.apply_mask_single_figure(data(:,:,i,j));
    end
end
end

