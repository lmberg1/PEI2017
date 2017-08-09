function graphCMT(cmtcode, cmp)
% graphCMT(cmtcode, component)
%
% graphs the filtered earthquake signal from a given CMT code from the 
% CMT catalogue
%
% INPUT: 
% 
% cmtcode        earthquake identifier from CMT catalogue (e.g.
%                'C201607292118A')
% cmpname        component of seismic data desired; either 'X', 'Y', or 'Z'
%                defaults to 'Z'
% 
% OUTPUT:
%
% graph of time series data for the earthquake (markers for event time, 
% love wave arrival, and rayleigh wave arrival)
%
% EXAMPLES:
%
% graphCMT('C201607292118A', 'Z')-- graphs the Z component of the 
%                                   earthquake that occured on July
%                                   29, 2016 at 21:18
%
%
% Last modified by lmberg@princeton.edu on 07/26/2017


% figure directory name
dirfig=fullfile('/home/lmberg/internship/matlab','figures');

% default values
defval('cmtcode', 'C201701220430A')
defval('cmp', 3);

% find component name based on component number
if cmp == 1
    cmpname = "X";
elseif cmp == 2
    cmpname = "Y";
elseif cmp == 3
    cmpname = "Z";
else
    error(['Please specify valid component: 1, 2, or 3 for the'...
        '''X'', ''Y'', or ''Z'' components'])
end

CMT = cmtsol(cmtcode);           %get CMT data
evtTime = datestr(CMT.DateTime); %time of event in UTC

%find wave arrival times for love and rayleigh waves (given in dates in
%string format)
stla = 40.346;
stlo = -74.655;
[love, rayleigh] = surfaceWaveArrival(CMT.Lat, CMT.Lon, stla, stlo, ...
    evtTime);

%get the merged data from the event time to an hour after rayleigh arrival
startdate = evtTime;
enddate = datestr(addtodate(datenum(rayleigh), 1, 'hour'));
mergedData = getAnyMergedData(startdate, enddate);
data = mergedData{cmp};

% create time array 
delta = 0.01; % time between samples
endtime = length(data)*delta - delta;
t = 0:delta:endtime;
 
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
t1 = 0;                                            % event time  
t2 = etime(datevec(love), datevec(evtTime));       % love arrival
t3 = etime(datevec(rayleigh), datevec(startdate)); % rayleigh arrival  \

%remove mean and apply bandpass filter to data before plotting
f1 = 0.01;    %lower frequency bandpass corner
f2 = 0.1;     %upper frequency bandpass corner
window = 120;
filteredData = cleanData(data, f1, f2);
h = plot(t, filteredData, 'k');
set(get(get(h,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
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
if strcmp(cmpname, 'Z')
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
%{
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
%}

%set up graph format specifics
xlim([-300 t(end)])
if strcmp(cmpname, 'Z') && t3 < mean(xlim())
    lgloc = 'SouthEast';
elseif ~strcmp(cmpname, 'Z') && t2 < mean(xlim())*3/4
    lgloc = 'SouthEast';
else
    lgloc = 'NorthWest';
end
legend('Location', lgloc);
ttl = sprintf('Event %s; Magnitude %0.2f (Mw)', cmtcode, CMT.Mw);
title(ttl)
txt = sprintf('%s Component\n%02.2f - %02.2f HZ\n%s', cmpname, f1, f2, ...
    deblank(CMT.Location));
placeLabel(txt, 'NorthEast');
xlabel("Time (s)")

%Print the figure
%
print('-dpdf', '-bestfit', ...
    fullfile(dirfig, sprintf('%s_%s_%s', mfilename, cmtcode, cmpname)))
%}