function randOverlap = randomise(bwred, bwgreen, mask, numIteration)
    %mask = ~mask;
    mask = imerode(mask, strel('disk', 3));
    [L, num] = bwlabel(mask);
    s = regionprops(L, 'PixelIdxList');
    maskids=[];
    for i=1:num
        maskids = cat(1,maskids, s(i).PixelIdxList);
    end
    randOverlap = [];
    sRed = regionprops(bwlabel(bwred), 'PixelIdxList', 'Centroid');
    sGreen = regionprops(bwlabel(bwgreen), 'PixelIdxList', 'Centroid');
    for i=1:numIteration
         bw1 = randomise2(bwred, sRed, maskids);
         bw2 = randomise2(bwgreen, sGreen, maskids);
         bwoverlap = bitand(bw1,bw2);
         cc = bwconncomp(bwoverlap, 8);          
         randOverlap = cat (2, randOverlap, cc.NumObjects);     
%         figure, imshow(mask); nnz(bw2)
%         figure, imshow(bwred);
        
    end
    
function bw = randomise2(in, s, maskids)


    n = numel(maskids);      %total size of ids matrix
    bw=zeros(size(in));     % template for randomised image
    
    count = 0;          % count of how many times random algo failed - shouldn't happen though.

    for i=1:length(s)
        try
           noOverlap = 1; 
           while noOverlap==1  % loop if new random location has got already a spot                    
%                 rng shuffle;
                randNo = round(rand * n); 
                randIndex = maskids(randNo);          %get a random value from ids matrix
                centroids = round(s(i).Centroid);
                centId = sub2ind(size(in),centroids(:,2),centroids(:,1));

                diffId = randIndex - centId;
                pId = s(i).PixelIdxList + diffId ;
                if ( pId > n ~= pId < 1 )
                    pId = pId( pId < numel(in) );       % remove any id > then size of image
                    pId = pId( pId > 1 );       % remove any id < 0 i.e.negative numbers 
                end
                t = bw(pId);  t=t(t>0);
                
%                 if ismember(1,bw(pId))     % check if the spot taken before - ismember is slow function takes about 40% of execution time
                if ~isempty(t)
                    noOverlap = 1;
                else
                   
                    bw(pId) = 1;
                    break;  % while loop ends
                end                
           end     

            
        catch ME
            count = count +1 ;
        end
    end


%% To visualise randomisation:
% % figure, imshow(in)
% e = edge(mask,'canny');
% rgb = imoverlay(bw,e,[0 1 0]);      % my UDF in commonfunc folder
% figure, imshow(rgb)

            
            