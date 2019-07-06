% Rewrite from embody_demo_*.m
% Input: Directory that contains one directory per subject with one csv
% file per image. csv files are created by the 'emBODY' program.
% Output:

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
    
    % Data loading
    data=load_subj([basepath '/' subjects(s).name],2);
    
    resmat = reconstruct_painting(data, base);
    
    % Zusammenführen der Bilddaten zu demselben Label
    reize(:,:,1) = resmat(:,:,10) + resmat(:,:,18) + resmat(:,:,20) + resmat(:,:,22); % neutral
    reize(:,:,2) = resmat(:,:,2) + resmat(:,:,6) + resmat(:,:,21) + resmat(:,:,23); %anger
    reize(:,:,3)= resmat(:,:,3) + resmat(:,:,5) + resmat(:,:,12) + resmat(:,:,24); %disgust
    reize(:,:,4)= resmat(:,:,4) + resmat(:,:,7) + resmat(:,:,13) + resmat(:,:,17); % happy
    reize(:,:,5)= resmat(:,:,8) + resmat(:,:,15) + resmat(:,:,19) + resmat(:,:,25); %sadness
    reize(:,:,6)= resmat(:,:,9) + resmat(:,:,11) + resmat(:,:,14) + resmat(:,:,16); %fear
    reize(:,:,7)= resmat(:,:,1); %ground state
    
    % Speichern in .csv-Datei
    for c = 1:7
        filename = sprintf('output/stimuli_files/aktivierung_exp.%d.csv', condit);
        if ~isfile(filename)
            fclose(fopen(filename,'w'));
        end
        csvwrite(sprintf('output/stimuli_files/aktivierung_exp.%d.csv', condit),reize(:,:,condit));
    end
    
    % store result
    save(['output/stimuli_files/' subjects(s).name '_preprocessed.mat'],'resmat')
    save(['output/stimuli_files/' subjects(s).name '_reize.mat'],'reize')
    
    visualize_subject(reize, base2, mask, labels, s);
    
end



%visualize_total(reize, base2);

% store result (commented)
save('output/stimuli_files/total/total_reize.mat','reize');

end
