function visualize_subject(reize, base2, mask, labels, s)
%VISUALIZE_SUBJECT


    M=0.2;%M=max(abs(resmat(:))); % max range for colorbar
    NumCol = 64;
    hotmap = hot(NumCol);
    coldmap = flipud([hotmap(:,3) hotmap(:,2) hotmap(:,1) ]);
    hotcoldmap = [coldmap; hotmap];

    % visualize all responses for each subject into a grid of numcolumns
    plotcols = 8;
    plotrows = 1; % number of rows is equal to number of emotions+1 (for the colorbar)
    
    for n=1:7 % 7 = Anzahl der Reize + Grundzustand
        figure(s)
        subplot(plotrows,plotcols,n)
        imagesc(base2);
        axis('off');
        set(gcf,'Color',[1 1 1]);
        hold on;
        over2=reize(:,:,n);
        fh=imagesc(over2,[-M,M]);
        axis('off');
        axis equal
        colormap(hotcoldmap);
        set(fh,'AlphaData',mask)
        title(labels(n),'FontSize',10)
        if(n==7)
            subplot(plotrows,plotcols,n+1)
            fh=imagesc(ones(size(base2)),[-M,M]);
            axis('off');
            colorbar;
            % save a screenshot, useful for quality control (commented)
            %saveas(gcf,[subjects(s).name '.png'])
        end
    end
end

