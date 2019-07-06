function plot_t_maps(tdata, tdata_einzel)

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

% reshaping the tvalues into images
tvals_for_plot=zeros(size(mask,1),size(mask,2),NC);
for condit=1:NC
    temp=zeros(size(mask));
    temp(in_mask)=tdata(:,condit);
    temp(~isfinite(temp))=0; % we set nans and infs to 0 for display
    max(temp(:))
    tvals_for_plot(:,:,condit)=temp;
    csvwrite(sprintf('results/tvals_exp_tine.%d.csv', condit),temp);
end

tvals_for_plot_einzel=zeros(size(mask,1),size(mask,2),NP);
for condit=1:NP
    temp=zeros(size(mask));
    temp(in_mask)=tdata_einzel(:,condit);
    temp(~isfinite(temp))=0; % we set nans and infs to 0 for display
    max(temp(:))
    tvals_for_plot_einzel(:,:,condit)=temp;
    csvwrite(sprintf('results/tvals_exp_tine_alle_stimuli.%d.csv', condit),temp);
end

% plotting
plotcols = 8; %set as desired
plotrows = ceil((NC+1)/plotcols); % number of rows is equal to number of conditions+1 (for the colorbar)
base=uint8(imread('base.png'));
base2=base(10:531,33:203,:); % single image base
labels={'Neutral'
        'Anger'
        'Disgust'
        'Happiness'
        'Sadness'
        'Fear'
        'Ground state'};
for n=1:NC
    figure(100)
    subplot(plotrows,plotcols,n)
    imagesc(base2);
    axis('off');
    set(gcf,'Color',[1 1 1]);
    hold on;
    over2=tvals_for_plot(:,:,n);
    fh=imagesc(over2,[-M,M]);
    axis('off');
    axis equal
    colormap(hotcoldmap);
    set(fh,'AlphaData',mask)
    title(labels(n),'FontSize',10)
    if(n==NC)
        subplot(plotrows,plotcols,n+1)
        fh=imagesc(ones(size(base2)),[-M,M]);
        axis('off');
        colorbar;
        % save a screenshot, useful for quality control (commented)
         saveas(gcf,'results_stat_alexa/ttest_exp_tine.png');
    end
end


plotrows_einzel = ceil((NP+1)/plotcols); % number of rows is equal to number of conditions+1 (for the colorbar)
%M=0.1; % max range for colorbar
for n=1:NP
    figure(101)
    subplot(plotrows_einzel,plotcols,n)
    imagesc(base2);
    axis('off');
    set(gcf,'Color',[1 1 1]);
    hold on;
    over2=tvals_for_plot_einzel(:,:,n);
    fh=imagesc(over2,[-M,M]);
    axis('off');
    axis equal
    colormap(hotcoldmap);
    set(fh,'AlphaData',mask)
    title(n-1,'FontSize',10)
    if(n==NP)
        subplot(plotrows_einzel,plotcols,n+1)
        fh=imagesc(ones(size(base2)),[-M,M]);
        axis('off');
        colorbar;
        % save a screenshot, useful for quality control (commented)
         saveas(gcf,'results_stat_alexa/ttest_exp_tine_einzelstimuli.png')
    end
end
end

