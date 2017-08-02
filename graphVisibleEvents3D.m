function graphVisibleEvents3D(filename, cutoff)
% graphVisibleEvents3D(filename, cutoff)
%
% plots the visible events on a graph of epicentral distance (degrees)
% against the moment magnitude. Different layers of the graph correspond to
% different frequency bands with which the data were filtered
%
% INPUT
% 
% filename      the name of the file to be graphed
% cutoff        the signal to noise ratio cutoff for a point to be plotted.
%               Default is 5
%
% Use with Frederik J. Simon's code: grcdist.m, defval.m
%
% Last modified by lmberg@princeton.edu on 08/01/2017

% initialize variables
defval('filename', 'zAmpRotSNR.txt')
defval('cutoff', 5); 
cmp = filename(1);    % component of data (x, y, or z)
meth = filename(2:4); % method of finding snr (Amp or Var)
graphNum = 1;
height = [2 1 0];

% find all of the CMT information in the .mat files
fid = fopen(filename, 'r');
formatSpec = '%s\t%f\t%f\t%f\n';
A = textscan(fid, formatSpec, 'HeaderLines', 1);
eventNum = length(A{1});
fclose(fid);

% station latitude and longitude
stlo = -74.655;
stla = 40.346;

figure;
subplot(8, 12, [1:10 13:22 25:34 37:46 49:58 61:70 73:82 85:94])
% for each frequency band (0.01-0.1hz, 0.1-1hz, and 0.5-2hz)
for index = [2 3 4]
    n = 0; % index of visible event arrays

    % go through each file
    for i = 1:eventNum
        cmtcode = A{1}{i};
        CMT = cmtsol(cmtcode);
        SNR = A{index}(i);

        % only save point if signal to noise ratio is greater than cutoff
        if SNR > cutoff
            n = n + 1;
            Mw(n) = CMT.Mw; 
            [~, degrees(n)] = grcdist([CMT.Lon CMT.Lat], ...
                [stlo stla]);
            snr(n) = SNR;
        end
    end

    % create scatter plot of the collected data 
    h = height(graphNum);
    zval = zeros([1 n]) + h;
    c = scatter3(degrees, Mw, zval, snr);
    txt = char("n = " + n);
    text(15, 8.85, h, txt, 'Rotation', 14, 'VerticalAlignment', 'cap');
    hold on
    if graphNum == 1
        maxSNR = max(snr);
        minSNR = min(snr);
    end
    clear Mw degrees snr;
    graphNum = graphNum + 1;
end

% x axis
xticks([0:30:180])
xlim([0 180])
degSym = sprintf('%c', char(176));
xlabel("Distance from Princeton Station (" + degSym + ")")
set(get(gca, 'XLabel'), 'Rotation', 17)
xpos = get(get(get(gca, 'Xaxis'), 'Label'), 'Position');
newPos = [mean(xlim()) xpos(2) xpos(3)/2];
set(get(get(gca, 'Xaxis'), 'Label'), 'Position', newPos);

% y axis
ylim([4 9]);
yticks([4 5 6 7 8]);
ylabel("Moment Magnitude (Mw)")
set(get(gca, 'YLabel'), 'Rotation', -28);
ypos = get(get(get(gca, 'Yaxis'), 'Label'), 'Position');
newPos = [ypos(1) mean(ylim()) ypos(3)/3];
set(get(get(gca, 'Yaxis'), 'Label'), 'Position', newPos);

% z axis
zticks([0 1 2])
zticklabels(["0.50-2.00" "0.10-1.00" "0.01-0.10"])
zlabel('Frequency Band (Hz)')

% title
ttl = sprintf("Visible Earthquakes (" + cmp + " Component; SNR > " + ...
    cutoff + ")");
title(ttl)
pos = get(get(gca, 'Title'), 'Position');
set(get(gca, 'Title'), 'Position', ...
    [pos(1) pos(2) (pos(3) + range(zlim())/25)]);

% planes
set(gca, 'Color', 'none');
patch([0 180 180 0], [4 4 9 9], [0 0 0 0], 'm', 'FaceAlpha', 0.05);
patch([0 180 180 0], [4 4 9 9], [1 1 1 1], 'c', 'FaceAlpha', 0.05);
patch([0 180 180 0], [4 4 9 9], [2 2 2 2], 'y', 'FaceAlpha', 0.05);

% grid lines on planes
for z = [1 2]
    % x grid
    for x = [30:30:150]
        line([x x], ylim(), [z z], 'Color', [0.2 0.2 0.2 0.02]);
    end
    
    % y grid
    for y = [5:8]
        line(xlim(), [y y], [z z], 'Color', [0.2 0.2 0.2 0.02]);
    end
end

box on
orient landscape
hold off

% legend with marker sizes
sp = subplot(8, 12, [12 24]);
set(sp, 'Visible', 'off');
bubsizes = [minSNR round(mean([minSNR maxSNR])) maxSNR];
legentry = cell(size(bubsizes));
for ind = 1:numel(bubsizes)
   b = plot(0, 0,'o', 'markersize', sqrt(bubsizes(ind)), ...
       'MarkerEdgeColor', 'k');
   hold on;
   set(b,'Visible','off')
   legentry{ind} = num2str(bubsizes(ind));
end
hax = gca;
set(hax, 'Visible', 'off')
l = legend(legentry);
set(get(l, 'Title'), 'String', 'SNR')
set(l, 'Position', get(sp, 'Position'))
set(l, 'Color', 'none')

% print to pdf
%{
fname = string(cmp) + string(meth) + "VisibleEarthquakesSNR" + cutoff
print('-dpdf', '-bestfit', fullfile('~/internship/matlab/figures/',...
    sprintf('%s', fname)))
%}