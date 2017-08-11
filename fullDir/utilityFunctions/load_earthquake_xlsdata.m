%Given an excel filename, downloaded from usgs website, tranfers important
%data about the earthquakes given in the file into a structure
function edata = load_earthquake_xlsdata(filename)

%load data from excel file
[numeric, txt] = xlsread(filename);
dim = size(numeric);
nRows = dim(1);

%organize data into structure with data headers as fields
edata.time = txt(2:nRows, 1);
edata.latitude = numeric(2:nRows, 1);
edata.longitude = numeric(2:nRows, 2);
edata.depth = numeric(2:nRows, 3);
edata.mag = numeric(2:nRows, 4);
edata.magType = txt(2:nRows, 6);
edata.nst = numeric(2:nRows, 6);
edata.gap = numeric(2:nRows, 7);
edata.dmin = numeric(2:nRows, 8);
edata.rms = numeric(2:nRows, 9);
edata.net = txt(2:nRows, 11);
edata.id = txt(2:nRows, 12);
edata.place = txt(2:nRows, 14);
edata.type = txt(2:nRows, 15);
edata.horizontalError = numeric(2:nRows, 15);
edata.depthError = numeric(2:nRows, 16);
edata.magError = numeric(2:nRows, 17);



