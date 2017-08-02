function plotDataOutagesCalendarYear(filename)
% function plotDataOutagesCalendarYear(filename)
%
% plots data outages by year. Blue corresponds to full data coverage for
% that day. If a day is pink, it does not have full data coverage. The
% darker the pink, the less coverage. White corresponds to days not in the
% calendar year. 
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

%open and read file containing information about the data outages
defval('filename', 'hourlyDataOutages.txt')
fid = fopen(filename, 'r');
A = textscan(fid, '%s %s %f\n');
nhours = length(A{1}) + 1;

%initialize variables
currentMonth = month(datetime(A{1}{1}), 'name');
C = ones([5 7 3]);  %3D color array (RGB)
red = ones(7, 5);   %red color array (1st dimension of C)
green = red;        %green color array(2nd dimension of C)
blue = red;         %blue color array (3rd dimension of C)

count = 1; %month counter
fig = figure;

%for every day in the file
for i = 1:24:nhours
    if i ~= nhours
        yymmdd = datetime(A{1}{i});
        mo = month(yymmdd, 'name');
        dd = day(yymmdd);
    end
    
    %once all data from a month has been read, graph it
    if ~strcmp(mo, currentMonth) || i == nhours
        
        %make a new graph once a whole year has been graphed
        if count > 12
            ttl = char('2016 Data Outages');
            text(-14, -16, ttl)
            fig = figure;
            count = 1;
        end
        
        %set color array to the different colors and graph the image
        C(:, :, 1) = red';
        C(:, :, 2) = green';
        C(:, :, 3) = blue';
        subplot(3, 4, count)
        im = image(0.5, 1.5, C, 'AlphaData', 0.75);
        title(currentMonth + " " + currentYear)
        yticks([0:1:5])
        xticks([1:1:7])
        grid on
        orient landscape
        
        %reset variables
        count = count + 1;    
        blue = ones(7, 5);
        red = blue;
        green = blue;
    end
    
    %exit loop once all hours have been graphed
    if i == nhours
        break
    end
    
    %loop through each hour of the current day, adding up the statuses of 
    %data (1 if data is present, 0 if not)
    status = 0;
    for h = 0:23
        status = status + A{3}(i + h);
    end 
    
    perc = status/24; %percentage of day covered (w/out outages)
    blue(dd) = perc;  %set percent blue to percent of day covered
    green(dd) = 0;    %set green to zero
    
    %if day is complete, color is only blue. If day is not complete, fill
    %red color array as well
    if perc ~= 1
        red(dd) = perc;
    else
        red(dd) = 0;
    end
    
    currentMonth = mo;
    currentYear = year(yymmdd);
end
