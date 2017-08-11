function SNR = getSNR_var(cmtcode, f1, f2)
% SNR = getSNR_var(cmtcode, f1, f2)
%
% computes the signal to noise ratio for the given event after rotating the
% X and Y components of the data by the back azimuth
%
% INPUT: 
% 
% cmtcode        the cmtcode of a given seismic event given by the CMT
%                catalogue
% f1             lower bandpass corner frequency (defaults to 0.01 hz)
% f2             upper bandpass corner frequency (defaults to 0.1 hz)
% 
% OUTPUT:
%
% SNR            a 1x3 cell with the signal to noise ratios for the X, Y,
%                and Z components. SNR{1} corresponds to the X component, 
%                SNR{2} with the Y, and SNR{3} with the Z.
%
% EXAMPLES:
% 
% SNR = getSNR_var('C201609031202A')
%
% Last modified by lmberg@princeton.edu on 08/03/2017


% set default value of f1 to 0.01 hz and f2 to 0.1 hz
defval('cmtcode', 'C201701220430A')
defval('f1', 0.01);
defval('f2', 0.1);

SNR = {[] [] []}; % initialize

% get information about the event from the cmtcode
CMT = cmtsol(cmtcode);
evtTime = datestr(CMT.DateTime);
stlo = -74.655;
stla = 40.346;
evlo = CMT.Lon;
evla = CMT.Lat;
[love, rayleigh] = surfaceWaveArrival(evla, evlo, stla, stlo, evtTime);
bazim = gc_bazim(evla, evlo, stla, stlo);

% find beginning and end of noise and signal windows
w = 120; % window size (s)
noiseWindow1 = evtTime;
noiseWindow2 = datestr(addtodate(datenum(evtTime), w, 'second'));
rayWindow1 = rayleigh;
rayWindow2 = datestr(addtodate(datenum(rayleigh), w, 'second'));
lovWindow1 = love;
lovWindow2 = datestr(addtodate(datenum(love), w, 'second'));

% get the noise data for those windows
noiseData = getAnyMergedData(noiseWindow1, noiseWindow2);
xNoiseData = cleanData(noiseData{1}, f1, f2);
yNoiseData = cleanData(noiseData{2}, f1, f2);
zNoiseData = cleanData(noiseData{3}, f1, f2);

% get the signal data for those windows
rayData = getAnyMergedData(rayWindow1, rayWindow2); % rayleigh waves
zRayData = cleanData(rayData{3}, f1, f2);
lovData = getAnyMergedData(lovWindow1, lovWindow2); % love waves
xLovData = cleanData(lovData{1}, f1, f2);
yLovData = cleanData(lovData{2}, f1, f2);

% rotate the x and y data in direction of the signal if the data exists
if ~isempty(xNoiseData) && ~isempty(yNoiseData) && ...
        length(xNoiseData) == length(yNoiseData)
    [xNoiseData, yNoiseData] = rotatevec(xNoiseData, yNoiseData, bazim);
end

if ~isempty(xLovData) && ~isempty(yLovData) && ...
        length(xLovData) == length(yLovData)
    [xLovData, yLovData] = rotatevec(xLovData, yLovData, bazim);
end

% variance of x component (using love waves)
if ~isempty(xNoiseData) && ~isempty(xLovData)
    SNR{1} = var(xLovData)/var(xNoiseData);
else
    SNR{1} = nan;
end

% variance of y component (using love waves)
if ~isempty(yNoiseData) && ~isempty(yLovData)
    SNR{2} = var(yLovData)/var(yNoiseData);
else
    SNR{2} = nan;
end

% variance of z component (using rayleigh waves)
if ~isempty(zNoiseData) && ~isempty(zRayData)
    SNR{3} = var(zRayData)/var(zNoiseData);
else
    SNR{3} = nan;
end




