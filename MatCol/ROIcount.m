%%Reading Image
%In this code at the end an algo is applied to count only colocalisation that is more than 20%


 function ROIcount(fname, resultfile, bwred, bwgreen, bwoverlap, bwMask)
%% This script counts how many colocalisation are there in each ROI and writes output in a file

    [L, num] = bwlabel(bwMask);
    s = regionprops(L, 'Centroid');

    for i=1:length(s)
%         i=37;
        bw = bwMask;
        bw(L~=i)=0;
        bwoverlapred = bitand(bwred,bw);
        [~, numred] = bwlabel(bwoverlapred);
        
        bwoverlapgreen = bitand(bwgreen,bw);
        [~, numgreen] = bwlabel(bwoverlapgreen);

        bwoverlapT = bitand(bwoverlap, bw);
        [~, numoverlap] = bwlabel(bwoverlapT);
            
        
        [fileid, errmsg] = fopen(resultfile,'a');
        if fileid < 0 
            fprintf('Error opening file: %s\n', errmsg);
            return
        else
            fprintf(fileid,'%s\t%d\t%d\t%d\t%d\n',fname,i,numred,numgreen,numoverlap);
            fclose(fileid);
        end
    end
              
