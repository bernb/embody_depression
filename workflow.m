basepath = 'data/subjects';
[activation_data, averaged_data] = preprocess_data(basepath);
calc_embody_t_values(averaged_data);