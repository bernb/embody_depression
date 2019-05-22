function [result_matrix, condition] = reconstruct_painting(data, base)
%RECONSTRUCT_PAINTING 
    % 'data' contains all mouse movements. What we need are the mouse
    % locations while the button was pressed (i.e. during painting)
    % Furthermore, the painting tool has a brush size. We recreate that
    % using image filter
    
    NC = length(data);

    result_matrix = zeros(522,171,NC);
    condition = zeros(522,171,NC);
    
    for n=1:NC % loop over the pictures = conditions/ .csv-files
        T=length(data(n).paint(:,2)); % number of mouse locations
        over=zeros(size(base,1),size(base,2)); % empty matrix to reconstruct painting
        for t=1:T
            y=ceil(data(n).paint(t,3)+1);
            x=ceil(data(n).paint(t,2)+1);
            if(x<=0) x=1; end %#ok<*SEPEX>
            if(y<=0) y=1; end
            if(x>=900) x=900; end % hardcoded for our experiment, you need to change it if you changed layout
            if(y>=600) y=600; end % hardcoded for our experiment, you need to change it if you changed layout
            over(y,x)=over(y,x)+1;
        end
        % Simulate brush size with a gaussian disk
        h=fspecial('gaussian',[15 15],5);
        over=imfilter(over,h);
        % we subtract left part minus right part of painted area
        % values are hard-coded to our web layout
        over2 = over(10:531,33:203)-over(10:531,696:866);
        result_matrix(:,:,n) = over(10:531,33:203,:)-over(10:531,696:866,:);
        % Summenbildung der Aktivierungsmuster aus den unterschiedlichen 
        % Probanden zu jeder Bedingung
        condition(:,:,n) = condition(:,:,n) + result_matrix(:,:,n); 
    end
end

