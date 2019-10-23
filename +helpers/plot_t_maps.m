function plot_t_maps(tdata, tdata_einzel, emotion_count, stimuli_count, mask)

M=5; % max range for colorbar
NumCol=64;

non_sig=0;%round(th/M*NumCol); % proportion of non significant colors
hotmap=hot(NumCol-non_sig);
coldmap=flipud([hotmap(:,3) hotmap(:,2) hotmap(:,1) ]);
hotcoldmap=[
    coldmap
    zeros(2*non_sig,3);
    hotmap
    ];

% plotting
plotcols = 8; %set as desired
plotrows = ceil((emotion_count+1)/plotcols); % number of rows is equal to number of conditions+1 (for the colorbar)
base=uint8(imread('base.png'));
base2=base(10:531,33:203,:); % single image base
labels={'Neutral'
        'Anger'
        'Disgust'
        'Happiness'
        'Sadness'
        'Fear'
        'Ground state'};
for n=1:emotion_count
    figure(100)
    subplot(plotrows,plotcols,n)
    imagesc(base2);
    axis('off');
    set(gcf,'Color',[1 1 1]);
    hold on;
    over2=tdata(:,:,n);
    fh=imagesc(over2,[-M,M]);
    axis('off');
    axis equal
    colormap(hotcoldmap);
    set(fh,'AlphaData',mask)
    title(labels(n),'FontSize',10)
    if(n==emotion_count)
        subplot(plotrows,plotcols,n+1)
        fh=imagesc(ones(size(base2)),[-M,M]);
        axis('off');
        colorbar;
        % save a screenshot, useful for quality control (commented)
         saveas(gcf,'images/ttest_exp_tine.png');
    end
end


plotrows_einzel = ceil((stimuli_count+1)/plotcols); % number of rows is equal to number of conditions+1 (for the colorbar)
%M=0.1; % max range for colorbar
for n=1:stimuli_count
    figure(101)
    subplot(plotrows_einzel,plotcols,n)
    imagesc(base2);
    axis('off');
    set(gcf,'Color',[1 1 1]);
    hold on;
    over2=tdata_einzel(:,:,n);
    fh=imagesc(over2,[-M,M]);
    axis('off');
    axis equal
    colormap(hotcoldmap);
    set(fh,'AlphaData',mask)
    title(n-1,'FontSize',10)
    if(n==stimuli_count)
        subplot(plotrows_einzel,plotcols,n+1)
        fh=imagesc(ones(size(base2)),[-M,M]);
        axis('off');
        colorbar;
        % save a screenshot, useful for quality control (commented)
         saveas(gcf,'images/ttest_exp_tine_einzelstimuli.png')
    end
end
end

