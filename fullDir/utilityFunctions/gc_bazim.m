function bazim = gc_bazim(evla, evlo, stla, stlo)
% bazim = gc_bazim(evla, evlo, stla, stlo)
%
% Calculate the initial back azimuth from event to station
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
% bazim         back azimuth from event to station (in degrees)
%
% Adapted to MATLAB from Jessica Irving's python program
% 
% Last modified by lmberg@princeton.edu on 07/27/2017


% just reverse order of coordinates for gc_azim to find the back
% azimuth
bazim = gc_azim(stla, stlo, evla, evlo);