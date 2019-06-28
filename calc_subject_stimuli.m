function calc_subject_stimuli(basepath)
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
    
    % Zusammenführen der Bilddaten zu demselben Label
    reize(:,:,1) = resmat(:,:,10) + resmat(:,:,18) + resmat(:,:,20) + resmat(:,:,22); % neutral
    reize(:,:,2) = resmat(:,:,2) + resmat(:,:,6) + resmat(:,:,21) + resmat(:,:,23); %anger
    reize(:,:,3)= resmat(:,:,3) + resmat(:,:,5) + resmat(:,:,12) + resmat(:,:,24); %disgust
    reize(:,:,4)= resmat(:,:,4) + resmat(:,:,7) + resmat(:,:,13) + resmat(:,:,17); % happy
    reize(:,:,5)= resmat(:,:,8) + resmat(:,:,15) + resmat(:,:,19) + resmat(:,:,25); %sadness
    reize(:,:,6)= resmat(:,:,9) + resmat(:,:,11) + resmat(:,:,14) + resmat(:,:,16); %fear
    reize(:,:,7)= resmat(:,:,1); %ground state
    
    % Speichern in .csv-Datei
    for condit = 1:7
        filename = sprintf('output/stimuli_files/aktivierung_exp.%d.csv', condit);
        if ~isfile(filename)
            fclose(fopen(filename,'w'));
        end
        csvwrite(sprintf('output/stimuli_files/aktivierung_exp.%d.csv', condit),reize(:,:,condit));
    end
    
    % initialize matrices for mean values (per emotion and patient)
    mw_gesamt = zeros(length(subjects), 7);
    mw_beine = zeros(length(subjects), 7);
    mw_arme = zeros(length(subjects), 7);
    mw_kopf = zeros(length(subjects), 7);
    mw_rumpf = zeros(length(subjects), 7);

    [... 
        mw_gesamt(s,:), ...
        mw_beine(s,:), ...
        mw_arme(s,:), ...
        mw_kopf(s,:), ...
        mw_rumpf(s,:) ...
     ] ...
     = calc_mean_activation(reize, mask);
    
    
    % store result
    save(['output/stimuli_files/' subjects(s).name '_preprocessed.mat'],'resmat')
    save(['output/stimuli_files/' subjects(s).name '_reize.mat'],'reize')
    
    visualize_subject(reize, base2, mask, labels, s);
    
end

%visualize total data
reize(:,:,1) = condition(:,:,10) + condition(:,:,18) + condition(:,:,20) + condition(:,:,22); % neutral
reize(:,:,2) = condition(:,:,2) + condition(:,:,6) + condition(:,:,19) + condition(:,:,23); %anger
reize(:,:,3) = condition(:,:,3) + condition(:,:,5) + condition(:,:,12) + condition(:,:,24); %disgust
reize(:,:,4) = condition(:,:,4) + condition(:,:,7) + condition(:,:,13) + condition(:,:,17); % happy
reize(:,:,5) = condition(:,:,8) + condition(:,:,15) + condition(:,:,19) + condition(:,:,25); %sadness
reize(:,:,6) = condition(:,:,9) + condition(:,:,11) + condition(:,:,14) + condition(:,:,16); %fear

%visualize_total(reize, base2);

% store result (commented)
save('output/stimuli_files/total/total_reize.mat','reize');

%Durchschnittswerte in .csv-Dateien speichern
csvwrite('output/stimuli_files/mittelwerte_kontr_gesamt.csv', mw_gesamt);
csvwrite('output/stimuli_files/mittelwerte_kontr_beine.csv', mw_beine);
csvwrite('output/stimuli_files/mittelwerte_kontr_arme.csv', mw_arme);
csvwrite('output/stimuli_files/mittelwerte_kontr_kopf.csv', mw_kopf);
csvwrite('output/stimuli_files/mittelwerte_kontr_rumpf.csv', mw_rumpf);
end
