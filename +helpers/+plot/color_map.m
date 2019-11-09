function color_map = color_map(max_value, threshold, num_colors)
%COLOR_MAP Create color map based on threshold, so that values inside
%[-threshold, threshold] appear black.

% proportion of non significant colors
non_sig = round((threshold/max_value) * num_colors);
hotmap=hot(num_colors-non_sig);
coldmap=flipud([hotmap(:,3) hotmap(:,2) hotmap(:,1) ]);
color_map=[
    coldmap
    zeros(2*non_sig,3);
    hotmap
    ];
end

