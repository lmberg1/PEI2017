function [rotxdata, rotydata] = rotateCMT(cmtcode, plotornot)
%
% rotates the x and y data from a given earthquake event to the back 
% azimuth angle, with the option to plot
%
% INPUT: 
% 
% cmtcode        the cmtcode of a given seismic event given by the CMT
%                catalogue
% plotornot      the value should be 1 if you want a graph of the rotated
%                vs orignal data or 0 if you don't want a graph
% 
% OUTPUT:
%
% rotxdata       the rotated x data for the event
% rotydata       the rotated y data for the event
%
% EXAMPLES:
% 
% [rotxdata, rotydata] = rotateCMT('C201609031202A', 0)
% (rotates data without plotting)


defval('plotornot', 1);

CMT = cmtsol(cmtcode);
evtTime = datestr(CMT.DateTime);
w = 60; %half of signal to noise window size

%arrival of surface waves in datestr format
[~, rayleigh] = surfaceWaveArrival(CMT.Lat, CMT.Lon, evtTime);

%get data from slightly before event time to slightly after rayleigh waves
startWindow = datestr(addtodate(datenum(evtTime), -w, 'second'));
endWindow = datestr(addtodate(datenum(rayleigh), w, 'second'));
data = getAnyMergedData(startWindow, endWindow);
xdata = data{1};
ydata = data{2};

%find back azimuth
staLon = -74.655;
staLat = 40.346;
bazim = gc_bazim(CMT.Lat, CMT.Lon, staLat, staLon);

%rotate the x and y components in the direction of back azimuth
[rotxdata, rotydata] = rotatevec(xdata, ydata, bazim);

%create plot if desired
if plotornot == 1
    figure;
    
    %time array
    delta = 0.01;
    end_time = length(xdata)*delta - delta;
    t = 0:delta:end_time;
    
    %filter, remove mean, and remove trend from data
    f1 = 0.01;
    f2 = 0.1;
    filtxdata = cleanData(xdata, f1, f2);
    filtydata = cleanData(ydata, f1, f2);
    filtrotxdata = cleanData(rotxdata, f1, f2);
    filtrotydata = cleanData(rotydata, f1, f2);
    
    subplot(2, 2, 1)
    plot(t, filtxdata)
    title("Original X Data for Event " + cmtcode);
    
    subplot(2, 2, 3)
    plot(t, filtydata)
    title("Rotated X Data for Event " + cmtcode);
    
    subplot(2, 2, 2)
    plot(t, filtrotxdata)
    title("Original Y Data for Event " + cmtcode);
    
    subplot(2, 2, 4)
    plot(t, filtrotydata)
    title("Rotated Y Data for Event " + cmtcode);
end