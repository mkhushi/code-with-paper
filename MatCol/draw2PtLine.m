% This function will linear indexes to draw a straight HORIZONTAL or Perpendicular line though a point at given angle 
% xcoords and ycoords are the end points of the line
% Example
% index = drawAngledLine(bwmask, [100 100], 100, 0, 'horizontal'); 
% bwmask(index) = 1;  
% [xcoords1(1),ycoords1(1)] is alwasy in 1st quadrant if angle is +ve and in 2nd quandrant if angle is -ve
% can be plotted by plot(xcoords1(1),ycoords1(1), '.g', 'MarkerSize',10)
function index  = draw2PtLine(bwmask, point1, point2)

xcoords = [point1(1)  point2(1)];
ycoords = [point1(2)  point2(2)];

[r,c] = size(bwmask);              %# Get the image size
xcoords(xcoords>c)=c;               % to stop going over the image
xcoords(xcoords<1)=1;
ycoords(ycoords<1)=1;
ycoords(ycoords>r)=r;
rpts = linspace(xcoords(1),xcoords(2) ,1000);   %# A set of row points for the line
cpts = linspace(ycoords(1), ycoords(2),1000);   %# A set of column points for the line
index = sub2ind([r c],round(cpts),round(rpts));  %# Compute a linear index

% bwmask(index) = 0;    