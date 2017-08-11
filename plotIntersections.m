function [num1, num2, numIntersect] = plotIntersections(data1, data2, newFig)
% [num1, num2, numIntersect] = plotIntersections(data1, data2)
%
% plots the intersecting and non-intersecting points contained within two
% pieces of data
%
% INPUT
% 
% data1          a matrix where the first row is x data, the second row is
%                y data, and an optional third row is marker size data
% data2          a matrix where the first row is x data, the second row is
%                y data, and an optional third row is marker size data
% newFig         1 if a new figure should be created for the data, 0 if the
%                plot should be added to the current figure
%
% OUTPUT
%
% num1           the number of unique points from data1
% num2           the number of unique points from data2
% numIntersect   the number of intersecting points
%
%
% Last modified by lmberg@princeton.edu on 08/11/2017


% defval
defval('data1', [(1:5); (6:10); [20 20 20 20 20]])
defval('data2', [[1 3 2 4 5]; [6 7 2 9 10]; [20 20 20 20 20 ]])
defval('newFig', 1)

% make sure dimensions of the matrices agree
dim1 = size(data1);
numRow1 = dim1(1);
dim2 = size(data2);
numRow2 = dim2(1);
if numRow1 ~= numRow2
    error('data1 and data2 must have the same number of row vectors');
end

% get the x, y, and z data for each matrix
x1 = data1(1, :);
y1 = data1(2, :);
x2 = data2(1, :);
y2 = data2(2, :);
if numRow1 == 3
    z1 = data1(3, :);
    z2 = data2(3, :);
end

% create figure if desired
if newFig == 1
    figure;
end

% find intersecting points
intersectPts1 = intersect(data1([1 2], :)', data2([1 2], :)', 'rows')';
intersectRows1 = ismember(data1([1 2], :)', intersectPts1', 'rows')';
intersectPts2 = intersect(data2([1 2], :)', data1([1 2], :)', 'rows')';
intersectRows2 = ismember(data2([1 2], :)', intersectPts2', 'rows')';

% plot intersecting points as magenta
scatter(intersectPts1(1, :), intersectPts1(2, :), z1(intersectRows1), ...
    'MarkerEdgeColor', 'm')
hold on;

% plot unique points from data1 as cyan
scatter(x1(~intersectRows1), y1(~intersectRows1), z1(~intersectRows1), ...
    'MarkerEdgeColor', 'c')

% plot unique points from data2 as green
scatter(x2(~intersectRows2), y2(~intersectRows2), z2(~intersectRows2), ...
    'MarkerEdgeColor', 'g')

% set return values
num1 = length(x1(~intersectRows1));
num2 = length(x2(~intersectRows2));
numIntersect = length(intersectPts1(1, :));
    






