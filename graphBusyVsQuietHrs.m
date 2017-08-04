function graphBusyVsQuietHrs(filename, cutoff, option)
% graphBusyVsQuietHrs(filename, cutoff, option)
%
% plots the detection of earthquakes during four different time periods:
% work hours (8 - 5, Mon - Fri), quiet hours (non work hours), work days
% (Mon - Fri), and weekends (Sat - Sun)
%
% INPUT
% 
% filename      the name of the file to be graphed
% cutoff        the signal to noise ratio cutoff for a point to be plotted.
%               Default is 5
% option        an integer from 1 to 3 corresponding respectively to the
%               following frequency bands: 
%               0.01 - 0.10 hz, 0.1 - 1.0 hz, 0.5 - 2.0 hz
%
%
% Last modified by lmberg@princeton.edu on 08/04/2017


% default values
defval('filename', 'zAmpRotSNR.txt')
defval('cutoff', 5); 
defval('option', 1);

% find frequency band based on option
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
    error('Invalid option. Please use integer from 1 to 3');
end

% intialize variables
wHH = zeros([1 24]);         % work hours
qHH = wHH;                   % quiet hours
DD = zeros([1 7]);           % days in week
cmp = upper(filename(1));    % component of data (X, Y, or Z)
meth = filename(2:4);        % method of finding snr (Amp or Var)
n = 0;                       % index of visible event arrays

% get full name of method
if strcmp(meth, "Amp")
    meth = "Amplitude";
elseif strcmp(meth, "Var")
    meth = "Variance";
end

% find all of the CMT information in the .mat files
fid = fopen(filename, 'r');
formatSpec = '%s\t%f\t%f\t%f\n';
A = textscan(fid, formatSpec, 'HeaderLines', 1);
eventNum = length(A{1});
fclose(fid);

    
% go through each file, checking if earthquake is greater the SNR cutoff
for i = 1:eventNum
    cmtcode = A{1}{i};
    CMT = cmtsol(cmtcode);
    SNR = A{index}(i);

    % only save point if signal to noise ratio is greater than cutoff
    if SNR > cutoff
        n = n + 1;

        % get date and put it into eastern time
        date = datestr(CMT.DateTime);
        ESTdate = datestr(addtodate(datenum(date), -4, 'hour'));

        % increment counter for the hour and day arrays
        h = hour(ESTdate);
        d = weekday(ESTdate);
        if ~isweekend(datetime(ESTdate))
            wHH(h + 1) = wHH(h + 1) + 1;
        else
            qHH(h + 1) = qHH(h + 1) + 1;
        end
        DD(d) = DD(d) + 1;
    end
end

figure;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% graph of earthquakes per hour (work days)
subplot(2, 2, 1)
wStart = 8;
wEnd = 17;
haxis = duration(0:23, 0, 0);
workHrInd = haxis >= duration(wStart, 0, 0) & ...
    haxis < duration(wEnd, 0, 0);
workHours = wHH(workHrInd);
quietHours = wHH(~workHrInd);

% work hours
bar(haxis(workHrInd), workHours, 'm')
hold on;

% quiet hours
bar(haxis(~workHrInd), quietHours, 'c', 'DisplayName', ...
    'Quiet Hours (0:00 - 9:00, 5:00 - 23:00)') 

% set graph parameters
xlabel("Hour")
ylabel("Earthquakes Detected")
ymax = max(ylim()) + 1;
ylim([0 ymax])
yticks(1:(ymax - 1))
xticks(duration(0:3:24, 0, 0))
set(gca, 'XTickLabelRotation', 30);
t = title("Earthquakes Observed per Hour [Mon - Fri]");
pos = get(t, 'Position');
set(t, 'Position', [0.58 pos(2) pos(3)])

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% graph of earthquakes per hour (weekends)
subplot(2, 2, 2)
bar(haxis, qHH, 'c')
xlabel("Hour")
ylabel("Earthquakes Detected")
ylim([0 ymax])
yticks(1:(ymax - 1))
xticks(duration(0:3:24, 0, 0))
set(gca, 'XTickLabelRotation', 30);
t = title("Earthquakes Observed per Hour [Sat - Sun]");
pos = get(t, 'Position');
set(t, 'Position', [0.58 pos(2) pos(3)])

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% graph of earthquakes per day
subplot(2, 2, 3)
daxis = 1:7;
workDayInd = daxis > 1 & daxis < 7;
workDays = DD(workDayInd);
weekends = DD(~workDayInd);

% work days
b1 = bar(daxis(workDayInd), workDays, 'm');
set(b1, 'BarWidth', 0.6)
hold on;

% weekends
b2 = bar(daxis(~workDayInd), weekends, 'c');
set(b2, 'BarWidth', 0.1)

% set graph parameters
title("Earthquakes Observed per Day")
ylabel("Earthquakes Detected")
ylim([0 (max(ylim()) + 2)])
xlabel("Day")
xlim([0 8])
xticks([1 2 3 4 5 6 7])
xticklabels(["Sun" "Mon" "Tue" "Wed" "Thu" "Fri" "Sat"])

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% create legend for plot
sp = subplot(2, 2, 4);
b1 = bar(0, 1, 'm');
hold on
b2 = bar(0, 1, 'c');
set(b1, 'Visible', 'off')
set(b2, 'Visible', 'off')
xlim([1 10])
ylim([1 10])
title('Information')
legentry = ["Work Hours/Work Days" "Quiet Hours/Weekends"];
l = legend(legentry);
set(l, 'Location', 'NorthWest')
set(l, 'Orientation', 'Vertical')
set(l, 'TextColor', [0 0 0 1])

% put information about data into figure
text(1.5, 8, sprintf('Signal to Noise Method: %s', meth), ...
    'HorizontalAlignment', 'left', 'VerticalAlignment', 'top')
text(1.5, 7.5, sprintf('Signal to Noise Threshold: %d', cutoff), ...
    'HorizontalAlignment', 'left', 'VerticalAlignment', 'top')
text(1.5, 7, sprintf('Component: %s', cmp), ...
    'HorizontalAlignment', 'left', 'VerticalAlignment', 'top')
text(1.5, 6.5, sprintf('Filter Band: %02.2f - %02.2f HZ', f1, f2), ...
    'HorizontalAlignment', 'left', 'VerticalAlignment', 'top')

% find number of earthquakes detected for different times
numQuake = [sum(workHours) (sum(quietHours) + sum(qHH)) ...
    sum(workDays) sum(weekends)];

% put info into table format
lbls = ["Work Hours" "Quiet Hours" "Work Days" "Weekends"];
rowNames = sprintf('%s\n%s\n%s\n%s\n\n%s', lbls, "Total");
colName = "Earthquakes Detected";
data = sprintf('%s\n%d\n%d\n%d\n%d\n\n%d', colName, numQuake, n);

% put table onto figure
text(1.5, 4.75, rowNames, 'HorizontalAlignment', 'left', ...
    'VerticalAlignment', 'top')
text(6, 5.25, data, 'HorizontalAlignment', 'center', ...
    'VerticalAlignment', 'top')

% get rid of ticks and labels
xticklabels([]);
yticklabels([]);
xticks([]);
yticks([]);

orient landscape

% print to pdf
%{
print('-dpdf', '-bestfit', fullfile('~/internship/matlab/figures/', ...
    'busyVsQuiet'))
%} 
end
