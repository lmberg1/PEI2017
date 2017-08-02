function labelFilterBand(low, high, str)
% labelFilterBand(low, high, location)
%
% places a label in the upper right corner of current figure with bandpass
% filter limits [use placeLabel.m for more versatility in labeling]
%
% INPUT
%
% low          low bandpass filter corner (hz)
% high         high bandpass filter corner (hz)
% str          a string to be placed underneath the filter band label
%              (preferably of short length)
%
% EXAMPLES
%
% labelFilterBand(0.01, 0.1, "MW 5")
%
% Last modified by lmberg@princeton.edu on 07/27/2017


% get figure dimension information
ylimit = ylim();
xlimit = xlim();
yrange = range(ylimit);
xrange = range(xlimit);

% label coordinates 
x = xlimit(2) - xrange/80;
y = ylimit(2) - yrange/70;

% label text
if exist('str', 'var')
    txt = sprintf('%.2f - %.2f Hz\n%s', low, high, str);
else
    txt = sprintf('%.2f - %.2f Hz', low, high);
end

% place label
text(x, y, char(txt), 'HorizontalAlignment', 'right', ...
    'VerticalAlignment', 'cap', 'FontSize', 12)
