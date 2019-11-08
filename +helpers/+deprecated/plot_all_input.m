function plot_all_input(path)
%PLOT_ALL_INPUT Plot all subjects data (given as sub dirs with csv files)

subjects = dir([path '/*']);
fig = figure;

for s=1:length(subjects)
    % skip dot and dotdot folders (if using macos or linux)
    if(strcmp(subjects(s).name(1),'.'))
        continue;
    end
    subject_data = load_subj([path '/' subjects(s).name],2);
    fig.Name = subjects(s).name;
    
    for r=1:length(subject_data) % loop over stimuli for single subject
        [left_side, right_side] = raw_to_matrix(subject_data(r), true);
        subplot(1,2,1);
        plot_data(left_side, [num2str(r) 'l']);
        subplot(1,2,2);
        plot_data(right_side, [num2str(r) 'r']);
    end
end
end

