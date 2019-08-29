function [left_side, right_side] = raw_to_matrix(data, no_filter)
% Input: 1xN struct with 4 fields: mouse, paint, mousedown, mouseup which
% is created by load_subj from raw csv data which contains all mouse
% movements.
%
% Output: 2 matrices that counts appearence of clicked pixels (given in
% data(n).paint) for activation (left) and deactivation (right).

    mouse_location_count=length(data.paint(:,2)); % number of mouse locations

    % Note that base is supposed to be 600x900
    over=zeros(600,900); % empty matrix to reconstruct painting

    % Iterate over data(n).paint values, which are (x,y) coordinates
    % and count appearence in what will later be result_matrix
    for i=1:mouse_location_count
        % ToDo: Is ceil really neccessary? Seems to be integer anyway
        x=ceil(data.paint(i,2)+1);
        y=ceil(data.paint(i,3)+1);
        if(x<=0) x=1; end %#ok<*SEPEX>
        if(y<=0) y=1; end
        if(x>=900) x=900; end % hardcoded for our experiment, you need to change it if you changed layout
        if(y>=600) y=600; end % hardcoded for our experiment, you need to change it if you changed layout
        over(y,x)=over(y,x)+1;
    end
    if nargin == 1 || no_filter == false
        % Simulate brush size with a gaussian disk
        % Note that the painting tool itself has a brush size
        h=fspecial('gaussian',[15 15],5);
        over=imfilter(over,h);
    end
    % we subtract left part minus right part of painted area
    % values are hard-coded to our web layout
    left_side = over(10:531,33:203,:);
    right_side = over(10:531,696:866,:);
end
