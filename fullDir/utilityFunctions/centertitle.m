function centertitle(xlim, ylim, ttl)
% check if limits are datetime / duration
if isdatetime(xlim)
    numDays = range(xlim)/24;
    x = hours(numDays/2);
elseif isdatetime(ylim)
    numDays = range(xlim)/24;
    x = hours(numDays/2);
%centers a title on current plot
xrange = range(xlim);
yrange = range(ylim);
x = xlim(1) + xrange/2;
y = ylim(2) + yrange/100;
keyboard
title(ttl, 'Position', [x y]);
