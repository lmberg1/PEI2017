function filteredData = filterSection(section, fs, low, high)
%filters the given section of data with a bandpass filter for any number of
%filter sets

defPasses = 1;    %default passes
defnPoles = 2;    %default number of poles
n = length(low);  %how many filter bands 

%for each filter band, filter the data
for j = 1:n
    filteredData{j} = bp_bu_co(section, low(j), high(j), fs, ...
    defPasses, defnPoles);
end
       