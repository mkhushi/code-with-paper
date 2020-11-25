% if two cells / nuclei joined together decide whether to coun them one or two 
% cut apart if a section is less than quarter of minor axis
function bwfinal = segmentROI (bwmask)

bwfinal = zeros(size(bwmask));

% bw = imerode(bw, ones(3,3)) ~= imdilate(bw,  ones(3,3)); % alternate to bwperim

[L num] = bwlabel(bwmask);
s =  regionprops(L, 'BoundingBox','Centroid','Orientation','MajorAxisLength', 'MinorAxisLength' );

 for i=1:length(s)
    bw = bwmask;
    bw(L ~= i) = 0;
    bw = bwperim(bw,8); 
    [~, xcoords1, ycoords1] = drawAngledLine(bwmask, s(i).Centroid, s(i).MajorAxisLength/2, s(i).Orientation, 'horizontal'); 
    [~, xcoords2, ycoords2] = drawAngledLine(bwmask, s(i).Centroid, s(i).MajorAxisLength*0.3, s(i).Orientation, 'horizontal'); 
    [~, xcoords3, ycoords3] = drawAngledLine(bwmask, [xcoords1(1) ycoords1(1)], s(i).MinorAxisLength/2, s(i).Orientation, 'Perpendicular'); 
    [~, xcoords4, ycoords4] = drawAngledLine(bwmask, [xcoords2(1) ycoords2(1)], s(i).MinorAxisLength/2, s(i).Orientation, 'Perpendicular'); 
 
    xx = [ xcoords3(1),        xcoords4(1),       xcoords4(2),     xcoords3(2)];
    yy = [ ycoords3(1),        ycoords4(1),       ycoords4(2),     ycoords3(2)];
    BW = roipoly(bw,xx,yy);
    bw(BW) = 0;
    % to draw ROI on other half
    [~, xcoords3, ycoords3] = drawAngledLine(bwmask, [xcoords1(2) ycoords1(2)], s(i).MinorAxisLength/2, s(i).Orientation, 'Perpendicular'); 
    [~, xcoords4, ycoords4] = drawAngledLine(bwmask, [xcoords2(2) ycoords2(2)], s(i).MinorAxisLength/2, s(i).Orientation, 'Perpendicular'); 
    xx = [ xcoords3(1),        xcoords4(1),       xcoords4(2),     xcoords3(2)];
    yy = [ ycoords3(1),        ycoords4(1),       ycoords4(2),     ycoords3(2)];
    BW = roipoly(bw,xx,yy);
    bw(BW) = 0;
 
    bw = getLargest(bw, 2);         % remove any small unwanted small objects
        
    st =  regionprops(bw, 'PixelList' );
    st1 = st(1).PixelList; st2  = st(2).PixelList;   %indexes of points
    %Return only one line of row for all smallest distances
    [d, idx] = pdist2(st1, st2, 'euclidean', 'Smallest', 1); % i holds indexes
    minDist = min(d(:));
    minDindex = find(d==minDist);     % important: this is row index for st2 matrix
    % To confirm distance/points picked up 
    minIindex = idx(minDindex);           % important: this is row index for st1 matrix
    point1 = st2(minDindex,:); point2 = st1(minIindex,:);
    % figure, imshow(bw) ;
    % hold on
    % plot(point1(1),point1(2), '.g', 'MarkerSize',10)
    % plot(point2(1),point2(2), '.r', 'MarkerSize',10)
    % hold off
    %% Draw a perpendicular line norm to long axis passing though a give point
    bw(L==i)=1;     %back to solid one object
%     index = drawAngledLine(bw, point1, min(d(:)), s(i).Orientation, 'Perpendicular') ;
%     bw(index) = 0;  
%     % running once doesnot break apart the ROI so run again 
%     index = drawAngledLine(bw, [point1(1)+1 point1(2)], s(i).MinorAxisLength/2, s(i).Orientation, 'Perpendicular'); 
    if (minDist < s(i).MinorAxisLength/4 )
        bwzero = false(size(bw));
        index  = draw2PtLine(bwmask, point1, point2);
        bwzero(index) = 1;  
        bwzero = imdilate(bwzero,  ones(5,5));
        bw(bwzero) = 0;
%     index  = draw2PtLine(bwmask, [point1(1)+1 point1(2)-1], [point2(1)+1  point2(2)+1]);
%     bw(index) = 0;  
    end
    bwfinal = bwfinal ~= bw;  % keep adding masked bw to bwfinal
    
 end
 
