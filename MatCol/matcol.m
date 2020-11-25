function varargout = matcol(varargin)
% matcol MATLAB code for matcol.fig
%      matcol, by itself, creates a new matcol or raises the existing
%      singleton*.
%
%      H = matcol returns the handle to a new matcol or the handle to
%      the existing singleton*.
%
%      matcol('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in matcol.M with the given input arguments.
%
%      matcol('Property','Value',...) creates a new matcol or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before matcol_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to matcol_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help matcol

% Last Modified by GUIDE v2.5 01-Feb-2017 10:28:40

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @matcol_OpeningFcn, ...
                   'gui_OutputFcn',  @matcol_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before matcol is made visible.
function matcol_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to matcol (see VARARGIN) 
% Choose default command line output for matcol
handles.output = hObject;

% Initialise tabs
handles.tabManager = TabManager( hObject );

handles.folder = '';
white=ones(1000);
axes(handles.axesRed); imshow(white); axes(handles.axesbwRed); imshow(white);
axes(handles.axesGreen); imshow(white); axes(handles.axesbwGreen); imshow(white);
axes(handles.axesBlue); imshow(white); axes(handles.axesbwBlue); imshow(white);
% Update handles structure
linkaxes([handles.axesRed, handles.axesGreen, handles.axesbwRed, handles.axesbwGreen,  handles.axesBlue,  handles.axesbwBlue ], 'xy');
guidata(hObject, handles);

% UIWAIT makes matcol wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = matcol_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --------------------------------------------------------------------
function uipushtoolOpen_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to uipushtoolOpen (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% linkaxes([handles.axesRed, handles.axesGreen, handles.axesbwRed, handles.axesbwGreen], 'off');
filter = {'*.tif; *.tiff', 'TIFF Images'};
[flnm, pn, idx] = uigetfile(filter, 'Open images', handles.folder);


if idx == 0     %if cancel exit function
    return;
end

   global im, global red; global green; global blue; global bwmask; global fname; 

    handles.folder = pn;
    fname = strcat(pn,flnm);
    im = imread(fname);
    if(ndims(im)<3)
        h = msgbox('This is not a RGB image, please select an appropriate image.','Error', 'error');
        return;
    end
%     im2=im2uint8(im); imtype=class(im); % class returns type of image
%     e.g. uint8 or uint16
    red = im(:,:,1);
    green = im(:,:,2);
    blue = im(:,:,3);

    axes(handles.axesRed);    imshow(gray2rgb(red,'red'));
    axes(handles.axesGreen);  imshow(gray2rgb(green,'green')); 
    axes(handles.axesBlue);     imshow(gray2rgb(blue,'blue'));
    white=ones(500);
    axes(handles.axesbwRed); imshow(white);
    axes(handles.axesbwGreen); imshow(white);
    axes(handles.axesbwBlue); imshow(white);
  
    
    % auto mask here or user can hand draw ROI 
    bwmask = getAutoMaskROI(blue);
%   applyFilter(handles);
%   drawnow; 
%     hlink = linkprop([handles.axesRed, handles.axesGreen, handles.axesbwRed, handles.axesbwGreen],{'Zoom','Pan'});

%setappdata(hObject.Parent.Parent,'blue',blue); 


% --- Executes on button press in pushbuttonApply.
function pushbuttonApply_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonApply (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
  applyFilter(handles);




function applyFilter(handles)
    global red; global green; global blue;  global bwred; global bwgreen; global bwr; global bwg; global bwmask;
    global bwcellRGBO;
    set(handles.figure1, 'pointer', 'watch')
    drawnow;    
    cbMedianFilter = get(handles.cbMedianFilter, 'Value');
    cbWiener = get(handles.cbWiener, 'Value');
    editTMR = str2double(get(handles.editTMR, 'string'));
    editTMG = str2double(get(handles.editTMG, 'string'));
    editWinX = str2double(get(handles.editWinX, 'string'));
    editWinY = str2double(get(handles.editWinY, 'string'));
    editMedX = str2double(get(handles.editMedX, 'string'));
    editMedY = str2double(get(handles.editMedY, 'string'));
    editMinCommonPixels = str2double(get(handles.editMinCommonPixels, 'string'));
    editMinPixels = str2double(get(handles.editMinSize, 'string'));
    editMaxPixels = str2double(get(handles.editMaxSize, 'string'));

    redP = red; greenP = green;
    if (cbMedianFilter==1)
        redP = medfilt2(red, [editMedX editMedY]);   % remove salt and pepper noise by median filter
        greenP = medfilt2(green, [editMedX editMedY]);
    end
    if (cbWiener==1)
        redP = wiener2(redP, [editWinX editWinY]);
        greenP = wiener2(greenP, [editWinX editWinY]);
    end
    
    axes(handles.axesRed);    imshow(gray2rgb(red,'red'));
    axes(handles.axesGreen);  imshow(gray2rgb(green,'green'));
    axes(handles.axesBlue);     imshow(gray2rgb(blue,'blue'));

    cbBorderTouch = get(handles.cbBorderTouch, 'Value');
    
    if (cbBorderTouch==1)            
       bwmask = imclearborder(bwmask, 8);       % 8 means also remove objects that touches on the courners
    end    

 
    bwred = protLocations(redP, bwmask, editTMR);   
    bwgreen = protLocations(greenP, bwmask, editTMG);
    bwred = bwareaopen(bwred,editMinPixels);
    bwgreen = bwareaopen(bwgreen,editMinPixels);
    bwred = xor(bwred , bwareaopen(bwred , editMaxPixels));
    bwgreen = xor(bwgreen , bwareaopen(bwgreen , editMaxPixels));
    
    if (get(handles.radioPixelRestriction,'Value')==1)
        bwoverlap = bitand(bwred,bwgreen);
        bwoverlap = bwareaopen(bwoverlap, editMinCommonPixels); % removing overlaps that are less than specified number of pixels    
    else
        bwoverlap = countOverlap(bwred,bwgreen, editMinCommonPixels/100);
    end
    
    
    
    
    bwo = uint8(bwoverlap); bwo = bwo .* 255;
    zero = zeros(size(bwred));
    bwr = uint8(bwred); bwr = bwr .* 255;
    bwr = cat(3,bwr,bwo,zero);        % bwred to red channel
    
    bwg = uint8(bwgreen); bwg = bwg .* 255;
    bwg = cat(3,bwo, bwg, zero);        %bwgreen to green channel
    
    axes(handles.axesbwRed);        imshow(bwr);
    axes(handles.axesbwGreen);        imshow(bwg);
    bwcellRGBO = cellRGBO(bwred, bwgreen, bwoverlap, bwmask);
    axes(handles.axesbwBlue);    imshow(bwcellRGBO);


    [L, num] = bwlabel(bwred);
    r = red; r(~bwred)=0;  intensityRed = num2str(sum(r(:)));    
    strRed = strcat('Red Channel: ',' ', num2str(num), ' objects, ', num2str(sum(bwred(:))), ' total pixels, ', intensityRed, ' total Intensity' );
    [L, num] = bwlabel(bwgreen);
    g = green; g(~bwgreen)=0;  intensityGreen = num2str(sum(g(:)));    
    strGreen = strcat('Green Channel: ', num2str(num), ' objects, ', num2str(sum(bwgreen(:))), ' total pixels, ', intensityGreen, ' total Intensity'  );

    
    [L, num] = bwlabel(bwoverlap);
    r(~bwoverlap)=0; g(~bwoverlap)=0;
    intensityCoRed = num2str(sum(r(:)));  
    intensityCoGreen = num2str(sum(g(:)));    
    strOverlap = strcat('Colocalisations: ', num2str(num), ' objects, ', num2str(sum(bwoverlap(:))), ' total pixels, ' );
    strOverlap = strcat(strOverlap, intensityCoRed, ' total red intensity, ' , intensityCoGreen, ' total green intensity'); 

    
    strResults = {strOverlap; strRed; strGreen};
    set(handles.editResults, 'String', strResults);
    
    set(handles.figure1, 'pointer', 'arrow');
    
% --------------------------------------------------------------------


% --------------------------------------------------------------------
function uipushtoolSave_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to uipushtoolSave (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global red, global green, global bwmask; global bwr; global bwg;      %bwred is black & white
global fname; global bwcellRGBO;
    if(isempty(bwmask))
        h = msgbox('Error: Before saving, open a file and run find colocalisation. All channels should be populated before pressing the save button','Fail', 'modal');
        return;
    end
%     imwrite(gray2rgb(red,'red'), strcat(fname,'_red.tiff'));
%     imwrite(gray2rgb(green,'green'), strcat(fname,'_green.tiff'));
    imwrite(red, strcat(fname,'_red.tiff'));
    imwrite(green, strcat(fname,'_green.tiff'));
    imwrite(bwcellRGBO, strcat(fname,'_Mask.tiff'));
    imwrite(bwr, strcat(fname,'_redB.tiff'));
    imwrite(bwg, strcat(fname,'_greenB.tiff'));
    h = msgbox('Files have been saved successfully.','Success', 'modal');

% --- Executes on button press in pushbuttonPvalue.
function pushbuttonPvalue_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonPvalue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global bwred; global bwgreen;   global bwmask;
set(handles.figure1, 'pointer', 'watch')
drawnow;

num =   str2double(get(handles.editIteration, 'String'));

 bwoverlap = bitand(bwred,bwgreen);
 cc = bwconncomp(bwoverlap,8); 
 actual = cc.NumObjects;
 
%  tic
 count = randomise(bwred, bwgreen, bwmask, num); 
% toc
 % Test the null hypothes is that sample data comes from a distribution
 % with mean m  ---  nnz(bwoverlap(:))      figure, imshow(bwoverlap)
 ac = log10(actual);
 co = log10(count);
  co(~isfinite(co))=0;  % log(0) is INF so replace INF with 0
%  [h, p, ci, stats] = ttest(count,actual); 
 [h, p, ci, stats] = ttest2(co,ac); 
 
 statvalues = {strcat('P-Value = ', num2str(p))};
 statvalues = [statvalues; strcat('Permutation mean =', num2str(mean(count)))];
 statvalues = [statvalues; strcat('Permutation Std. =', num2str(std(count)))]; 
 
 set(handles.editResults, 'String', statvalues);
 set(handles.figure1, 'pointer', 'arrow');
 


% --- Executes on mouse press over axes background.
function axesBlue_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to axesBlue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global red;
figure, imshow(red,[]);


% --- Executes on button press in pbSelectROI.
function pbSelectROI_Callback(hObject, eventdata, handles)
% hObject    handle to pbSelectROI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global im; global bwmask;

    if(isempty(im))
        h = msgbox('Error: please open an image file first, before running this function.','Fail', 'modal');
        return;
    end

sz = size(im) ;
toMask = false( [sz(1) sz(2)]);
q='Yes';
handle = figure('MenuBar', 'none','Toolbar','non');
imshow(im);
while(strcmp(q,'Yes'))
    h = imfreehand(gca);
    setColor(h,'red');
    BW = createMask(h);    %% BW is 3 dimentional matrix
    toMask = toMask | BW;         % OR operation anyone is true 
    q = questdlg('Would you like to select another region of interest (ROI)?', 'More ROI?', 'Yes', 'No', 'Yes');
end
close (handle);
bwmask = toMask;
axes(handles.axesbwBlue); imshow(bwmask);


% --------------------------------------------------------------------
function uipushtoolHelp_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to uipushtoolHelp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
web('http://matcol.sourceforge.net');


% if(strcmp(char(handles.TabA01Main.Visible),'on'))
%     set(handles.TabA01Main,'Visible', 'off');
% else
%     set(handles.TabA01Main,'Visible', 'on');
% end

%% END OF CODING


% --- Executes on button press in radioPercRestriction.
function radioPercRestriction_Callback(hObject, eventdata, handles)
        set(handles.radioPixelRestriction,'Value',0) ;       



% --- Executes on button press in radioPixelRestriction.
function radioPixelRestriction_Callback(hObject, eventdata, handles)

        set(handles.radioPercRestriction,'Value',0) ;   
