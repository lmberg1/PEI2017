function [t, mergedData] = getMergedSeismicData(year, month, day, ...
    startHour, endHour, component)
% [t, mergedData] = getMergedSeismicData(year, month, day, startHour, 
%                                        endHour)
%
% given a date with a range of hours, returns the time and data arrays for 
% the SAC files of earthquake data taken from those hours.
%
% INPUT: 
% 
% year           year of desired data (2016 or 2017)
% month          month of desired data (some months do not have data)
% day            day of desired data
% startHour      beginning hour (hours go from 0 to 23 and are in UTC)
% endHour        end hour (output will not include data from this hour, but
%                will end at this hour)
% component      the desired component of the seismic data; either X, Y, or
%                Z
% 
% OUTPUT:
%
% t              time array for data (in seconds)
% mergedData     time series data of interval from seismometer (unfiltered)
%
% EXAMPLES:
%
% getMergedSeismicData(2017, 6, 12, 12, 14) -- gets the time series data
%                                              from June 12, 2017 12:00 -
%                                              14:00

mergedData = []; 
t = [];

%determine what component of the seismogram is desired
defval('component', 'Z')

if strcmp(component, "x") || strcmp(component, "X")
    index = 1;
elseif strcmp(component, "y") || strcmp(component, "Y")
    index = 2;
elseif strcmp(component, "z") || strcmp(component, "Z")
    index = 3;
else
    error(['Invalid component identifier;' ...
        'please specify component using ''X'', ''Y'', or ''Z''']);
end

%check for corner cases (midnight)
if (endHour == 0)
    endtime = 23;
else
    endtime = endHour - 1;
end

%read in data for each hour and merge it with the other hours
for hour = (startHour:endtime)
    %get header and data from the SAC files for that date
    [~, data] = getSeismicData(year, month, day, hour);
    
    %make sure the data exists; merge it if it does
    if ~strcmp(data, "0")
        compdata = data{index};
        if ~strcmp(compdata, "missing")
            mergedData = cat(1, mergedData, compdata);
        end
    end
end

%check that there is data for the given time
if ~isempty(mergedData)

    %create time array for data series
    delta = 0.01;
    end_time = length(mergedData)*delta - delta;
    t = 0:delta:end_time;
end


