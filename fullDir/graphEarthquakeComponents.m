function [t, data] = graphEarthquakeComponents(year, month, day, hour)
%create date string of given date
date = datestr([year month day hour 0 0]);  

%find paths to each of the files
paths = pathToFiles(year, month, day, hour);

%load data from each component and graph it
colors = ['b', 'g', 'r'];
component = ['X', 'Y', 'Z'];
figure(1)
for i = 1:3
    [header{i}, data{i}] = load_sac(paths(i));
    delta = header{i}.delta;
    start_time = header{i}.b;
    end_time = header{i}.e;
    t{i} = [start_time:delta:end_time];
    subplot(3, 1, i); 
    plot(t{i}, data{i}, 'color', colors(i));
    title(date + " (" + component(i) + " Component)");
    xlabel("Time (s)")
end

%filter each component
fs = 100; %sample rate
figure(2)
for i = 1:3
    filter{i} = bp_bu_co(data{i}, 0.1, 2, fs, 2, 1);
    subplot(3, 1, i)
    plot(t{i}, filter{i}, 'color', colors(i))
    title(date + " (" + component(i) + " Component)");
    xlabel("Time (s)");
end
    
    









