function findSNRforCMT(low, high, method)
% findSNRforCMT(low, high, method)
%
% finds the signal to noise ratios for a given band of frequencies for all
% CMTFILES on file, printing to a text file. 
%
% INPUT: 
% 
% low       array of lower bandpass corner frequencies (hz)
% high      array of upper bandpass corner frequencies (hz)
% method    1 for variance based SNR; 2 for amplitude based SNR
%
% EXAMPLES:
%
% findSNRforCMT([0.01 0.5], [0.1 2], 2)
% (creates text file of SNR values for the two frequency bands: 0.01-0.10
% hz and 0.50-2.00 hz)
%
% Use with getSNR_amp.m, getSNR_var.m and Frederik J Simon's code: defval.m
%
% Last modified by lmberg@princeton.edu on 07/26/2017


% default values
defval('low', 0.01); 
defval('high', 0.1);
defval('method', 2)

% variance or amplitude based signal to noise ratio calculation
if method == 1
    methname = 'var';
elseif method == 2
    methname = 'amp';
else 
    error(['Invalid method. Specify method as 1 for variance based SNR'...
        ' and as 2 for amplitude based SNR'])
end

% number of different frequency bands
numFreq = length(low);

% find all CMT files
finfo = dir('~/internship/matlab/CMTFILES/*.mat');
fnum = length(finfo);

% for each frequency
for f = 1:numFreq
    f1 = low(f);
    f2 = high(f);

    % create text file to store the x, y, and z SNRs
    colname = methname + "RotSNR" +  "_" + f1 + "-" + f2 + "HZ";
    txtname = char(colname + ".txt");
    fullname = fullfile('~/internship/matlab/textFiles', txtname);
    fid = fopen(fullname, 'w');
    fprintf(fid, '%s %s %s %s\n', 'cmtcode', 'xSNR', 'ySNR', 'zSNR');

    lim = 250;
    % for each cmtcode
    for i = 1:fnum
        [~, cmtcode] = fileparts(finfo(i).name); % get cmtcode
        
        % get signal to noise ratio based on method chosen
        if strcmp(methname, "var")
            SNR = getSNR_var(cmtcode, f1, f2);
        else
            SNR = getSNR_amp(cmtcode, f1, f2);
        end
        
        % print x, y, and z signal to noise ratios
        fprintf(fid, '%s\t%.3f\t%.3f\t%.3f\n', cmtcode, SNR{1}, SNR{2}, ...
            SNR{3});
        
        % display progress
        if i == lim
            fprintf("Printing completed for %d / %d events\n", i, fnum);
            lim = lim + 250;
        end
           
    end
    fclose(fid);
end
    
