function rho = calc_spearman(data1, data2, mask)
% Input:
% averaged output of preprocess_data, which is stimuli-averaged data
% 
% data1: (nxmxjxs1)-Matrix
%   n, m: 2d coordinates of clicked pixels
%   j: emotion count
%   s1: subject count
%
% data2: (nxmxjxs2)-Matrix
%   all as above, note that s1 ~= s2 is possible
%
% mask: Image of mask, used to zero out pixels outside of mask
%
% Output:
%   Spearman's correlations over every emotion between data1 and data2.
%   We use the mean over all subjects for every emotion before calculation

if size(data1,3) ~= size(data2,3)
    error('Third dimension of data1 and data2 (= emotion count) must be equal');
end
outside_indices = find(mask<=128);
inside_indices = find(mask>128);

emotion_count = size(data1,3);
rho = zeros(emotion_count, 1);

for i=1:emotion_count
    average1 = mean(data1(:,:,i,:),4);
    average1(outside_indices) = 0;
    average1 = helpers.add_noise(average1);

    average2 = mean(data2(:,:,i,:),4);
    average2(outside_indices) = 0;
    average2 = helpers.add_noise(average2);

    average1 = reshape(average1(inside_indices), [], 1);
    average2 = reshape(average2(inside_indices), [], 1);

    rho(i) = corr(average1, average2, 'Type', 'Spearman');
end

