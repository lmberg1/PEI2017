function azim = gc_azim(evla, evlo, stla, stlo)
% azim = gc_azim(evla, evlo, stla, stlo)
%
% Calculate the initial azimuth from event to station
%
% INPUT
%
% evla         event latitude
% evlo         event longitude
% stla         station latitude
% stlo         station longitude
% 
% OUTPUT
%
% azim         azimuth from event to station (in degrees)
%
% Adapted to MATLAB from Jessica Irving's python program
% 
% Last modified by lmberg@princeton.edu on 07/27/2017

% convert coordinates to radians
evla = deg2rad(evla);
stla = deg2rad(stla);
evlo = deg2rad(evlo);
stlo = deg2rad(stlo);

% calculate the azimuth
dLon = stlo - evlo;
y = sin(dLon)*cos(stla);
x = cos(evla)*sin(stla) - sin(evla)*cos(stla)*cos(dLon);
azim = rad2deg(atan2(y,x));
if azim < 0
    azim = azim + 360;
end
    

