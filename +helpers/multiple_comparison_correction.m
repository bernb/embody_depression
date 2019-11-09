function t_thres = multiple_comparison_correction(data, subject_count)
% Input: Data for FDR testing
% Output: 
% t_thres: t threshold for assumption of independence or positive
% correlation
% t_thres_no_assump: t threshold for no assumption about correlation

data(~isfinite(data)) = [];   % getting rid of anomalies due to low number of demo subjects (ie no variance)

df=subject_count-1;    % degrees of freedom
P = 1-cdf('T',data,df);  % p values
[pID, ~] = helpers.FDR(P,0.05);             % BH FDR
t_thres = icdf('T',1-pID,df);      % T threshold, indep or pos. correl.

end

