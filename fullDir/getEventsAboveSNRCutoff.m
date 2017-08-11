function [cmtcodes, snr] = getEventsAboveSNRCutoff(filename, cutoff, option)
% [cmtcodes, snr] = getEventsAboveSNRCutoff(filename, cutoff, option)
%
% gets the codes and signal to noise ratio for all events above a certain
% snr threshold in a file
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
% OUTPUT
%
% cmtcodes      list of cmtcodes for which the SNR is above the threshold
% snr           list of the SNR for each cmtcode
%
% Last modified by lmberg@princeton.edu on 08/11/2017


% default values
defval('filename', 'zAmpRotSNR.txt');
defval('cutoff', 5);
defval('option', 1);

% find column number corresponding to frequency band of chosen option
if option == 1
    col = 2;
elseif option == 2
    col = 3;
elseif option == 3
    col = 4;
else
    error('Please provide option from 1 to 3')
end

% read file into A
fid = fopen(filename);
formatSpec = '%s\t%f\t%f\t%f\n';
A = textscan(fid, formatSpec, 'HeaderLines', 1);
numfiles = length(A{1});
fclose(fid);

% initialize variables
n = 0;
cmtcodes = "";
snr = nan([1 numfiles]);

for i = 1:numfiles
    cmtcode = A{1}{i};
    
    % find signal to noise ratio for desired frequency band
    SNR = A{col}(i);
    
    % only print to file if SNR is above the cutoff
    if SNR > cutoff
        n = n + 1;
        cmtcodes(n) = cmtcode;
        snr(n) = SNR;
    end
end

% get rid of NaN entries
snr = snr(~isnan(snr));