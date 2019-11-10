% helpers.plot.data(cg_t_data, emotion_labels, cg_t_threshold, 'CG');
% helpers.plot.data(m_t_data, emotion_labels, m_t_threshold, 'MDDm');
% helpers.plot.data(nm_t_data, emotion_labels, nm_t_threshold, 'MDDnm');

helpers.plot.data(cg_m_diff, emotion_labels, cg_m_t_threshold, 'CG - MDDm');
helpers.plot.data(cg_nm_diff, emotion_labels, cg_nm_t_threshold, 'CG - MDDnm');
helpers.plot.data(nm_m_diff, emotion_labels, nm_m_t_threshold, 'MDDnm - MDDm');
helpers.plot.data(m_nm_diff, emotion_labels, m_nm_t_threshold, 'MDDm - MDDnm');