function mergeSeismicData(year, month, day, startHour, endHour, cmpName)
% mergeSeismicData(year, month, day, startHour, endHour, num)
%
% Graphs the seismic date from the time range given in the input.
%
% INPUT: 
% 
% year           year of desired data (2016 or 2017)
% month          month of desired data (some months do not have data)
% day            day of desired data
% startHour      beginning hour (hours go from 0 to 23 and are in UTC)
% endHour        end hour (graph will not include data from this hour, but
%                will end at this hour)
% component      the desired component of seismic data; either X, Y, or Z
% 
% OUTPUT:
%
% graph of merged seismic data from the given time interval
%
% EXAMPLES:
%
% mergeSeismicData(2017, 6, 12, 12, 14, 1) -- plots the time series data
%                                             from June 12, 2017 12:00 -
%                                             14:00 in figure 1

startdate = datetime([year month day startHour 0 0]);

defval('cmpName', 'Z'); %default component to Z (vertical)

%get the merged data
[t, mergedData] = getMergedSeismicData(year, month, day, startHour, ...
    endHour, cmpName);

%check that there is data for the specified time and date
if ~isempty(mergedData)

    %graph the unfiltered merged data
    figure;
    subplot(2, 1, 1)
    plot(t, mergedData, 'k')
    ttl = sprintf('%s - %02d:00:00', startdate, endHour);
    title(ttl)
    xlabel("Time (s)")
    compname = char(cmpName + " Data");
    legend(compname, 'Location', 'SouthEast')
    %graph the filtered merged data
    fs = 100;
    low = 0.01;
    high = 2;
    subplot(2, 1, 2)
    filteredMergedData = bp_bu_co(mergedData, low, high, fs, 2, 1);
    plot(t, filteredMergedData, 'k')
    title(ttl)
    xlabel("Time (s)")
    legend(compname, 'Location', 'SouthEast')
    labelFilterBand(low, high)
else
    disp("There is no data available for the given time interval")
end


