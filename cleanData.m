function cleandata = cleanData(data, f1, f2)
% cleanData = cleanData(data, f1, f2)
%
% cleans up the given vector of data by removing the mean, removing any
% trends, and using a bandpass filter
%
% INPUT: 
% 
% data           a vector
% f1             low bandpass corner frequency (hz)
% f2             high bandpass corner frequency(hz)
% 
% OUTPUT:
%
% SNR            a 1x3 cell with the signal to noise ratios for the X, Y,
%                and Z components. SNR{1} corresponds to the X component, 
%                SNR{2} with the Y, and SNR{3} with the Z.
%
% Use with Frederick J. Simons' program: defval.m
% Also need to have downloaded: rmean.m, rtrend.m, bp_bu_co.m
%
% Last modified by lmberg@princeton.edu on 07/27/2017


%default values for the bandpass corner frequencies
defval('f1', 0.01);
defval('f2', 0.1);

fs = 100;                                           %sampling rate
cleandata = rmean(data);                            %remove mean
cleandata = rtrend(cleandata);                      %remove trend
cleandata = bp_bu_co(cleandata, f1, f2, fs, 2, 1);  %bandpass filter
