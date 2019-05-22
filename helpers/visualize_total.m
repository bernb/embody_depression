function visualize_total(reize, base2)
%VISUALIZE_TOTAL Zusammenführen der Bilddaten zu demselben Label

Mtot=0.2; %M=max(abs(reize(:))); % max range for colorbar
NumCol=64;
hotmap=hot(NumCol);
coldmap=flipud([hotmap(:,3) hotmap(:,2) hotmap(:,1) ]);
hotcoldmap=[
    coldmap
    hotmap
    ];

% visualize all responses for each subject into a grid of numcolumns

for n=1:7 % 7= Anzahl der Reize + Grundzustand
    figure
    subplot(plotrows,plotcols,n)
    imagesc(base2);
    axis('off');
    set(gcf,'Color',[1 1 1]);
    hold on;
    over2=reize(:,:,n);
    fh=imagesc(over2,[-Mtot,Mtot]);
    axis('off');
    axis equal
    colormap(hotcoldmap);
    set(fh,'AlphaData',mask)
    title(labels(n),'FontSize',10)
    if(n==7)
        subplot(plotrows,plotcols,n+1)
        fh=imagesc(ones(size(base2)),[-Mtot,Mtot]);
        axis('off');
        colorbar;
        % save a screenshot, useful for quality control (commented)
        saveas(gcf,['results/total_experimental.png'])
    end
end
end

