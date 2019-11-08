[activation_data, averaged_data] = preprocess_data(basepath);
t_data = calc_embody_t_values(averaged_data);
%helpers.plot.data(t_data);