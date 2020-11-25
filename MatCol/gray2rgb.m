function rgb = gray2rgb(gray,color)

    bwsize = size(gray);
    zero = zeros(bwsize);

    if(strcmp(color,'red'))
        rgb = cat(3,gray,zero,zero);
    elseif (strcmp(color,'green'))
        rgb = cat(3,zero, gray,zero);
    elseif (strcmp(color,'blue'))
        rgb = cat(3,zero, zero, gray);
    end
                
    
%     rgb = zeros(bwsize(1),bwsize(2),3);
%     rgb(bw==1)=255;   %  setting red pixels 255
%     rgb(:,:,2) = rgb(:,:,1);   %  setting green pixels 255
%     rgb(:,:,3) = rgb(:,:,1);    %  setting blue pixels 255
% 
%     rgb = im2uint8(rgb);

    
    