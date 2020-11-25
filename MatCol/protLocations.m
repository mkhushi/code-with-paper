%%Reading Image
%In this code at the end an algo is applied to count only colocalisation that is more than 20%


function bwProtLoc = protLocations(I, bwMask, contSTDMult)

    H = padarray(2,[2 2]) - fspecial('gaussian' ,[5 5],2);  %Gaussian High-Pass Filter sharpening  - not used any more
    %       bwTemp = imfilter(bwTemp,H);    
    
    [L, num] = bwlabel(bwMask);
    maskZero = zeros(size(bwMask));  
    bwred = maskZero ;
    for i=1:num
            % i=17;
        bwTemp = bwMask;
        bwTemp( L ~= i ) = 0;
        %s = regionprops(bwbwTemp, 'BoundingBox'); figure, imshow(t, []);
        %bwTemp = imcrop(I, s.BoundingBox);       
                    % imshow(Temp); showLabels(bwTemp);
%       bwTemp = imfilter(bwTemp,H);    
        %m = mean(bwTemp(:)) + 1.5 * std(double(bwTemp(:)));  %take average and add  standard daviation
        bwTemp = double(I) .* bwTemp;
       
        t = bwTemp(bwTemp>0);       % converts into vector with values > 0
        m = ceil(sum(t)/nnz(t)) + contSTDMult * ceil(std(t));        
%         m = sum(bwTemp(:))/nnz(bwTemp(:)) + contSTDMult * std(bwTemp(:));

        if m>250 m=250; end
        %bwTemp = uint8(I).* uint8(bwTemp); 
        %whos bwTemp;
        bwTemp = uint8(bwTemp);
        bwTemp = im2bw(bwTemp, m / 255);
        bwred = bitor(bwred, bwTemp);
                %     figure, imshow(bwred);
    end
            
% Second interation of clean-up - to reduce size of big protein dots
            bwredB = maskZero;
            [l n] =   bwlabel(bwred);
            s = regionprops(l, 'Area');
            for i=1:n
                if s(i).Area > 30       % area more than 30 pixels
                    bwred (l==i) = 0;   % Big dots removed from here
                    bwredB (l==i) = 1;  % Big dots added in this binary image
                end
            end
            
             bwred = imdilate(bwred, strel('disk',1));
            t = uint8(I) .* uint8(bwredB);
%             t = imfilter(t,H); 
             
            [l n] =   bwlabel(bwredB);
    for i=1:n
                % i = 5;
                bwTemp = bwredB;
                bwTemp( l ~= i ) = 0;                
%                 s = regionprops(bwbwTemp, 'BoundingBox');
%                 bwTemp = imcrop(t, s.BoundingBox);               
                %m = mean(bwTemp(:)) + 1.5 * std(double(bwTemp(:)));  %take average and add 1 standard daviation
                bwTemp = double(t) .* bwTemp;
                
                m = sum(bwTemp(:))/nnz(bwTemp(:)) ;
                if m>250 m=250; end
                bwTemp = uint8(bwTemp); 
                bwMask = im2bw(bwTemp, m / 255);
                %bwMask = (bwTemp>m) == 1;
                bwred = bitor(bwred, bwMask);
    end     %     figure, imshow(bwred);
            
bwProtLoc = bwred;               
