function [result_matrix, condition] = reconstruct_painting(data, base)
%RECONSTRUCT_PAINTING 
% Input: 1xN struct with 4 fields: mouse, paint, mousedown, mouseup which
% is created by load_subj from raw csv data which contains all mouse
% movements.
%
% Output: Mouse locations while the button was pressed (i.e. during
% painting).
    
    stimuli_count = length(data);

    result_matrix = zeros(522,171,stimuli_count);
    condition = zeros(522,171,stimuli_count);
    
    for n=1:stimuli_count % loop over the pictures
        mouse_location_count=length(data(n).paint(:,2)); % number of mouse locations
        
        % Note that base is supposed to be 600x900
        over=zeros(size(base,1),size(base,2)); % empty matrix to reconstruct painting
        
        % Iterate over data(n).paint values, which are (x,y) coordinates
        % and count appearence in what will later be result_matrix
        for i=1:mouse_location_count
            % ToDo: Is ceil really neccessary? Seems to be integer anyway
            x=ceil(data(n).paint(i,2)+1);
            y=ceil(data(n).paint(i,3)+1);
            if(x<=0) x=1; end %#ok<*SEPEX>
            if(y<=0) y=1; end
            if(x>=900) x=900; end % hardcoded for our experiment, you need to change it if you changed layout
            if(y>=600) y=600; end % hardcoded for our experiment, you need to change it if you changed layout
            over(y,x)=over(y,x)+1;
        end
        % Simulate brush size with a gaussian disk
        % Note that the painting tool itself has a brush size
        h=fspecial('gaussian',[15 15],5);
        over=imfilter(over,h);
        % we subtract left part minus right part of painted area
        % values are hard-coded to our web layout
        result_matrix(:,:,n) = over(10:531,33:203,:)-over(10:531,696:866,:);
        % Summenbildung der Aktivierungsmuster aus den unterschiedlichen 
        % Probanden zu jeder Bedingung
        condition(:,:,n) = condition(:,:,n) + result_matrix(:,:,n); 
    end
end

