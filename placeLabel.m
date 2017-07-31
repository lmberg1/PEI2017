function placeLabel(txt, location)
% placeLabel(txt, location)
%
% places a label in the specified corner of the current plot (prettier than
% matlab's text function)
%
% INPUT
%
% txt        a string or character vector
% location   which corner of the graph the label should go on: 'NorthEast', 
%            'NorthWest', 'SouthWest', or 'SouthEast'
%
%
% Last modified by lmberg@princeton.edu on 07/31/2017


% get figure dimension information
ylimit = ylim();
xlimit = xlim();
yrange = range(ylimit);
xrange = range(xlimit);

% find location and alignment of label 
if strcmp(location, 'NorthEast')
    x = xlimit(2) - xrange/80;
    y = ylimit(2) - yrange/70;
    xalign = 'right';
    yalign = 'cap';
elseif strcmp(location, 'NorthWest')
    x = xlimit(1) + xrange/80;
    y = ylimit(2) - yrange/70;
    xalign = 'left';
    yalign = 'cap';
elseif strcmp(location, 'SouthEast')
    x = xlimit(2) - xrange/80;
    y = ylimit(1) + yrange/70;
    xalign = 'right';
    yalign = 'bottom';
elseif strcmp(location, 'SouthWest')
    x = xlimit(1) + xrange/80;
    y = ylimit(1) + yrange/70;
    xalign = 'left';
    yalign = 'bottom';
else
    error(['Please use valid location: ''NorthEast'', ''NorthWest'', ' ...
        '''SouthWest'', or ''SouthEast'''])
end

% place label
text(x, y, char(txt), 'HorizontalAlignment', xalign, ...
    'VerticalAlignment', yalign, 'FontSize', 12)