function [detectionTime] = time2detect(depth, latitude, longitude)
staLat = "40.346 ";       %princeton station latitude
staLon = "-74.655";       %princeton station longitude
d = num2str(depth);       %event depth
lat = num2str(latitude);  %event latitude
lon = num2str(longitude); %event longitude

%create the taup command to find travel times for S waves
command = strcat("taup_time -ph S -h ", d, " -sta ", staLat, staLon, ...
    " -evt ", lat, " ", lon, " -time");
command = char(command);

%get travel times
[status, detectionTime] = system(command);
detectionTime = str2num(detectionTime);