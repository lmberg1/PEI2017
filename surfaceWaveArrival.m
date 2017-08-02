function [loveArrival, rayleighArrival] = surfaceWaveArrival(evla, evlo,...
    stla, stlo, evtTime)
% [loveArrival, rayleighArrival] = surfaceWaveArrival(evtLat, ...
%    evtLon, staLat, staLon, evtTime)
%
% gives the arrival times for waves propogating from a specified latitude
% and longitude
%
% INPUT: 
% 
% evla          latitude of event
% evlo          longitude of event
% stla          latitude of station
% stlo          longitude of station
% evtTime       time of event in datestr format (e.g. 20-Oct-2016 00:09:26)
% 
% OUTPUT:
%
% loveArrival   the arrival time of the love waves to princeton station
%               (given in datestr format)
%
% loveArrival   the arrival time of the rayleigh waves to princeton station
%               (given in datestr format)
% EXAMPLES:
%
% [loveArrival, rayleighArrival] = surfaceWaveArrival(13.44, -44.81, 40.35,
%                                  -74.66, '20-Oct-2016 00:09:26')
% gives the arrival times at princeton for an earthquake occuring at 
% (13.44, -44.81) on October 20th, 2016
% 
% Use in conjunction with Frederick J. Simons' program: grcdist.m
%
% Last modified by lmberg@princeton.edu on 07/27/2017

rayleighWaveSpeed = 3.5;    %approximate speed of rayleigh wave (km/s)
loveWaveSpeed = 4.5;        %approximate speed of love wave (km/s)

evtTime = datenum(evtTime); %change event time to date number

%calculate distance between station and event epicenter
epiDist = grcdist([evlo evla], [stlo stla]);

%find arrival times, rounding to nearest second
travelTimeLove = round(epiDist / loveWaveSpeed);
loveArrival = datestr(addtodate(evtTime, travelTimeLove, 'second'));
travelTimeRayleigh = round(epiDist / rayleighWaveSpeed);
rayleighArrival = datestr(addtodate(evtTime,travelTimeRayleigh, 'second'));
    