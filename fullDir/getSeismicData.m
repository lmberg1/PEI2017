%returns the headers and data for each component of seismic data for a 
%given data and time. header{1} will correspond to the header of the X
%component, etc.
function [header, data] = getSeismicData(year, month, day, hour)

%find paths to each of the files
paths = pathToFiles(year, month, day, hour);

%set output variables to empty if file does not exist
if strcmp(paths, "missing")
    header = "0";
    data = "0";
%otherwise, get information for each component (in the order of X, Y, Z)
else
    for i = 1:3
        if ~strcmp(paths(i), "missing")
            [header{i}, data{i}] = load_sac(paths(i));
        else
            header{i} = "missing";
            data{i} = "missing";
        end
    end
end