function rgb = bw2rgb(bw,color)

    bwsize = size(bw);
    zero = zeros(bwsize);
    rgb = uint8(bw); 
    rgb = rgb .* 255;
    if(strcmp(color,'red'))
        rgb = cat(3,rgb,zero,zero);
    elseif (strcmp(color,'green'))
        rgb = cat(3,zero, rgb,zero);
    elseif (strcmp(color,'blue'))
        rgb = cat(3,zero, zero, rgb);
    elseif (strcmp(color,'white'))
        rgb = cat(3,rgb, rgb, rgb);
    end
                
    
%     rgb = zeros(bwsize(1),bwsize(2),3);
%     rgb(bw==1)=255;   %  setting red pixels 255
%     rgb(:,:,2) = rgb(:,:,1);   %  setting green pixels 255
%     rgb(:,:,3) = rgb(:,:,1);    %  setting blue pixels 255
% 
%     rgb = im2uint8(rgb);

    
    