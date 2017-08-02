function plotDataOutagesByMonth(filename)
% plotDataOutagesByMonth(filename)
%
% plots data outages by month. Blue corresponds to full data coverage for
% that day/hour. If a day/hour is pink, it does not have full data 
% coverage. The darker the pink, the less coverage.
% White corresponds to days not in the calendar year. 
%
% INPUT: 
% 
% filename     name of file to get data from. The file should be in a
%              specific format: 1st column - date, 2nd column - hour, 3rd
%              column - 1 if data for that hour is present, 0 if data for
%              that hour is not present
%              (e.g. '01-Jan-2016 00:00:00 1' would make up a line)
%              each line should increment by 1 hour or program will not
%              work properly
% 
% The default text file is available on github of lmberg1 in directory: 
% 'demoFiles'
%
% Last modified by lmberg@princeton.edu on 08/02/2017


% open and read file containing information about the data outages
defval('filename', 'hourlyDataOutages.txt'); 
fid = fopen(filename, 'r');
A = textscan(fid, '%s %s %f\n');
nhours = length(A{1}) + 1;

% initialize variables
currentMonthStr = month(datetime(A{1}{1}), 'name'); % name of current month
C = ones([5 7 3]);       % 3D color array (RGB) for months
red = ones(7, 5);        % red color array (1st dimension of C)
green = red;             % green color array(2nd dimension of C)
blue = red;              % blue color array (3rd dimension of C)
hours = zeros([1 24 3]); % 3D color array (RGB) for hours

% for each day
for i = 1:24:nhours
    if i ~= nhours
        yymmdd = datetime(A{1}{i});
        mo = month(yymmdd, 'name');
        monum = month(yymmdd);
        dd = day(yymmdd);
    end
    
    % once all data from a month has been collected, graph the data
    if ~strcmp(mo, currentMonthStr) || i == nhours
        
        % set color array to the different colors and graph the image
        C(:, :, 1) = red';
        C(:, :, 2) = green';
        C(:, :, 3) = blue';
        
        % graph the data for the month
        figure;
        subplot(6, 1, [1:5 1])
        im = image(0.5, 1.5, C, 'AlphaData', 0.75);
        title(currentMonthStr + " " + currentYear)
        yticks([0:1:5])
        xticks([0:1:7])
        grid on
       
        % graph the data for the hours of the month
        subplot(6, 1, 6)
        % only data for up to June 18th, 2017
        if currentMonth == 6 && currentYear == 2017
            eom = 18;
        else
            eom = eomday(currentYear, currentMonth);
        end
        
        % find the percentage of data covered for each hour by dividing the
        %number of hours collected by the number of hours there should be
        hours = hours./eom;
        
        % if hour is complete, color is only blue. If hour is not complete, 
        % fill red color array as well
        for h = 1:24
            if hours(1, h, 3) ~= 1
                hours(1, h, 1) = hours(1, h, 3);
            end
        end
        
        % make image for hourly data
        image(0.5, 1.5, hours,'AlphaData', 0.75 )
        title("Data Outages for Hours")
        yticks([0:0])
        xticks([0:1:23])
        grid on
        orient landscape
        
        % reset variables for the next month
        blue = ones(7, 5);
        red = blue;
        green = blue;
        hours = zeros([1 24 3]);
    end
    
    % exit loop if all days have been graphed
    if i == nhours
        break 
    end
    
    % for each hour of the day, sum the status of the hour
    sumStatus = 0;
    for h = 0:23
        status = A{3}(i + h);
        sumStatus = sumStatus + status;
        hours(1, h + 1, 3) = hours(1, h + 1, 3) + status;
    end
    
    perc = sumStatus/24; % percentage of each day covered
    blue(dd) = perc;     % set percent blue to percentage of day covered
    green(dd) = 0;       % set green to zero
    
    % if day is complete, color is only blue. If day is not complete, fill
    % red color array as well
    if perc ~= 1
        red(dd) = perc;
    else
        red(dd) = 0;
    end
    
    currentMonthStr = mo;
    currentYear = year(yymmdd);
    currentMonth = monum;
end
