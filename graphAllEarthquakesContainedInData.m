function graphAllEarthquakesContainedInData(filename, column)
% graphs the distance between the epicenter of an earthquake and the 
% princeton seismometer against the moment magnitude of the earthquake, for
% those events which we have in our data.
% The moment magnitude is calculated using the moment tensor from the CMT
% data files.
%
% INPUT
%
% filename      the name of the file to pull data from. The file should be
%               in the format of a column of cmtcodes followed by three 
%               columns of numeric data. The formatSpec can be changed to 
%               read in different formats of text files.
% column        the column of numeric data to be used as the signal to
%               noise ratio, where column 1 is the column of cmtcodes
%
% Use with placeLabel.m, cmtsol.m and Frederik J. Simon's: grcdist.m,
% defval.m
%
% Last modified by lmberg@princeton.edu on 08/02/2017

% default values
defval('filename', 'zAmpRotSNR.txt')
defval('column', 2)

% read the file into A
fid = fopen(filename, 'r');
formatSpec = '%s %f %f %f';
A = textscan(fid, formatSpec, 'HeaderLines', 1);
eventNum = length(A{1});
n = 0;

% station latitude and longitude
stla = 40.346;
stlo = -74.655;

% go through each file, finding the magnitude of the earthquake and 
% epicentral distance from princeton seismometer
for i = 1:eventNum
    cmtcode = A{1}{i};
    CMT = cmtsol(cmtcode);
    SNR = A{column}(i);
    
    % if data exists (SNR is not NAN), save info from that event
    if ~isnan(SNR)
        n = n + 1;
        Mw(n) = CMT.Mw; 
        snr(n) = SNR;
        [~, degrees(n)] = grcdist([CMT.Lon CMT.Lat], [stlo stla]);
    end
end

% create figure
fig = figure;
subplot(4, 6, [1:5 7:11 13:17 19:23])
scatter(degrees, Mw, snr, 'm')
ylim([4.5 9])
ttl = sprintf("All Earthquakes Contained in Data");
title(ttl)
degSym = sprintf('%c', char(176));
xlabel("Distance (" + degSym + ")")
ylabel("Moment Magnitude (Mw)")
txt = "n = " + n;
placeLabel(txt, 'NorthWest');
box on 
orient landscape

% create legend of marker sizes for SNR
sp = subplot(4, 6, [6 12]);
bubsizes = [cutoff floor(mean([min(snr) max(snr)])/25)*25 ...
        ceil(max(snr)/50)*50]; % marker sizes (rounded to nice numbers)
legentry = cell(size(bubsizes));
for ind = 1:numel(bubsizes)
   b = plot(0, 0,'o', 'markersize', sqrt(bubsizes(ind)), ...
       'MarkerEdgeColor', 'm');
   hold on;
   set(b, 'visible', 'off')
   legentry{ind} = num2str(bubsizes(ind));
end
l = legend(legentry);
set(get(l, 'Title'), 'String', 'SNR')
set(l, 'Location', 'NorthEastOutside')
set(sp, 'Visible', 'off')
set(l, 'Position', get(sp, 'Position'))

orient landscape
box on

% print to pdf
%{
print('-dpdf', '-bestfit', fullfile('~/internship/matlab/figures/', ...
    sprintf('%s', 'AllEarthquakesContainedInData')))
%}
