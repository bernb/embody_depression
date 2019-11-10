% ToDo:
% raw_to_matrix ohne inflating der pixel:
% maske hat falsche ecken bei z.B. MDDm

% ToDo:
% Differenzen auf Fehler checken: nm - m
% Sieht aus wie inverse von m

cg_path = './data/subjects/CG';
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

if ~exist('cg_data', 'var') || exist('rebuild_data', 'var')
    [~, cg_data] = preprocess_data(cg_path);
    [cg_t_data, cg_t_threshold] = calc_embody_t_values(cg_data);
end

if ~exist('m_data', 'var') || exist('rebuild_data', 'var')
    [~, m_data] = preprocess_data(m_path);
    [m_t_data, m_t_threshold] = calc_embody_t_values(m_data);
end

if ~exist('nm_data', 'var') || exist('rebuild_data', 'var')
    [~, nm_data] = preprocess_data(nm_path);
    [nm_t_data, nm_t_threshold] = calc_embody_t_values(nm_data);
end

cg_m_diff = cg_t_data - m_t_data;
cg_m_t_threshold = helpers.multiple_comparison_correction(cg_m_diff, 30);

cg_nm_diff = cg_t_data - nm_t_data;
cg_nm_t_threshold = helpers.multiple_comparison_correction(cg_nm_diff, 30);

nm_m_diff = nm_data - m_t_data;
nm_m_t_threshold = helpers.multiple_comparison_correction(nm_m_diff, 30);

m_nm_diff = m_t_data - nm_t_data;
m_nm_t_threshold = helpers.multiple_comparison_correction(m_nm_diff, 30);
