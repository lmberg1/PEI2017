%gets names of all CMT files saved
fnames = dir('../MATFILES/*.mat');
fnum = length(fnames);

%initialize date array
dates = datetime([],[],[],[],[],[]);

%for each file, find date and magnitude of event
for i = 1:fnum
    fname = fnames(i).name;
    [~, name, ~] = fileparts(fname);
    CMT = cmtsol(name);
    date = datestr(CMT.DateTime);
    dates(i) = date;
    Mw(i) = CMT.Mw;
end

%plot the event time against the moment magnitude
fig = figure;
scatter(dates, Mw)
ttl = sprintf("Event Time vs. Magnitude of Earthquake");
title(ttl)
xlabel("Date")
ylabel("Moment Magnitude (Mw)")
    