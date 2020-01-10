function [diff, left_side, right_side] = reconstruct_painting(data)
%RECONSTRUCT_PAINTING 
% Input: 1xN struct with 4 fields: mouse, paint, mousedown, mouseup which
% is created by load_subj from raw csv data which contains all mouse
% movements.
%
% Output: Matrix that counts appearence of clicked pixels (given in
% data(n).paint)
    
    stimuli_count = length(data);

    diff = zeros(522,171,stimuli_count);
    left_side = zeros(522,171, stimuli_count);
    right_side = zeros(522,171, stimuli_count);
    
    for n=1:stimuli_count % loop over the pictures
        [l, r] = helpers.preprocessing.raw_to_matrix(data(n));
        left_side(:,:,n) = l;
        right_side(:,:,n) = r;
        diff(:,:,n) = l - r;
    end
end

