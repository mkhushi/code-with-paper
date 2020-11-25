%%Reading Image
%In this code at the end an algo is applied to count only colocalisation that is more than 20%


 function bwcellRGBO = cellRGBO(bwred, bwgreen, bwoverlap, bwMask)


    [L, num] = bwlabel(bwMask);
%     bwDbl = double(bwMask);   % to write text on binary insertText only works with double
    s = regionprops(L, 'Centroid');
    bwDbl = bw2rgb(bwMask, 'blue');
%     bwDbl(:,:,1);
    
    for i=1:length(s)
%         i=37;
        bw = bwMask;
        bw(L~=i)=0;
        bwoverlapred = bitand(bwred,bw);
        [l, numred] = bwlabel(bwoverlapred);
        
        bwoverlapgreen = bitand(bwgreen,bw);
        [l, numgreen] = bwlabel(bwoverlapgreen);

        bwoverlapT = bitand(bwoverlap,bw);      
        [l, numoverlap] = bwlabel(bwoverlapT);
        
        str = {strcat('#: ',num2str(i)); strcat('R=',num2str(numred)); strcat('G=',num2str(numgreen)); strcat('O=',num2str(numoverlap))};
        
        x = s(i).Centroid(1) - 20;
        y = s(i).Centroid(2) - 25;
        position = [x y; x s(i).Centroid(2) - 10; x s(i).Centroid(2)+5; x s(i).Centroid(2)+20]; % 4 x,y position for text
        bwDbl = insertText(bwDbl, position, str, 'FontSize', 18, 'Font', 'Arial','TextColor', 'white', 'BoxOpacity',0 );
%         bwDbl = insertText(bwDbl, [x y], strcat('#:',num2str(i)), 'FontSize', 18, 'Font', 'Arial' );
%         y = s(i).Centroid(2) - 15;
%         bwDbl = insertText(bwDbl, [x y], strcat('R=',num2str(numred)), 'FontSize', 18, 'Font', 'Arial' );
%         y = s(i).Centroid(2);
%         bwDbl = insertText(bwDbl, [x y], strcat('G=',num2str(numgreen)), 'FontSize', 18, 'Font', 'Arial'  );
%         y = s(i).Centroid(2)+15;
%         bwDbl = insertText(bwDbl, [x y], strcat('O=',num2str(numoverlap)), 'FontSize', 18, 'Font', 'Arial'  );        
    end
%     figure, imshow(bwDbl);
% figure, imshow(bwoverlapgreen);
% showLabels(bwoverlapred)
    
    bwcellRGBO = bwDbl;               
