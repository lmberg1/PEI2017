function snr=soft2snr(s,t,t1,t2,Dt,meth)
% snr=SOFT2SNR(s,t,t1,t2,Dt,meth)
%
% Calculates a signal-to-noise ratio of a time series
%
% INPUT:
%
% s       A time series of values, same length as:
% t       The times at which the values are quoted
% t1      A point in time contained within t
% t2      A second point in time contained within t
% DT      A window length of time
% meth    1 Variance based
%         2 Maximum absolute value based
%
% OUTPUT:
%
% snr    The signal-to-noise ratio according to this definition
%
% Last modified by lmberg@princeton.edu, 07/27/2017

% Make sure they are rightly dimensionalized
s=s(:);
t=t(:);
if length(t)~=length(s)
   error('Wrong length')
end

% Next 
