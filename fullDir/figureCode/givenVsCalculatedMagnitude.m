% get all CMT data
fnames = dir('CMTFILES/*.mat');
fnum = length(fnames);

% initialize
Mw = nan([1 fnum]);
mag = nan([1 fnum]);

% go through each file, finding the magnitude of the earthquake and 
% epicentral distance from princeton seismometer
for i = 1:fnum
    fname = fnames(i).name;
    [~, name, ~] = fileparts(fname);
    CMT = cmtsol(name);
    
    Mw(i) = CMT.Mw; 
    mag(i) = CMT.Magnitude;
end

% plot data
figure;
scatter(mag, Mw);
title("Given Magnitude vs. Calculated Moment Magnitude");
xlabel("Given CMT Magnitude (Ms)")
ylabel("Moment Magnitude (Mw)")