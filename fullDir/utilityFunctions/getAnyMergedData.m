function mergedData = getAnyMergedData(startdate, enddate)
% mergedData = getAnyMergedData(startdate, enddate)
%
% returns the seismic data recorded by the princeton seismometer from the
% given start date to the given end date
%
% INPUT: 
% 
% startdate      date of beginning of time series data, either in datestr
%                or datetime format (e.g. '12-Jun-2017 12:16:38')
% component      date of end of time series data, either in datestr
%                or datetime format (e.g. '12-Jun-2017 14:34:15')
% 
% OUTPUT:
%
% mergedData     the compiled seismic data between start date and end date,
%                unfiltered. If there is no data for the given range of 
%                dates, mergedData will be an empty 1x3 cell array.           
%                Otherwise, mergedData will be a 1x3 cell array where each
%                cell holds the data for one component; the indices 1, 2,
%                and 3 correspond to the components X, Y, and Z
%                respectively.
%
% EXAMPLES:
%
% startdate = '12-Jun-2017 12:16:38';
% enddate = '12-Jun-2017 14:34:15';
% mergedData = getAnyMergedData(startdate, enddate);
%               

startDatenum = datenum(startdate); %convert startdate to date number
mergedData = {[] [] []};           %initialize output
%missingHours = 0;
delta = 0.01;

%calculate number of hours between the two dates, rounded up
startHour = [year(startdate) month(startdate) day(startdate) ...
    hour(startdate) 0 0];
endHour = [year(enddate) month(enddate) day(enddate) hour(enddate) 0 0];
hrs = ceil(etime(endHour, startHour)/3600);

%for each hour between the start and end date
for h = 0:hrs
    currentDate = datestr(addtodate(startDatenum, h, 'hour'));
    [~, data] = getSeismicData(year(currentDate), ...
        month(currentDate), day(currentDate), hour(currentDate));
    %make sure data exists for that hour
    if ~strcmp(data, "0")
        
        %for each component of the data (x, y, and z)
        for cmp = 1:3
            cmpdata = data{cmp};
            
            %make sure component data is not missing
            if ~strcmp(cmpdata, "missing")
                
                %check if data is only in one hour and cut hour accordingly
                if hrs == 0
                    end_time = length(cmpdata)*delta - delta;
                    t = 0:delta:end_time;
                    
                    t1cut = etime(datevec(startdate), startHour);
                    t2cut = etime(datevec(enddate), endHour);
                    cutIndices = (t >= t1cut & t <= t2cut);
                    cmpdata = cmpdata(cutIndices); %cut data
                
                %cut time sequence for the first hour to the specified 
                %startdate
                elseif h == 0
                    end_time = length(cmpdata)*delta - delta;
                    t = 0:delta:end_time;
                    
                    tcut = etime(datevec(startdate), startHour);
                    cutIndices = (t >= tcut);
                    cmpdata = cmpdata(cutIndices); %cut data

                %cut time sequence for the last hour to the specified 
                %enddate
                elseif h == hrs
                    end_time = length(cmpdata)*delta - delta;
                    t = 0:delta:end_time;

                    tcut = etime(datevec(enddate), endHour);
                    cutIndices = (t <= tcut);
                    cmpdata = cmpdata(cutIndices); %cut data
                end
                
                %merge the component data together with the other hours
                mergedData{cmp} = cat(1, mergedData{cmp}, cmpdata);
            end
        end
    %{    
    %display the hours that don't exist    
    else 
        missingHours = missingHours + 1;
        if missingHours == 1
            fprintf('%s\n', 'Data for the following hours do not exist:');
        end
        currentHour = datestr([year(currentDate) month(currentDate) ...
            day(currentDate) hour(currentDate) 0 0]);
        fprintf('%s\n', currentHour);
        %}
    end
end

%display how many hours out of the total hours don't exist
%{
if missingHours ~= 0
    fprintf('\n%d / %d hours without data\n', missingHours, (hrs + 1));
end
%}
    
        
