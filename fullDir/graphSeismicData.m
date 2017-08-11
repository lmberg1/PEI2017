function graphSeismicData(fpath, f1, f2) 
% graphSeismicData(fpath, f1, f2) 
%
% reads in a SAC file from the specified file path and plots the
% seismogram, either filtered or unfiltered
%
% INPUT: 
% 
% fpath          file path to the desired SAC file
% f1             the lower corner bandpass frequency to filter data
% f2             the upper corner bandpass frequency to filter data
%
%
% Last modified by lmberg@princeton.edu on 07/26/2017

% default values
defval('fpath', 'II.BFO.00.BHZ.M.2017.163.122838.SAC')
defval('f1', 0.01)
defval('f2', 1)

% make sure path exists
if  ~exist('fpath', 'file')
    disp('File path specified does not exist')
    return;
else
    % get name of file
    fpath = char(fpath);
    [~, name, ~] = fileparts(fpath);

    % load data from specified time
    [header, data] = load_sac(fpath);

    % create time array, which will be the same for each component
    delta = header.delta;
    start_time = header.b;
    end_time = header.e;
    t = start_time:delta:end_time; 

    % graph data from each component
    figure;
    subplot(2, 1, 1)
    plot(t, data);
    title(name);
    xlabel("Time (s)")

    % filter each component and graph the result
    fs = 100; % sample rate
    order = 2;
    passes = 1;
    filter = bp_bu_co(data, f1, f2, fs, order, passes);
    subplot(2, 1, 2)
    plot(t, filter)
    filtTxt = sprintf('%02.2f-%02.2f HZ', f1, f2);
    placeLabel(filtTxt, 'NorthWest')
    title(name);
    xlabel("Time (s)");
end

    









