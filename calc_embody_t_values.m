function calc_embody_t_values(basepath)
if nargin < 1
    basepath = 'data/subjects';
end
% get a list of subjects
subjects=dir([basepath '/*']);

% the base image used for painting (in our case only one sided since we
% subtract values)
base=uint8(imread('images/base.png'));
base2=base(10:531,33:203,:); % single image base

labels={'Neutral'
    'Anger'
    'Disgust'
    'Happiness'
    'Sadness'
    'Fear'
    'Ground state'};

mask=imread('images/mask.png');

for s=1:length(subjects) % loop over the subjects
    % skip dot and dotdot folders (if using macos or linux)
    if(strcmp(subjects(s).name(1),'.'))
        continue;
    end
    
    %% Data loading
    data=load_subj([basepath '/' subjects(s).name],2);
    
    [resmat, condition] = reconstruct_painting(data, base);
    
    reize(:,:,1) = resmat(:,:,10) + resmat(:,:,18) + resmat(:,:,20) + resmat(:,:,22); % neutral
    reize(:,:,2) = resmat(:,:,2) + resmat(:,:,6) + resmat(:,:,21) + resmat(:,:,23); %anger
    reize(:,:,3)= resmat(:,:,3) + resmat(:,:,5) + resmat(:,:,12) + resmat(:,:,24); %disgust
    reize(:,:,4)= resmat(:,:,4) + resmat(:,:,7) + resmat(:,:,13) + resmat(:,:,17); % happy
    reize(:,:,5)= resmat(:,:,8) + resmat(:,:,15) + resmat(:,:,19) + resmat(:,:,25); %sadness
    reize(:,:,6)= resmat(:,:,9) + resmat(:,:,11) + resmat(:,:,14) + resmat(:,:,16); %fear
    reize(:,:,7)= resmat(:,:,1); %ground state
    
    % Speichern in .csv-Datei
    for condit = 1:7
        filename = sprintf('results/aktivierung_exp.%d.csv', condit);
        if ~isfile(filename)
            fclose(fopen(filename,'w'));
        end
        csvwrite(sprintf('results/aktivierung_exp.%d.csv', condit),reize(:,:,condit));
    end
    
    % initialize matrices for mean values (per emotion and patient)
    mw_gesamt = zeros(length(subjects), 7);
    mw_beine = zeros(length(subjects), 7);
    mw_arme = zeros(length(subjects), 7);
    mw_kopf = zeros(length(subjects), 7);
    mw_rumpf = zeros(length(subjects), 7);

    
    
    
    %% store result
    save(['results/' subjects(s).name '_preprocessed.mat'],'resmat')
    save(['results/' subjects(s).name '_reize.mat'],'reize')
    %% visualize subject's data
    M=0.2;%M=max(abs(resmat(:))); % max range for colorbar
    NumCol=64;
    hotmap=hot(NumCol);
    coldmap=flipud([hotmap(:,3) hotmap(:,2) hotmap(:,1) ]);
    hotcoldmap=[
        coldmap
        hotmap
        ];

    % visualize all responses for each subject into a grid of numcolumns
    plotcols = 8; %set as desired
    plotrows = 1; % number of rows is equal to number of emotions+1 (for the colorbar)
    
    for n=1:7 % 7= Anzahl der Reize + Grundzustand
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
            saveas(gcf,[subjects(s).name '.png'])
        end
    end
end

%visualize total data
% Zusammenf�hren der Bilddaten zu demselben Label
reize(:,:,1) = condition(:,:,10) + condition(:,:,18) + condition(:,:,20) + condition(:,:,22); % neutral
reize(:,:,2) = condition(:,:,2) + condition(:,:,6) + condition(:,:,19) + condition(:,:,23); %anger
reize(:,:,3) = condition(:,:,3) + condition(:,:,5) + condition(:,:,12) + condition(:,:,24); %disgust
reize(:,:,4) = condition(:,:,4) + condition(:,:,7) + condition(:,:,13) + condition(:,:,17); % happy
reize(:,:,5) = condition(:,:,8) + condition(:,:,15) + condition(:,:,19) + condition(:,:,25); %sadness
reize(:,:,6) = condition(:,:,9) + condition(:,:,11) + condition(:,:,14) + condition(:,:,16); %fear

%% store result (commented)
save('preprocessed_total/total_reize.mat','reize');

%% visualize total data
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
    figure(s)
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

%% Anzahl der Bildpixel bestimmen (f�r Mittelwertberechnung)
% Bestimme Anzahl der Bildpixel (um Durchschnittswerte der Aktivierung zu
% erzielen)


mw_gesamt = mw_gesamt/anzahl_pixel_gesamt;
mw_beine = mw_beine/anzahl_pixel_beine;
mw_arme = mw_arme/anzahl_pixel_arme;
mw_kopf = mw_kopf/anzahl_pixel_kopf;
mw_rumpf = mw_rumpf/anzahl_pixel_rumpf;

%%Durchschnittswerte in .csv-Dateien speichern
csvwrite('results/mittelwerte_kontr_gesamt.csv', mw_gesamt);
csvwrite('results/mittelwerte_kontr_beine.csv', mw_beine);
csvwrite('results/mittelwerte_kontr_arme.csv', mw_arme);
csvwrite('results/mittelwerte_kontr_kopf.csv', mw_kopf);
csvwrite('results/mittelwerte_kontr_rumpf.csv', mw_rumpf);
end
