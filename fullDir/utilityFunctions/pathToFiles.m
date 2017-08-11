%returns matrix of directory paths for each of the hours of the specific 
%day given. The rows of the matrix are the different components, in the 
%order of X, Y, Z. 

function path = pathToFiles(year, month, day, hour)
components = ['X' 'Y' 'Z'];

%convert date to day of year (1 - 365)
doy = datenum([year month day]) - datenum([year 1 1]) + 1; 

%path to directory holding data for that day
start_path = strcat("~/seismometer/" + year +"/", ...
    sprintf("%02d/", month, day));

%create filenames for each component at given time
for i = 1:3
    compName = "PP.S0001.00.HH" + components(i);
    pathName = strcat(start_path, compName, ...
        sprintf(".D.%d.%03d.%02d0000.SAC", year, doy, hour));
    
    %make sure file exists before changing value of path
    if exist(pathName, 'file')
        path(i) = pathName;
    else
        path(i) = "missing";
    end
end