%get all of the converted CMT file information
fnames = dir('MATFILES/*.mat');
numfiles = length(fnames); %number of files

%for each file, find the date of the event. If that date corresponds to a 
%date contained in the seismometer data, add the date to a text file
for i = 1:numfiles
    fname = fnames(i).name; %get filename
    [pathstr, cmtcode] = fileparts(fname); %get the cmtcode
    
    %get CMT data
    CMT = cmtsol(cmtcode, fullfile('~', 'Downloads', 'CMTCatalogueData',...
        'allData.ndk'));
    evtTime = datenum(CMT.DateTime);
    
    staLon = -74.655;           %princeton station longitude
    staLat = 40.346;            %princeton station latitude
    rayleighWaveSpeed = 3.5;    %approximate speed of rayleigh wave (km/s)
    loveWaveSpeed = 4.5;        %approximate speed of love wave (km/s)
    
    %calculate time event should be seen on Princeton Seismometer
    epiDist = grcdist([CMT.Lon CMT.Lat], [staLon, staLat]);
    travelTimeLove = round(epiDist / loveWaveSpeed);
    arrivalTimeLove = datestr(addtodate(evtTime, travelTimeLove, 'second'));
    travelTimeRayleigh = round(epiDist / rayleighWaveSpeed);
    arrivalTimeRayleigh = datestr(addtodate(evtTime, travelTimeRayleigh, 'second'));
    dateVecLove = datevec(arrivalTimeLove);
    dateVecRayleigh = datevec(arrivalTimeRayleigh);
    
    if (dateVecLove(4) ~= dateVecRayleigh(4))
        dates = [dateVecLove; dateVecRayleigh];
    else
        dates = dateVecLove;
    end
    dim = size(dates);
    for i = 1:dim(1)
        date = dates(i, :);
        dateString = datestr(date);
        paths = pathToFiles(date(1), date(2), date(3), date(4)); %absolute paths to the data for that date
        %only add date to the file if the data for that date exists
        if ~strcmp(paths, "File does not exist")
            zPath = paths(3);
            if ~ismissing(zPath)
                cmd = strcat("echo """, zPath, """ >> earthquakeFilesZ.txt");
                system (char(cmd));
            end
        end
    end
end
