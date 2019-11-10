cg_path = '/data/subjects/CG';
m_path = './data/subjects/MDDm';
nm_path = './data/subjects/MDDnm';
emotion_labels = [...
    "neutral"
    "anger"
    "disgust"
    "happy"
    "sadness"
    "fear"
    "ground state"
    ];

[~, cg_data] = preprocess_data(cg_path);
[t_data, t_threshold] = calc_embody_t_values(cg_data);
helpers.plot.data(t_data, emotion_labels, t_threshold);

[~, m_data] = preprocess_data(m_path);
[t_data, t_threshold] = calc_embody_t_values(m_data);
helpers.plot.data(t_data, emotion_labels, t_threshold);


[~, nm_data] = preprocess_data(nm_path);
[t_data, t_threshold] = calc_embody_t_values(nm_data);
helpers.plot.data(t_data, emotion_labels, t_threshold);



% cg_m_diff = cg_data - m_data;
% [t_data, t_threshold] = calc_embody_t_values(cg_m_diff);
% 
% cg_nm_diff = cg_data - nm_data;
% nm_m_diff = nm_data - m_data;
% m_nm_diff = m_data - nm_data;

