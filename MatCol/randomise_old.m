%% randomize old script this script does not check if randomly shuffled dot landed on already taken spot.
function bw = randomise(in, mask)

[L, num] = bwlabel(mask);
s = regionprops(L, 'PixelIdxList');
ids=[];
for i=1:num
    ids = cat(1,ids, s(i).PixelIdxList);
end
n = numel(ids);      %total size of ids matrix

bw=zeros(size(in));     % template for randomised image

[L, num] = bwlabel(in);
s = regionprops(L, 'PixelIdxList', 'Centroid');
count = 0;          % count of how many times random algo failed because some pixel of the dot gone outside of boundry.
 for i=1:num
        try
            randNo = round(rand(1) * n);       %get a random number up to numel(ids)
            randIndex = ids(randNo);          %get a random value from ids matrix
            centroids = round(s(i).Centroid);
            centId = sub2ind(size(in),centroids(:,2),centroids(:,1));

            diffId = randIndex - centId;
            pId = s(i).PixelIdxList + diffId ;
            if ( pId > numel(in) ~= pId < 1 )
                pId = pId( pId < numel(in) );       % remove any id > then size of image
                pId = pId( pId > 1 );       % remove any id < 0 i.e. negative numbers 
            end    
            bw(pId) = 1;
        catch ME
            count = count +1 ;
        end
    end

%% To visualise randomisation:
% % figure, imshow(in)
% e = edge(mask,'canny');
% rgb = imoverlay(bw,e,[0 1 0]);      % my UDF in commonfunc folder
% figure, imshow(rgb)

