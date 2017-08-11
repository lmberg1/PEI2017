function [time, cut] = cutGraph(data, delta, cutTimes)
%splits the graph into sections based on the given cutTimes
n = length(cutTimes) - 1;
index = 1;

for i = 1:n
    time{i} = [cutTimes(i):delta:cutTimes(i+1) - delta];
    size = length(time{i});
    cut{i} = data(index:index + size - 1);
    index = index + size;
end
