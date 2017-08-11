addpath('../utilityFunctions')

%load data
[header, data] = load_sac('II.BFO.00.BHZ.M.2017.163.122838.SAC');
data = rmean(data);
fs = 20;                     %sample rate
delta = header.delta;        %time increment
sectionTimes = cutTimes(header); %section times of seismogram

%cut the graph into sections determined by wave arrival
[time, cut] = cutGraph(data, delta, sectionTimes);

%graph different sections of the seismogram
figure(1)
n = length(time);
titles = ["Noise" "P Waves" "S Waves and Surface Waves"];
for i = 1:n
    subplot(n, 1, i)
    plot(time{i}, cut{i})
    title(titles(i))
    xlabel("Time (s)")
end

%filter the data
low = [0.1 0.3 1; 0.05 2 5; 0.05 0.3 4];
high = [0.3 1 9; 2 5 9; 0.3 4 9];
for i = 1:3
    figure(i + 1)
    filteredData = filterSection(cut{i}, fs, low(i, :), high(i, :));
    for j = 1:length(filteredData)
        subplot(n, 1, j)
        plot(time{i}, filteredData{j})
        title(titles(i) + " (" + low(i, j) + " - " + high(i, j) + " Hz)")
        xlabel("Time (s)")
    end
end
                      




