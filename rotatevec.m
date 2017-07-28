function [vxr, vyr, maxTheta, maxms] = rotatevec(vx, vy, theta, delta, plotit)
% [vxr, vyr, maxg, maxms] = rotatevec(vx, vy, gama, interval, plotit)
%
% Rotates two vectors by an angle that maximizes their energy on one
% component. 
%
% INPUT: 
% 
% vx            a row/column vector of type double or integer
% vy            a row/column vector of type double or integer with same
%               length as vx
% theta         an angle in degrees which the vectors should be
%               approximately rotated by. The best rotation angle will be
%               picked from a range going from 45 degrees less than theta 
%               to 45 degrees greater than theta
% delta         the change in degrees between each angle tried for
%               rotation. For instance, a delta value of 1 will increment
%               the rotation angle by 1 degree until the full range of 
%               angles has been tried
% plotit        1 if a plot of the original and rotated vectors is 
%               desired, 0 if it is not
% 
% OUTPUT:
%
% vxr           rotated vx vector (transverse component)
% vyr           rotated vy vector (radial component)
% maxTheta      angle in degrees that vx and vy were rotated by to yield
%               the maximal energy on one component
% maxms         the maximal measure of energy on one component
%               corresponding to the chosen rotation angle
%
% EXAMPLES:
% 
% vx = [1 2 3 4 5];
% vy = [1 3 2 4 6];
% [vxr, vyr, maxg, maxms] = rotatevec(vx, vy, 45, 1, 0)
% (rotates vx and vy by the integer angles between 0 and 90 degrees and
% picks the angle yielding the highest energy on one component)
%
% Use with Frederik J. Simons' program: defval.m
%
% Adapted from Anna Brummen's rotatevec.m
% Last modified by lmberg@princeton.edu on 07/27/2017


% set default values
exvector = [0, 0; 1, 1; 2, 2; 3, 3; 4, 4; 5, 5];
defval('vx', exvector(:,1));
defval('vy', exvector(:,2));
defval('theta', 45);
defval('plotit', 0)
defval('delta', 1);

% Make sure they are column vectors
vx = vx(:);
vy = vy(:);

% rename to North and East components
E = vx;
N = vy;

% convert gama into radians
thetaRad = theta*(pi/180);

% degree interval 
di = delta*(pi/180);

if di == 0

    % rotation matrix
    rotMat =[cos(thetaRad) sin(thetaRad); ...                                                                                     
           -sin(thetaRad)  cos(thetaRad)];

    % rotate vectors by rotation matrix
    rv = rotMat*[N'; E'];
    vyr = rv(1, :); %radial
    vxr = rv(2, :); %transverse

    maxTheta = theta;
    maxms = 0 ;

else
 
    % Create a vector filled with all the theta values
    degStart = thetaRad - pi/4;
    degEnd = thetaRad + pi/4;
    thetaVal = (degStart:di:degEnd);

    % Initialize variables that will hold the best rotation information
    msxyBest = -inf;
    vxBest = nan([1 length(vx)]);
    vyBest = nan([1 length(vy)]);

    for i = 1:length(thetaVal)
        % Create the rotation matrix for each value of gama
        thetaCurrent = thetaVal(i);
        rotMat =[cos(thetaCurrent) sin(thetaCurrent); ...
                -sin(thetaCurrent)  cos(thetaCurrent)];

        % rotate the input vectors
        newv = rotMat*[N'; E'];
        vyCurrent = newv(1, :); %radial
        vxCurrent = newv(2, :); %transverse

        % calculate ms value for current rotation
        msxy = abs((mean([vyCurrent.^2 - vxCurrent.^2]) / ...
            mean([vyCurrent.^2 + vxCurrent.^2])));
        
        % if the ms value is higher than the current best, update best
        % variable values
        if msxy > msxyBest
            vxBest = vxCurrent;
            vyBest = vyCurrent;
            maxTheta = rad2deg(thetaCurrent);
            msxyBest = msxy;
        end

    end

    % set return values to best values
    maxms = msxyBest; 
    vxr = vxBest;
    vyr = vyBest;

end

% graph unrotated and rotated vectors if desired
if plotit == 1
    figure(1)
    clf
    plot(vx, vy)
    axis equal
    
    figure(2)
    clf
    plot(vxr, vyr)
    axis equal
end
