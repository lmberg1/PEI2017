function CMT2txt(filename, cutoff, option)
% CMT2txt(filename, cutoff, option)
%
% prints event information for those events above the signal to noise
% threshold
% INPUT
% 
% filename      the name of the file which has the SNR information
% cutoff        the signal to noise threshold for an event to be considered
%               visible. Defaults to 5
% option        an integer between 1 and 3
%               1: frequency band from 0.01 Hz to 0.1 Hz
%               2: frequency band from 0.1 Hz to 1 Hz
%               3: frequency band from 0.5 Hz to 2 Hz
%
% Last modified by lmberg@princeton.edu on 08/01/2017


% default values
defval('filename', 'zAmpRotSNR.txt');
defval('cutoff', 5);
defval('option', 1);

% find column number corresponding to frequency band of chosen option
if option == 1
    f1 = 0.01;
    f2 = 0.1;
    col = 2;
elseif option == 2
    f1 = 0.1;
    f2 = 1;
    col = 3;
elseif option == 3
    f1 = 0.5;
    f2 = 2;
    col = 4;
else
    error('Please provide option from 1 to 3')
end

cmp = upper(filename(1)); % component (X, Y, or Z)
meth = filename(2:4);     % method (Var or Amp)

% open text file to hold info
txtname = sprintf('cmtInfo%s%s%02.2f-%02.2f.txt', meth, cmp, f1, f2);
fid = fopen(fullfile('textFiles', txtname), 'w');
fprintf(fid, '%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n', "cmtcode", "date", ...
    "time", "lat", "lon", "dep", "mw", "SNR");

% get signal to noise information
snrfid = fopen(filename, 'r');
formatSpec = '%s\t%f\t%f\t%f\n';
A = textscan(snrfid, formatSpec, 'HeaderLines', 1);
numfiles = length(A{1});
fclose(snrfid);

for i = 1:numfiles
    % get CMT information
    cmtcode = A{1}{i};
    CMT = cmtsol(cmtcode);
    
    % find signal to noise ratio for desired frequency band
    index = ismember(A{1}, cmtcode);
    SNR = A{col}(index);
    
    % only print to file if SNR is above the cutoff
    if SNR > cutoff
        fprintf(fid, '%14s\t%s\t%9.4f\t%9.4f\t%6.2f\t%4.2f\t%5.3f\n', ...
            cmtcode, CMT.DateTime, CMT.Lat, CMT.Lon, CMT.Dep, CMT.Mw, SNR);
    end
end

fclose(fid);