%Author: Kyle Tucker
%Date: 5/11/18
%Purpose: To locate dots on Ocean Current Turbine models and estimate power
%generation of models.
%IMPORTANT NOTE: This code requires the Matlab Image Processing toolbox to
%run!
function varargout = OCTImageProcessing_Kyle(varargin)
% OCTIMAGEPROCESSING_KYLE MATLAB code for OCTImageProcessing_Kyle.fig
%      OCTIMAGEPROCESSING_KYLE, by itself, creates a new OCTIMAGEPROCESSING_KYLE or raises the existing
%      singleton*.
%
%      H = OCTIMAGEPROCESSING_KYLE returns the handle to a new OCTIMAGEPROCESSING_KYLE or the handle to
%      the existing singleton*.
%
%      OCTIMAGEPROCESSING_KYLE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in OCTIMAGEPROCESSING_KYLE.M with the given input arguments.
%
%      OCTIMAGEPROCESSING_KYLE('Property','Value',...) creates a new OCTIMAGEPROCESSING_KYLE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before OCTImageProcessing_Kyle_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to OCTImageProcessing_Kyle_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help OCTImageProcessing_Kyle

% Last Modified by GUIDE v2.5 04-May-2018 14:38:05

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @OCTImageProcessing_Kyle_OpeningFcn, ...
                   'gui_OutputFcn',  @OCTImageProcessing_Kyle_OutputFcn, ...
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


% --- Executes just before OCTImageProcessing_Kyle is made visible.
function OCTImageProcessing_Kyle_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to OCTImageProcessing_Kyle (see VARARGIN)
set(handles.PRW,'Visible','off')        % Removes axes from preview window
clear image        
global image     %initialize global variables

addpath(genpath(pwd));
% Choose default command line output for OCTImageProcessing_Kyle
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes OCTImageProcessing_Kyle wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = OCTImageProcessing_Kyle_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in FindImage.
function FindImage_Callback(hObject, eventdata, handles)
% hObject    handle to FindImage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global image;%declares the image location as a globally accessible array 
image=getimage(handles);

function image=getimage(handles)%runs when radio button "FindImage" is selected
image =[];
    [filename pathname] = uigetfile({'*.jpg';'*.bmp';'*.JPG'},'File Selector');%Requires lowercase .jpg file extension
    image = strcat(pathname, filename);
    [pathstr, name, ext] = fileparts(filename);
    axes(handles.PRW);
    imshow(image)

% --- Executes on button press in FindDots.
function FindDots_Callback(hObject, eventdata, handles)
% hObject    handle to FindDots (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.text19,'Backgroundcolor','r');
pause(.005)
%Gets variables from GUI. To change default values, just update String in
%guide. To access guide, type 'guide' into the command window.
MinSize_String = get(handles.MinSize, 'String');
MinSize = str2num(MinSize_String);%min pixel size for dots in image
MaxSize_String = get(handles.MaxSize, 'String');
MaxSize = str2num(MaxSize_String);%max pixel size for dots in image
Circularity_String = get(handles.circularity, 'String');
Circularity = str2num(Circularity_String);%perimeter area ratio for circles
MarkerSize_String = get(handles.markersize, 'String');
MarkerSize = str2num(MarkerSize_String);%size of red circles drawn around dots
LowerLimit_String = get(handles.LowerLimit, 'String');
Triangle_LowerLimit = str2num(LowerLimit_String);%lower circularity limit for triangles
UpperLimit_String = get(handles.UpperLimit, 'String');
Triangle_UpperLimit = str2num(UpperLimit_String);%upper circularity limit for triangles
LowerLimit_String = get(handles.Square_LowerLimit, 'String');
Square_LowerLimit = str2num(LowerLimit_String);%lower circularity limit for squares
UpperLimit_String = get(handles.Square_UpperLimit, 'String');
Square_UpperLimit = str2num(UpperLimit_String);%upper circularity limit for squares
%Calls findDots function, returns centroids of dots
global image;
[centroidX,centroidZ] = findDots(image,MinSize,MaxSize,Circularity,Triangle_LowerLimit,Triangle_UpperLimit,Square_LowerLimit,Square_UpperLimit);
%Below code plots red circles on image shown in GUI
axes(handles.PRW);
imshow(image)
hold on;
for k = 1 : length(centroidX)
	plot(centroidX(k), centroidZ(k), ...
		'ro', 'MarkerSize', MarkerSize, 'LineWidth', 2);
end
set(handles.text19,'Backgroundcolor','g');
assignin('base','centroidX',centroidX);%puts centroidX and centroidZ in workspace to be accessed by findCoordinates
assignin('base','centroidZ',centroidZ);



function MinSize_Callback(hObject, eventdata, handles)
% hObject    handle to MinSize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of MinSize as text
%        str2double(get(hObject,'String')) returns contents of MinSize as a double


% --- Executes during object creation, after setting all properties.
function MinSize_CreateFcn(hObject, eventdata, handles)
% hObject    handle to MinSize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function MaxSize_Callback(hObject, eventdata, handles)
% hObject    handle to MaxSize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of MaxSize as text
%        str2double(get(hObject,'String')) returns contents of MaxSize as a double


% --- Executes during object creation, after setting all properties.
function MaxSize_CreateFcn(hObject, eventdata, handles)
% hObject    handle to MaxSize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function circularity_Callback(hObject, eventdata, handles)
% hObject    handle to circularity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of circularity as text
%        str2double(get(hObject,'String')) returns contents of circularity as a double


% --- Executes during object creation, after setting all properties.
function circularity_CreateFcn(hObject, eventdata, handles)
% hObject    handle to circularity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function markersize_Callback(hObject, eventdata, handles)
% hObject    handle to markersize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of markersize as text
%        str2double(get(hObject,'String')) returns contents of markersize as a double


% --- Executes during object creation, after setting all properties.
function markersize_CreateFcn(hObject, eventdata, handles)
% hObject    handle to markersize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in FindCoordinates.
function FindCoordinates_Callback(hObject, eventdata, handles)
% hObject    handle to FindCoordinates (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%IMPORTANT NOTE: This code assumes all 18 dots were found using findDots
%find h and v location in pixel units. h and v are referenced from
%the center of the image, because max distortion happens at the edge
%of the image
centroidX = evalin('base','centroidX');%Gets centroidX and centroidZ from workspace
centroidZ = evalin('base','centroidZ');
conversion = get(handles.conversion_factor, 'String');%this variable allows for conversion from pixel units to mm
conversion = str2num(conversion);%converts this variable from a string to a number
a = get(handles.a, 'String');%this variable states how far the camera is from the glass in mm
a = str2num(a);%converts this variable from a string to a number
w1_String = get(handles.w1, 'String');%These w values are the various glass to dots distances in the y direction for the OCT models
w1 = str2num(w1_String);
w2_String = get(handles.w2, 'String');
w2 = str2num(w2_String);
w3_String = get(handles.w3, 'String');
w3 = str2num(w3_String);
global image;%Gets image location as string array
RGB = imread(image);%reads image
[v_length,h_length,three] = size(RGB);%gets size of image. 'three' variable is necessary but unused
h_center = h_length/2;%finds x center of image
v_center = v_length/2;%finds z center of image
for i = 1:length(centroidX)%This loop converts pixel locations to real world coordinates
    if i>0 && i<7%If statement determines which glass to dot location is used
        w = w1;%currently depth for yellow dots
    elseif i>6 && i<13
        w = w2;%currently depth for red dots
    else
        w = w3;%currently depth for blue dots
    end
    %Makes centroid locations relative to center of the picture rather than
    %upper left hand corner of image. This is done because radial
    %distortion is the worst at the end of the image, while distortion is
    %negligible at the center of the image.
    x_a(i) = centroidX(i)-h_center;%Gets x locations of dots relative to center of image in pixel units
    z_a(i) = v_center-centroidZ(i);%Gets z locations of dots relative to center of image in pixel units
    %Conversion from pixel units to millimeters
    x_a(i) = (x_a(i)*10)/(conversion);%currently, you need a reference that is ten millimeters long. 
    %To change this, change the value from 10 to the new length being referenced
    z_a(i) = (z_a(i)*10)/(conversion);
    %Finds world coordinates
    [x(i),y(i),z(i)] = findCoordinates(x_a(i),w,z_a(i),a);%Runs findCoordinates function
end
%Rearranges x,y,and z arrays to match OCT numbering. If the color scheme of
%the dots is changed, this will no longer work. At the time this code was
%written, OCTs 3, 6, and 9 had yellow dots, OCTs 2, 5, and 8 had red dots,
%and OCTs 1, 4, and 7 had blue dots. This was done because yellow is the
%easiest for the code to recognize, while blue is the most difficult. Also,
%yellow is processed first so that any yellow dots that appear in the red
%filter processing can then be kicked out of the centroid array, thus
%avoiding duplicates.
%The findDots function stores OCTs in this order: 9,6,3,8,5,2,7,4,1. This
%is because the image finds dots from left to right, and by color. The
%below code puts the arrays in order from 1-9, with the left dot first and
%the right dot second.
x_old = x;%Stores current arrays so x, y, and z can be changed
y_old = y;
z_old = z;
j=1;%i,j,k,m, and n are just variables used in loops below.
m=1;
k=0;
while(j<=length(x_old))
    i=3;
    while(j<=length(x_old) && i>0)
        n=1;
        while(j<=length(x_old) && n<3)
            if((6*i-m-k)<=length(x_old))%Accounts for situation in which only some dots are visible
                x(j) = x_old(6*i-m-k);
                y(j) = y_old(6*i-m-k);
                z(j) = z_old(6*i-m-k);
            end
            j=j+1;
            n=n+1;
            m=int8(~m);
        end
        i=i-1;
    end
    k=k+2;
end
%x,y,and z have stored in the correct order, assuming that there are 6
%yellow dots, 6 red dots, and 6 blue dots
%writes x, y, and z values into GUI
set(handles.text34,'String',num2str(round(x(1),1)));
set(handles.text35,'String',num2str(round(y(1),1)));
set(handles.text36,'String',num2str(round(z(1),1)));
set(handles.text65,'String',num2str(round(x(2),1)));
set(handles.text66,'String',num2str(round(y(2),1)));
set(handles.text67,'String',num2str(round(z(2),1)));
set(handles.text37,'String',num2str(round(x(3),1)));
set(handles.text38,'String',num2str(round(y(3),1)));
set(handles.text39,'String',num2str(round(z(3),1)));
set(handles.text68,'String',num2str(round(x(4),1)));
set(handles.text69,'String',num2str(round(y(4),1)));
set(handles.text70,'String',num2str(round(z(4),1)));
set(handles.text40,'String',num2str(round(x(5),1)));
set(handles.text41,'String',num2str(round(y(5),1)));
set(handles.text42,'String',num2str(round(z(5),1)));
set(handles.text71,'String',num2str(round(x(6),1)));
set(handles.text72,'String',num2str(round(y(6),1)));
set(handles.text73,'String',num2str(round(z(6),1)));
set(handles.text43,'String',num2str(round(x(7),1)));
set(handles.text44,'String',num2str(round(y(7),1)));
set(handles.text45,'String',num2str(round(z(7),1)));
set(handles.text74,'String',num2str(round(x(8),1)));
set(handles.text75,'String',num2str(round(y(8),1)));
set(handles.text76,'String',num2str(round(z(8),1)));
set(handles.text46,'String',num2str(round(x(9),1)));
set(handles.text47,'String',num2str(round(y(9),1)));
set(handles.text48,'String',num2str(round(z(9),1)));
set(handles.text77,'String',num2str(round(x(10),1)));
set(handles.text78,'String',num2str(round(y(10),1)));
set(handles.text79,'String',num2str(round(z(10),1)));
set(handles.text49,'String',num2str(round(x(11),1)));
set(handles.text50,'String',num2str(round(y(11),1)));
set(handles.text51,'String',num2str(round(z(11),1)));
set(handles.text80,'String',num2str(round(x(12),1)));
set(handles.text81,'String',num2str(round(y(12),1)));
set(handles.text82,'String',num2str(round(z(12),1)));
set(handles.text52,'String',num2str(round(x(13),1)));
set(handles.text53,'String',num2str(round(y(13),1)));
set(handles.text54,'String',num2str(round(z(13),1)));
set(handles.text83,'String',num2str(round(x(14),1)));
set(handles.text84,'String',num2str(round(y(14),1)));
set(handles.text85,'String',num2str(round(z(14),1)));
set(handles.text55,'String',num2str(round(x(15),1)));
set(handles.text56,'String',num2str(round(y(15),1)));
set(handles.text57,'String',num2str(round(z(15),1)));
set(handles.text86,'String',num2str(round(x(16),1)));
set(handles.text87,'String',num2str(round(y(16),1)));
set(handles.text88,'String',num2str(round(z(16),1)));
set(handles.text58,'String',num2str(round(x(17),1)));
set(handles.text59,'String',num2str(round(y(17),1)));
set(handles.text60,'String',num2str(round(z(17),1)));
set(handles.text89,'String',num2str(round(x(18),1)));
set(handles.text90,'String',num2str(round(y(18),1)));
set(handles.text91,'String',num2str(round(z(18),1)));

function w1_Callback(hObject, eventdata, handles)
% hObject    handle to w1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of w1 as text
%        str2double(get(hObject,'String')) returns contents of w1 as a double


% --- Executes during object creation, after setting all properties.
function w1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to w1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function w2_Callback(hObject, eventdata, handles)
% hObject    handle to w2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of w2 as text
%        str2double(get(hObject,'String')) returns contents of w2 as a double


% --- Executes during object creation, after setting all properties.
function w2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to w2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function w3_Callback(hObject, eventdata, handles)
% hObject    handle to w3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of w3 as text
%        str2double(get(hObject,'String')) returns contents of w3 as a double


% --- Executes during object creation, after setting all properties.
function w3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to w3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function LowerLimit_Callback(hObject, eventdata, handles)
% hObject    handle to LowerLimit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of LowerLimit as text
%        str2double(get(hObject,'String')) returns contents of LowerLimit as a double


% --- Executes during object creation, after setting all properties.
function LowerLimit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to LowerLimit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function UpperLimit_Callback(hObject, eventdata, handles)
% hObject    handle to UpperLimit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of UpperLimit as text
%        str2double(get(hObject,'String')) returns contents of UpperLimit as a double


% --- Executes during object creation, after setting all properties.
function UpperLimit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to UpperLimit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in find_Conversion.
function find_Conversion_Callback(hObject, eventdata, handles)
% hObject    handle to find_Conversion (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global image
figure, imshow(image);
h = imdistline;


function conversion_factor_Callback(hObject, eventdata, handles)
% hObject    handle to conversion_factor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of conversion_factor as text
%        str2double(get(hObject,'String')) returns contents of conversion_factor as a double


% --- Executes during object creation, after setting all properties.
function conversion_factor_CreateFcn(hObject, eventdata, handles)
% hObject    handle to conversion_factor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function a_Callback(hObject, eventdata, handles)
% hObject    handle to a (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of a as text
%        str2double(get(hObject,'String')) returns contents of a as a double


% --- Executes during object creation, after setting all properties.
function a_CreateFcn(hObject, eventdata, handles)
% hObject    handle to a (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Square_LowerLimit_Callback(hObject, eventdata, handles)
% hObject    handle to Square_LowerLimit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Square_LowerLimit as text
%        str2double(get(hObject,'String')) returns contents of Square_LowerLimit as a double


% --- Executes during object creation, after setting all properties.
function Square_LowerLimit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Square_LowerLimit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Square_UpperLimit_Callback(hObject, eventdata, handles)
% hObject    handle to Square_UpperLimit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Square_UpperLimit as text
%        str2double(get(hObject,'String')) returns contents of Square_UpperLimit as a double


% --- Executes during object creation, after setting all properties.
function Square_UpperLimit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Square_UpperLimit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
