%% this is just a quick demo of how to efficiently run a one sample ttest
% for a set of preprocessed subjects

clear all
close all


%% mask (we consider only pixels inside the mask for multiple comparisons)
mask=imread('mask.png');
in_mask=find(mask>128); % list of pixels inside the mask


%% load all subjects
basepath=['./output/stimuli_files/']
files=dir([basepath '*.mat']); % preprocessed files, obtained by running embody_demo.m
NS=length(files);
NC=25; % number of conditions
data=zeros(length(in_mask),NS,NC);

for s=1:NS
    load([basepath files(s).name]); % now we have variable resmat
    % reshape 3D matrix intro 2D matrix ( pixels X conditions )
    temp=reshape(resmat,[],NC);
    data(:,s,:)=temp(in_mask,:);
end

tdata=zeros(length(in_mask),NC);
for condit=1:NC
    [H,P,CI,STATS] = ttest(data(:,:,condit)');
    tdata(:,condit)=STATS.tstat;
end

%% multiple comparisons correction across all conditions
alltdata=tdata(:);
alltdata(find(~isfinite(alltdata))) = [];   % getting rid of anomalies due to low number of demo subjects (ie no variance)

df=NS-1;    % degreeso of freedom
P        = 1-cdf('T',alltdata,df);  % p values
[pID pN] = helpers.FDR(P,0.05);             % BH FDR
tID      = icdf('T',1-pID,df);      % T threshold, indep or pos. correl.
tN       = icdf('T',1-pN,df) ;      % T threshold, no correl. assumptions

%% plot tmaps

M=15; % max range for colorbar
NumCol=64;


th=tID; % if tID is null, you need to use an uncorrected T-value threshold.
if(isempty(th)) 
    % using uncorrected T-value threshold
    th=3; 
end

non_sig=round(th/M*NumCol); % proportion of non significant colors
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
    temp(find(~isfinite(temp)))=0; % we set nans and infs to 0 for display
    max(temp(:))
    tvals_for_plot(:,:,condit)=temp;
end

% plotting
plotcols = 7; %set as desired
plotrows = ceil((NC+1)/plotcols); % number of rows is equal to number of conditions+1 (for the colorbar)
base=uint8(imread('base.png'));
base2=base(10:531,33:203,:); % single image base
labels={'Neutral'
'Fear'
'Anger'
'Disgust'
'Sadness'
'Happiness'
'Surprise'
'Anxiety'
'Love'
'Depression'
'Contempt'
'Pride'
'Shame'
'Jealousy'
};
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
    end
end
