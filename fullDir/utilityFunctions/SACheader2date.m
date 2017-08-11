function date = SACheader2date(header)
% date = SACheader2date(header)
%
% Returns the date of an event from the SAC header
%
% INPUT:
%
% header       the header of a SAC file (I use load_sac to get the header)
%
% OUTPUT:
%
% date         the date of the event in datestr format
%
% Last modified by lmberg@princeton.edu, 07/27/2017


Y = header.nzyear;       
julianDay = header.nzjday;  % julian day

% check for leap year
if (Y / 4 ~= 0 && julianDay > 59)
    julianDay = julianDay + 1;
end

% find date      
D = day(julianDay);
M = month(julianDay);
H = header.nzhour;
MN = header.nzmin;
S = header.nzsec;
date = datestr([Y M D H MN S]);

    