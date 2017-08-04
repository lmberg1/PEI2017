function graphDistVsMagVisEvents(filename, option, cutoff, histornot)
% graphDistVsMagVisEvents(filename, option, cutoff, histornot)
%
% plots distance in degrees (between princeton seismeter and event) against
% the moment magnitude for only those events above a certain
% signal to noise threshold
%
% INPUT
% 
% filename      the name of the file to be graphed
% option        an integer between 1 and 3
%               1: frequency band from 0.01 Hz to 0.1 Hz
%               2: frequency band from 0.1 Hz to 1 Hz
%               3: frequency band from 0.5 Hz to 2 Hz
% cutoff        the signal to noise threshold for an event to be considered
%               visible. Defaults to 5
%
%
% histornot     1 if histograms desired, 0 if not
%
% Use with labelFilterBand.m, placeLabel.m, cmtsol.m and Frederik J. 
% Simon's code: grcdist.m, defval.m
%
% Last modified by lmberg@princeton.edu on 08/01/2017


% default values
defval('filename', 'zAmpRotSNR.txt')
defval('option', 1)
defval('cutoff', 5)
defval('histornot', 0)

% figure out which frequency range is desired and initialize variables 
% based on the option chosen
if option == 1
    index = 2;
    f1 = 0.01;
    f2 = 0.1;
elseif option == 2
    index = 3;
    f1 = 0.1;
    f2 = 1;
elseif option == 3
    index = 4;
    f1 = 0.5;
    f2 = 2;
else
    error("Please provide an option from 1 to 3")
end

cmp = filename(1);    % component name (x, y, or z)
meth = filename(2:4); % method name (Amp or Var)

% read the file into A
fid = fopen(filename, 'r');
formatSpec = '%s\t%f\t%f\t%f\n';
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
    
    % only save point if signal to noise ratio is greater than cutoff
    SNR = A{index}(i);
    if SNR > cutoff
        n = n + 1;
        Mw(n) = CMT.Mw; 
        [~, degrees(n)] = grcdist([CMT.Lon CMT.Lat], [stlo stla]);
        snr(n) = SNR;
    end
end

if histornot == 1
    % create scatter plot of the collected data
    figure;
    subplot(5, 7, [1:6 8:13])
    scatter(degrees, Mw, snr, 'm')
    xlim([0 180])
    xticks(0:30:180);
    ylim([4 9]);
    ttl = sprintf("Visible Earthquakes [" + cmp + " Component]");
    title(ttl)
    txt = sprintf('n = %d\nSNR > %d', n, cutoff);
    placeLabel(txt, 'NorthWest');
    labelFilterBand(f1, f2);
    degSym = sprintf('%c', char(176));
    xlabel("Distance from Princeton Station (" + degSym + ")")
    ylabel("Moment Magnitude (Mw)")
    box on
    
    % create legend with size markers
    sp = subplot(5, 7, [7 14]);
    bubsizes = [cutoff floor(mean([min(snr) max(snr)])/25)*25 ...
        ceil(max(snr)/50)*50]; % marker sizes (rounded to nice numbers)
    legentry = cell(size(bubsizes));
    for ind = 1:numel(bubsizes)
       b = plot(0, 0, 'o', 'markersize', sqrt(bubsizes(ind)), ...
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

    % histogram of moment magnitudes
    subplot(5, 7, [22:24 29:31])
    histogram(Mw, 'DisplayStyle', 'stairs')
    title("Histogram of Earthquake Magnitudes")
    xlabel("Moment Magnitude (Mw)")
    ylabel("Number of Occurrences")
    box on

    % histogram of epicentral distances
    subplot(5, 7, [26:28 33:35])
    hold on;
    histogram(degrees, 'DisplayStyle', 'stairs', 'BinWidth', 10);
    title("Histogram of Epicentral Angle")
    xlabel("Distance from Princeton Station (" + degSym + ")")
    ylabel("Number of Occurrences")
    box on
    hold off
    
    meth = meth + "Hist";
    orient landscape
else
    % create scatter plot of the collected data
    figure;
    subplot(4, 6, [1:5 7:11 13:17 19:23])
    scatter(degrees, Mw, snr, 'm')
    xlim([0 180])
    xticks(0:30:180);
    ylim([4 9]);
    ttl = sprintf("Visible Earthquakes [" + cmp + " Component]");
    title(ttl)
    txt = sprintf('n = %d\nSNR > %d', n, cutoff);
    placeLabel(txt, 'NorthWest');
    labelFilterBand(f1, f2);
    degSym = sprintf('%c', char(176));
    xlabel("Distance from Princeton Station (" + degSym + ")")
    ylabel("Moment Magnitude (Mw)")
    box on
    
    % create legend with size markers
    sp = subplot(4, 6, [6 12]);
    bubsizes = [cutoff floor(mean([min(snr) max(snr)])/25)*25 ...
        ceil(max(snr)/50)*50]; % marker sizes (rounded to nice numbers)
    legentry = cell(size(bubsizes));
    for ind = 1:numel(bubsizes)
       b = plot(0, 0, 'o', 'markersize', sqrt(bubsizes(ind)), ...
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
end
%
fname = sprintf('%s%sVisibleEventsSNR%d_%02.2f-%02.2f', ...
    cmp, meth, cutoff, f1, f2);
print('-dpdf', '-fillpage', fullfile('~/internship/matlab/figures/', ...
    sprintf('%s%s', fname, '.pdf')))
%}
