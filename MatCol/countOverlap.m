%%Count overlap
% if PercentageOverlap is set than iterate 

function bwOverlap = countOverlap(bwred, bwgreen, percOverlap)
  
    [L, num] = bwlabel(bwred);
    bwOverlap = zeros(size(bwred));  

    for i=1:num
            % i=17;
        bwTemp = bwred;
        bwTemp( L ~= i ) = 0;
        obj1Pixels  = sum(bwTemp(:));
        bwTemp = bitand(bwTemp, bwgreen);
        obj2Pixels = sum(bwTemp(:));
        PercentageOverlap = obj2Pixels / obj1Pixels;
        if (PercentageOverlap>percOverlap)
            bwOverlap = bitor(bwOverlap, bwTemp);
        end
    end            
