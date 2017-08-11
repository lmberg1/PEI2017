function snr = soft2snr(s, t, t1, t2, dt, method)
% snr=SOFT2SNR(s,t,t1,t2,Dt,meth)
%
% Calculates a signal-to-noise ratio of a time series
%
% INPUT:
%
% s       A time series of values, same length as t
% t       The times at which the values are quoted
% t1      A point in time contained within t
% t2      A second point in time contained within t
% dt      A window length of time
% method  1 Variance based
%         2 Maximum absolute value based
%
% OUTPUT:
%
% snr    The signal-to-noise ratio according to this definition
%
% Last modified by lmberg@princeton.edu, 07/27/2017

if exist('s', 'var') && strcmp(s, 'demo1')
    [header, s] = load_sac('II.BFO.00.BHZ.M.2017.163.122838.SAC');
    delta = header.delta;
    t = 0:delta:(length(s)*delta - delta);
    evtTime = headerToDate(header);
    [~, rayleigh] = surfaceWaveArrival(header.evla, header.evlo, ...
        header.stla, header.stlo, evtTime);
    dt = 60;
    t1 = dt;
    t2 = etime(datevec(rayleigh), datevec(evtTime)) + 2*dt;
    method = 1;
end
    
% set default values
defval('s', rand([1 100]));
defval('t', [0:(length(s) - 1)]);
defval('dt', round(length(s)/20));
defval('t1', dt);
defval('t2', t(end) - dt);
defval('method', 1);
defval('plotornot', 1);

% Make sure the time series data are rightly dimensionalized
s = s(:);
t = t(:);
if length(t)~=length(s)
   error('Wrong length')
end

% get signal and noise windows
tnoise1 = t1 - dt/2;   % start of noise window
tnoise2 = t1 + dt/2;   % end of noise window
tsignal1 = t2 - dt/2;  % start of signal window
tsignal2 = t2 + dt/2;  % end of signal window
tnoise = t >= tnoise1 & t < tnoise2;
noise = s(tnoise);
tsignal = t >= tsignal1 & t < tsignal2;
signal = s(tsignal);

% calculate signal to noise ratio based on the method
if method == 1
    snr = var(signal) / var(noise);
else
    snr = max(abs(signal)) / max(abs(noise));
end

    
