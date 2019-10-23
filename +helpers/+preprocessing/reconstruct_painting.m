function result_matrix = reconstruct_painting(data)
%RECONSTRUCT_PAINTING 
% Input: 1xN struct with 4 fields: mouse, paint, mousedown, mouseup which
% is created by load_subj from raw csv data which contains all mouse
% movements.
%
% Output: Matrix that counts appearence of clicked pixels (given in
% data(n).paint)
    
    stimuli_count = length(data);

    result_matrix = zeros(522,171,stimuli_count);
    
    for n=1:stimuli_count % loop over the pictures
        [left_side, right_side] = helpers.preprocessing.raw_to_matrix(data(n));
        result_matrix(:,:,n) = left_side - right_side;
    end
end

