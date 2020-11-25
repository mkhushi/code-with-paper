function bwMaskROI = getAutoMaskROI(I)
    bwMaskROI = im2bw(I,graythresh(I));      %% ottsu method to convert to b/w
    bwMaskROI = imfill(bwMaskROI,'holes'); bwMaskROI = imfill(bwMaskROI, 'holes');
    out = get_config('areathresh');
    bwMaskROI = bwareaopen(bwMaskROI, out.thresh);           % remove small objects
    bwMaskROI = segmentROI(bwMaskROI);
    
