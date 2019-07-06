function [t_thres, t_thres_no_assump] = multiple_comparison_correction(data, subject_count)
% Input: Data for FDR testing
% Output: 
% t_thres: t threshold for assumption of independence or positive
% correlation
% t_thres_no_assump: t threshold for no assumption about correlation

% ToDo: Is this really needed? We do not work with 'demo subjects'
data(~isfinite(alltdata)) = [];   % getting rid of anomalies due to low number of demo subjects (ie no variance)

df=subject_count-1;    % degrees of freedom
P = 1-cdf('T',data,df);  % p values
[pID, pN] = FDR(P,0.05);             % BH FDR
t_thres = icdf('T',1-pID,df);      % T threshold, indep or pos. correl.
t_thres_no_assump = icdf('T',1-pN,df) ;      % T threshold, no correl. assumptions

end

