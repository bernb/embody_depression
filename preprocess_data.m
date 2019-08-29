function preprocess_data(basepath)
% Preprocessing of raw emBODY data. If no path is given 'data/subjects' 
% will be used as basepath.
% Function expects mask image at images/mask.png. Note that amount of images per emotion 
% and ordering is hardcoded here.
%
% Input:
% Directory that contains one directory per subject with one csv
% file per image. csv files are created by the 'emBODY' program.
% 
%
% Output: 
% Two files per subject 'all_stimuli_XXX' and 'single_stimuli_XXX',
% containing variables 'resmat' and 'stimumat', which are matrices
% containing activation minus deactivation points. Note that we apply a
% gaussian filter to the raw input data.
% Save path: 'basepath/output/stimuli_files/'

if nargin < 1
    basepath = 'data/subjects';
end
% get a list of subjects
subjects=dir([basepath '/*']);

for s=1:length(subjects) % loop over the subjects
    % skip dot and dotdot folders (if using macos or linux)
    if(strcmp(subjects(s).name(1),'.'))
        continue;
    end
    
    % Data loading
    data=load_subj([basepath '/' subjects(s).name],2);
    
    resmat = reconstruct_painting(data);
    
    % Zusammenführen der Bilddaten zu demselben Label
    reize(:,:,1) = resmat(:,:,10) + resmat(:,:,18) + resmat(:,:,20) + resmat(:,:,22); % neutral
    reize(:,:,2) = resmat(:,:,2) + resmat(:,:,6) + resmat(:,:,21) + resmat(:,:,23); %anger
    reize(:,:,3)= resmat(:,:,3) + resmat(:,:,5) + resmat(:,:,12) + resmat(:,:,24); %disgust
    reize(:,:,4)= resmat(:,:,4) + resmat(:,:,7) + resmat(:,:,13) + resmat(:,:,17); % happy
    reize(:,:,5)= resmat(:,:,8) + resmat(:,:,15) + resmat(:,:,19) + resmat(:,:,25); %sadness
    reize(:,:,6)= resmat(:,:,9) + resmat(:,:,11) + resmat(:,:,14) + resmat(:,:,16); %fear
    reize(:,:,7)= resmat(:,:,1); %ground state
    
    % store result
    save(['output/stimuli_files/' subjects(s).name '_preprocessed.mat'],'resmat')
    save(['output/stimuli_files/' subjects(s).name '_reize.mat'],'reize')
    
end
end

