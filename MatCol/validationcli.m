%  Author: Matloob Khushi
%   Examples: Windows 
%   validationcli('Z:\Guest\mkhushi\ProteinColocalisation\MatCol\Benchmarking images\','tmr',2, 'tmg', 2, 'medfilt', [3,3],'wiener', [5,5], 'roi', 1, 'savemask', 0)
%  Linux/Unix:
% Leading slash (Unix) or back slash (Windows) is mandatory

function varargout = matcolcli(dirpath,varargin)

%% Parsing inputs
Wiener=''; MedFilt=''; RemoveBorder='';
ROI=0;      % if you want to count overlap in each ROI, change it to 1 else 0 for image-based total colocalisation
vargs = varargin;
nargs = length(vargs);
names = lower(vargs(1:2:nargs));
values = vargs(2:2:nargs);
validnames = {'tmr', 'tmg', 'medfilt', 'wiener', 'removeborder', 'roi', 'savemask'};    
for name = names
   validatestring(name{:}, validnames);
end
TMRi = strmatch('tmr', names);  %this is index of TMR
TMR =  values{TMRi};
TMGi = strmatch('tmg', names);  %this is index of TMG
TMG =  values{TMGi};
MedFilti = strmatch('medfilt', names);
if ~isempty(MedFilti)
    MedFilt = values{MedFilti};
end
Wieneri = strmatch('wiener', names);
if ~isempty(Wieneri)
    Wiener = values{Wieneri};
end
RemoveBorderi = strmatch('removeborder', names);
if ~isempty(RemoveBorderi)
    RemoveBorder = values{RemoveBorderi};
end
ROIi = strmatch('roi', names);
if ~isempty(ROIi)
    ROI = values{ROIi};
end
SaveMaski = strmatch('savemask', names);
if ~isempty(SaveMaski)
    SaveMask = values{SaveMaski};
end
% warning('Input must be a string');
if (strcmp(dirpath,''))
    error('Input path must be provided.');
    return;
end 

%%
% lastLetter = dirpath(length(dirpath):length(dirpath));
% if(~strmatch(lastLetter ,'/') || ~strmatch(lastLetter ,'\'))
%     dirpath = strcat(dirpath,'/');
% end    
files = dir( fullfile(dirpath,'*.tif') );

p = mfilename('fullpath');
[folder, name, ext] = fileparts(p);

    resultfile = strcat(dirpath, 'results.txt');
    [fileid, errmsg] = fopen(resultfile,'w');
    if fileid < 0 
        fprintf('Error opening file: %s\n', errmsg);
        return
    else
        if (ROI==1)
            fprintf(fileid, 'FileName\t#ROI\tRedSpots\tGreenSpots\tOverlaps\n');
        else            
            fprintf(fileid, 'FileName\tRedSpots\tGreenSpots\tOverlaps\n');
        end
    end
    fclose(fileid);

for x=1:numel(files)

    fname = files(x).name;
    im = imread( fullfile(dirpath, fname) );
    if(ndims(im)<3)
        error( strcat(fname,' is not a RGB image, please select an appropriate image.'));
        return;
    end
    red = im(:,:,1);
    green = im(:,:,2);
    blue = im(:,:,3);
    
    bwmask = getAutoMaskROI(blue);           
    
     if ~isempty(MedFilt)
        redP = medfilt2(red, MedFilt);   % remove salt and pepper noise by median filter
        greenP = medfilt2(green, MedFilt);
    end
    if ~isempty(Wiener)
        redP = wiener2(redP, Wiener);
        greenP = wiener2(greenP, Wiener);
    end
    
    if ~isempty(RemoveBorder)            
       bwmask = imclearborder(bwmask, 8);       % 8 means also remove objects that touches on the courners
    end   
    
    dRedP = double(redP) ;
    dGreenP = double(greenP);
    m = mean(dRedP(:)) + TMR * std(dRedP(:));        
    bwred = im2bw(redP, m / 255);
    m = mean(dGreenP(:)) + TMG * std(dGreenP(:));        
    bwgreen = im2bw(greenP, m / 255);
    
    bwoverlap = bitand(bwred,bwgreen);
    

    [~, numred] = bwlabel(bwred);
    [~, numgreen] = bwlabel(bwgreen);
    [~, numoverlap] = bwlabel(bwoverlap);
    
    
    if (ROI==1)
        ROIcount(fname, resultfile, bwred, bwgreen, bwmask);
    else
        [fileid, errmsg] = fopen(resultfile,'a');
        if fileid < 0 
            fprintf('Error opening file: %s\n', errmsg);
            return
        else
            fprintf(fileid,'%s\t%d\t%d\t%d\n',fname,numred,numgreen,numoverlap);
            fclose(fileid);
        end
    end
    
    if (SaveMask==1)
        bwcellRGBO = cellRGBO(bwred, bwgreen, bwmask);
        imwrite(bwcellRGBO, strcat(dirpath, fname,'_Mask.jpg'));
    end
end






