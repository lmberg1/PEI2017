function graphCMT(cmtcode, component)
% graphCMT(cmtcode, component)
%
% graphs the filtered earthquake signal from a given CMT code from the 
% CMT catalogue
%
% INPUT: 
% 
% cmtcode        earthquake identifier from CMT catalogue (e.g.
%                'C201607292118A')
% component      component of seismic data desired; either X, Y, or Z.
%                defaults to Z
% 
% OUTPUT:
%
% graph of time series data for the earthquake (markers for event time, 
% love wave arrival, and rayleigh wave arrival)
%
% EXAMPLES:
%
% graphCMT('C201607292118A')-- graphs the earthquake that occurs on July
%                              29, 2016 at 21:18
%
%
% Last modified by lmberg@princeton.edu on 07/26/2017


% figure directory name
dirfig=fullfile('/home/lmberg/internship/matlab','figures');

% default values
defval('cmtcode', 'C201701220430A')
defval('component', 'Z');

CMT = cmtsol(cmtcode);           %get CMT data
evtTime = datestr(CMT.DateTime); %time of event in UTC
%find wave arrival times for love and rayleigh waves (given in dates in
%string format)
stla = 40.346;
stlo = -74.655;
[love, rayleigh] = surfaceWaveArrival(CMT.Lat, CMT.Lon, stla, stlo, ...
    evtTime);

%get the merged data for an hour before and hour after surface wave
%arrivals
startdate = datestr(addtodate(datenum(love), -1, 'hour'));
enddate = datestr(addtodate(datenum(rayleigh), 1, 'hour'));
if day(startdate) ~= day(enddate) %check corner case: interval spans 2 days
    [t1, data1] = getMergedSeismicData(year(startdate), ...
        month(startdate), day(startdate), hour(startdate), 0, component);
    [t2, data2] = getMergedSeismicData(year(enddate), ...
        month(enddate), day(enddate), 0, hour(enddate), component);
    data = cat(1, data1, data2);
    t2 = t2 + t1(length(t1)) + 0.01;
    t = cat(2, t1, t2);
else
    [t, data] = getMergedSeismicData(year(startdate), month(startdate), ...
        day(startdate), hour(startdate), hour(enddate), component);
end
 
%display message if no data for the event
if isempty(data)
    disp("No data available for this event")
    return
end

%set up figure
figure;
orient landscape
hax = axes;
hold on
box on

%calculate seconds for event time, love wave arrival, and rayleigh wave 
%arrival 
t1 = getSeconds(evtTime, startdate);       %event time
t2 = getSeconds(love, startdate) -t1;      %love arrival
t3 = getSeconds(rayleigh, startdate) - t1; %rayleigh arrival
t = t - t1;                                %center time around event time 
t1 = 0;

%remove mean and apply bandpass filter to data before plotting
f1 = 0.01;    %lower frequency bandpass corner
f2 = 0.1;     %upper frequency bandpass corner
window = 120;
filteredData = cleanData(data, f1, f2);
dataLabel = char("Filtered " + component + " Data");
plot(t, filteredData, 'k', 'DisplayName', dataLabel)
height = get(hax, 'YLim');

%add lines and patches to mark important features of the graph (event time,
%rayleigh arrival time, as well as the noise and signal windows for 
%calculating the signal to noise ratio
line([0 0], height, 'Color', 'r', 'DisplayName', 'Event Start Time')
xevt = [(t1) (t1 + window) (t1 + window) (t1)];
yval = [height(1) height(1) height(2) height(2)];
patch(xevt, yval, 'r', 'DisplayName', 'Noise Window', 'FaceAlpha', 0.25,...
    'EdgeColor', 'none');

% draw rayleigh wave info if Z comp and love wave info if X or Y comp
if strcmp(component, 'Z')
    xrayl = [(t3) (t3 + window) (t3 + window) (t3)];
    line([t3 t3], height, 'Color', 'b', 'DisplayName', ...
        'Rayleigh Wave Arrival')
    patch(xrayl, yval, 'c', 'DisplayName', 'Rayleigh Window', ...
        'FaceAlpha', 0.25, 'EdgeColor', 'none');
else
    xlov = [(t2) (t2 + window) (t2 + window) (t2)];
    line([t2 t2], height, 'Color', 'b', 'DisplayName', 'Love Wave Arrival')
    patch(xlov, yval, 'g', 'DisplayName', 'Love Window', ...
        'FaceAlpha', 0.25, 'EdgeColor', 'none');
end

%calculate and place lines on graph for pwave and swave arrivals (if they 
%exist)
phase = ["P" "S"];
phaseName = ["P Wave" "S Wave"];
color = ['m' 'y' 'c' 'r' 'g' 'b'];
for i = 1:length(phase)
    tp = taupTime([], CMT.Dep, char(phase(i)), 'sta', [40.346 -74.655], ...
        'evt', [CMT.Lat CMT.Lon]);
    if ~isempty(tp)
        line([(t1 + tp(1).time) (t1 + tp(1).time)], height, ...
            'Color', color(i), 'DisplayName', phaseName(i));
    end
end

%set up graph format specifics
xlim([-300 t(end)])
lg = legend('Location','NorthWest');
ttl = sprintf('Event %s; Magnitude %0.2f (Mw)', cmtcode, CMT.Mw);
title(ttl)
labelFilterBand(f1, f2, deblank(CMT.Location));
xlabel("Time (s)")

%Print the figure
print('-dpdf', '-bestfit', ...
    fullfile(dirfig, sprintf('%s_%s_%s', mfilename, cmtcode, component)))

%calculate seconds between the start time of the plot and the given date
function time = getSeconds(date, startdate)

%calculate span of hours (checking if hours are from different days)
if day(date) ~= day(startdate)
    hours = (24 - hour(startdate)) + hour(date);
else
hours = hour(date) - hour(startdate);
end

%time in seconds between two dates
time = hours * 3600 + minute(date) * 60 + second(date);

