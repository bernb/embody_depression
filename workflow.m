[activation_data, averaged_data] = preprocess_data(basepath);
[t_data, t_threshold] = calc_embody_t_values(averaged_data);
emotion_labels = [...
    "neutral"
    "anger"
    "disgust"
    "happy"
    "sadness"
    "fear"
    "ground state"
    ];
helpers.plot.data(t_data, emotion_labels, t_threshold);