function varargout = deepgui(varargin)
% DEEPGUI MATLAB code for deepgui.fig
%      DEEPGUI, by itself, creates a new DEEPGUI or raises the existing
%      singleton*.
%
%      H = DEEPGUI returns the handle to a new DEEPGUI or the handle to
%      the existing singleton*.
%
%      DEEPGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DEEPGUI.M with the given input arguments.
%
%      DEEPGUI('Property','Value',...) creates a new DEEPGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before deepgui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to deepgui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help deepgui

% Last Modified by GUIDE v2.5 07-Jun-2019 19:26:24

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @deepgui_OpeningFcn, ...
                   'gui_OutputFcn',  @deepgui_OutputFcn, ...
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


% --- Executes just before deepgui is made visible.
function deepgui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to deepgui (see VARARGIN)

% Choose default command line output for deepgui
global mode
mode = -1;

global net

data = load('net_yu.mat');
data2 = load('net3.mat');
data3 = load('net.mat');
net = data3.net;

global detector
detector = data.detector;

global detector2
detector2 = data2.detector;

global filepath
filepath = '';

global whichone
whichone = 1;

global img_num
img_num = 0;

global img_path_list
img_path_list = '';
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes deepgui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = deepgui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in Next.
function Next_Callback(hObject, eventdata, handles)
% hObject    handle to Next (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global filepath
global whichone
global img_num
global img_path_list
global net
global mode
global detector
global detector2

if (mode == 1)
    if (img_num ~= 0)
        if (whichone ~= img_num)
            whichone = whichone + 1;
            image_name = img_path_list(whichone).name;% 圖像名
            image =  imread(fullfile(filepath,image_name));%讀取圖像
            imds = imageDatastore(fullfile(filepath,image_name));
            inputSize = net.Layers(1).InputSize;
            augimdsValidation = augmentedImageDatastore(inputSize(1:2),imds);


            set(handles.content,'String',image_name);
            axes(handles.figshow);
            imshow(image);

            [YPred,scores] = classify(net,augimdsValidation);
            D = cellstr(YPred);
            set(handles.answer,'String',D);

            E = [num2str(whichone) '/' num2str(img_num)];
            set(handles.which,'String',E);
        end
    end
elseif(mode == 2)
    if (img_num ~= 0)
        if (whichone ~= img_num)
            whichone = whichone + 1;
            image_name = img_path_list(whichone).name;% 圖像名
            image =  imread(fullfile(filepath,image_name));%讀取圖像
            imds = imageDatastore(fullfile(filepath,image_name));


            image = imresize(image , 227/224);

            set(handles.content,'String',image_name);

            [bbox, score, label] = detect(detector, image);
            if(isempty(label))
                set(handles.answer,'String','None');
                detectedImg = insertShape(image,'rectangle',bbox,'Color','magenta');
                axes(handles.figshow);
                imshow(detectedImg);
            else
                label = cellstr(label);
                % detectedImg = insertObjectAnnotation(image,'rectangle',bbox,score);
                detectedImg = insertObjectAnnotation(image,'rectangle',bbox,label,'FontSize',18,'Color','magenta','TextColor','white');
                axes(handles.figshow);
                imshow(detectedImg);

                D = cellstr(label);
                G = string(D);
                N = length(G);
                Z = G(1);
                if N >= 2
                    for i=2:N
                        Z = strcat(Z , " , ");
                        Z = strcat(Z , G(i));
                    end
                end


                set(handles.answer,'String',Z);
            end
            

            E = [num2str(whichone) '/' num2str(img_num)];
            set(handles.which,'String',E);
        end
    end
elseif(mode == 3)
    if (img_num ~= 0)
        if (whichone ~= img_num)
            whichone = whichone + 1;
            image_name = img_path_list(whichone).name;% 圖像名
            image =  imread(fullfile(filepath,image_name));%讀取圖像
            imds = imageDatastore(fullfile(filepath,image_name));


            set(handles.content,'String',image_name);

            [bbox, score, label] = detect(detector2, image);
            if(isempty(label))
                set(handles.answer,'String','None');
                detectedImg = insertShape(image,'rectangle',bbox,'Color','magenta');
                axes(handles.figshow);
                imshow(detectedImg);
            else
                label = cellstr(label);
                % detectedImg = insertObjectAnnotation(image,'rectangle',bbox,score);
                detectedImg = insertObjectAnnotation(image,'rectangle',bbox,label,'FontSize',18,'Color','magenta','TextColor','white');
                axes(handles.figshow);
                imshow(detectedImg);

                D = cellstr(label);
                G = string(D);
                N = length(G);
                Z = G(1);
                if N >= 2
                    for i=2:N
                        Z = strcat(Z , " , ");
                        Z = strcat(Z , G(i));
                    end
                end


                set(handles.answer,'String',Z);
            end

            E = [num2str(whichone) '/' num2str(img_num)];
            set(handles.which,'String',E);
        end
    end
end


% --- Executes on button press in Previous.
function Previous_Callback(hObject, eventdata, handles)
% hObject    handle to Previous (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global filepath
global whichone
global img_path_list
global img_num
global net
global mode
global detector
global detector2


if (mode == 1)
    if (img_num ~= 0)
        if (whichone ~= 1)
            whichone = whichone - 1;
            image_name = img_path_list(whichone).name;% 圖像名
            image =  imread(fullfile(filepath,image_name));%讀取圖像
            imds = imageDatastore(fullfile(filepath,image_name));
            inputSize = net.Layers(1).InputSize;
            augimdsValidation = augmentedImageDatastore(inputSize(1:2),imds);


            set(handles.content,'String',image_name);
            axes(handles.figshow);
            imshow(image);

            [YPred,scores] = classify(net,augimdsValidation);
            D = cellstr(YPred);
            set(handles.answer,'String',D);

            E = [num2str(whichone) '/' num2str(img_num)];
            set(handles.which,'String',E);
        end
    end
elseif(mode == 2)
    if (img_num ~= 0)
        if (whichone ~= 1)
            whichone = whichone - 1;
            image_name = img_path_list(whichone).name;% 圖像名
            image =  imread(fullfile(filepath,image_name));%讀取圖像
            imds = imageDatastore(fullfile(filepath,image_name));


            image = imresize(image , 227/224);

            set(handles.content,'String',image_name);

            [bbox, score, label] = detect(detector, image);
            if(isempty(label))
                set(handles.answer,'String','None');
                detectedImg = insertShape(image,'rectangle',bbox,'Color','magenta');
                axes(handles.figshow);
                imshow(detectedImg);
            else
                label = cellstr(label);
                % detectedImg = insertObjectAnnotation(image,'rectangle',bbox,score);
                detectedImg = insertObjectAnnotation(image,'rectangle',bbox,label,'FontSize',18,'Color','magenta','TextColor','white');
                axes(handles.figshow);
                imshow(detectedImg);

                D = cellstr(label);
                G = string(D);
                N = length(G);
                Z = G(1);
                if N >= 2
                    for i=2:N
                        Z = strcat(Z , " , ");
                        Z = strcat(Z , G(i));
                    end
                end


                set(handles.answer,'String',Z);
            end

            E = [num2str(whichone) '/' num2str(img_num)];
            set(handles.which,'String',E);
        end
    end
elseif(mode == 3)
    if (img_num ~= 0)
        if (whichone ~= 1)
            whichone = whichone - 1;
            image_name = img_path_list(whichone).name;% 圖像名
            image =  imread(fullfile(filepath,image_name));%讀取圖像
            imds = imageDatastore(fullfile(filepath,image_name));


            set(handles.content,'String',image_name);

            [bbox, score, label] = detect(detector2, image);
            if(isempty(label))
                set(handles.answer,'String','None');
                detectedImg = insertShape(image,'rectangle',bbox,'Color','magenta');
                axes(handles.figshow);
                imshow(detectedImg);
            else
                label = cellstr(label);
                % detectedImg = insertObjectAnnotation(image,'rectangle',bbox,score);
                detectedImg = insertObjectAnnotation(image,'rectangle',bbox,label,'FontSize',18,'Color','magenta','TextColor','white');
                axes(handles.figshow);
                imshow(detectedImg);

                D = cellstr(label);
                G = string(D);
                N = length(G);
                Z = G(1);
                if N >= 2
                    for i=2:N
                        Z = strcat(Z , " , ");
                        Z = strcat(Z , G(i));
                    end
                end


                set(handles.answer,'String',Z);
            end

            E = [num2str(whichone) '/' num2str(img_num)];
            set(handles.which,'String',E);
        end
    end
end

% --------------------------------------------------------------------
function File_Callback(hObject, eventdata, handles)
% hObject    handle to File (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function open_Callback(hObject, eventdata, handles)
% hObject    handle to open (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% [filename filepath]=uigetfile('*.jpg','請選擇文件');
% set(handles.content,'String',strcat(filepath,filename));
% A = imread(strcat(filepath,filename));
% image(A);
global filepath
global whichone
global img_num
global img_path_list 
global net
global mode
global detector
global detector2
whichone = 1;
img_num = 0;
img_path_list = '';

filepath = uigetdir('*.*','請選擇文件夾');
img_path_list = dir(fullfile(filepath,'*.jpg'));%獲取該文件夾中所有jpg格式的圖像
img_num = length(img_path_list);%獲取圖像總數量

image_name = img_path_list(whichone).name;% 圖像名
image =  imread(fullfile(filepath,image_name));%讀取圖像
imds = imageDatastore(fullfile(filepath,image_name));

if (mode == 1)
    inputSize = net.Layers(1).InputSize;
    augimdsValidation = augmentedImageDatastore(inputSize(1:2),imds);

    set(handles.content,'String',image_name);
    axes(handles.figshow);
    imshow(image,'InitialMagnification','fit');


    [YPred,scores] = classify(net,augimdsValidation);
    D = cellstr(YPred);
    set(handles.answer,'String',D);


    E = [num2str(whichone) '/' num2str(img_num)];
    set(handles.which,'String',E);
    
elseif(mode == 2)

    image = imresize(image , 227/224);

    set(handles.content,'String',image_name);

    [bbox, score, label] = detect(detector, image);
    if(isempty(label))
        set(handles.answer,'String','None');
        detectedImg = insertShape(image,'rectangle',bbox,'Color','magenta');
        axes(handles.figshow);
        imshow(detectedImg);
    else
        label = cellstr(label);
        % detectedImg = insertObjectAnnotation(image,'rectangle',bbox,score);
        detectedImg = insertObjectAnnotation(image,'rectangle',bbox,label,'FontSize',18,'Color','magenta','TextColor','white');
        axes(handles.figshow);
        imshow(detectedImg);
        
        D = cellstr(label);
        G = string(D);
        N = length(G);
        Z = G(1);
        if N >= 2
            for i=2:N
                Z = strcat(Z , " , ");
                Z = strcat(Z , G(i));
            end
        end
        
        
        set(handles.answer,'String',Z);
    end


    E = [num2str(whichone) '/' num2str(img_num)];
    set(handles.which,'String',E);
elseif(mode == 3)


    set(handles.content,'String',image_name);


    [bbox, score, label] = detect(detector2, image);
    if(isempty(label))
        set(handles.answer,'String','None');
        detectedImg = insertShape(image,'rectangle',bbox,'Color','magenta');
        axes(handles.figshow);
        imshow(detectedImg);
    else
        label = cellstr(label);
        % detectedImg = insertObjectAnnotation(image,'rectangle',bbox,score);
        detectedImg = insertObjectAnnotation(image,'rectangle',bbox,label,'FontSize',18,'Color','magenta','TextColor','white');
        axes(handles.figshow);
        imshow(detectedImg);
        
        D = cellstr(label);
        G = string(D);
        N = length(G);
        Z = G(1);
        if N >= 2
            for i=2:N
                Z = strcat(Z , " , ");
                Z = strcat(Z , G(i));
            end
        end
        
        
        set(handles.answer,'String',Z);
    end


    E = [num2str(whichone) '/' num2str(img_num)];
    set(handles.which,'String',E);
end


function answer_Callback(hObject, eventdata, handles)
% hObject    handle to answer (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of answer as text
%        str2double(get(hObject,'String')) returns contents of answer as a double


% --- Executes during object creation, after setting all properties.
function answer_CreateFcn(hObject, eventdata, handles)
% hObject    handle to answer (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function which_Callback(hObject, eventdata, handles)
% hObject    handle to which (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of which as text
%        str2double(get(hObject,'String')) returns contents of which as a double


% --- Executes during object creation, after setting all properties.
function which_CreateFcn(hObject, eventdata, handles)
% hObject    handle to which (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function Mode_Callback(hObject, eventdata, handles)
% hObject    handle to Mode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Untitled_2_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Untitled_3_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function one_Callback(hObject, eventdata, handles)
% hObject    handle to one (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global mode
mode = 1;
load('net.mat');
set(handles.modetext,'String','Mode 1');


% --------------------------------------------------------------------
function two_Callback(hObject, eventdata, handles)
% hObject    handle to two (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global mode
mode = 2;
set(handles.modetext,'String','Mode 2');

% --------------------------------------------------------------------
function three_Callback(hObject, eventdata, handles)
% hObject    handle to three (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global mode
mode = 3;
set(handles.modetext,'String','Mode 3');



function modetext_Callback(hObject, eventdata, handles)
% hObject    handle to modetext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of modetext as text
%        str2double(get(hObject,'String')) returns contents of modetext as a double


% --- Executes during object creation, after setting all properties.
function modetext_CreateFcn(hObject, eventdata, handles)
% hObject    handle to modetext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function Batch_Callback(hObject, eventdata, handles)
% hObject    handle to Batch (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function batchmode1_Callback(hObject, eventdata, handles)
% hObject    handle to batchmode1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
filepath = uigetdir('*.*','請選擇文件夾');
G25(filepath,1);


% --------------------------------------------------------------------
function batchmode2_Callback(hObject, eventdata, handles)
% hObject    handle to batchmode2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
filepath = uigetdir('*.*','請選擇文件夾');
G25(filepath,2);

% --------------------------------------------------------------------
function batchmode3_Callback(hObject, eventdata, handles)
% hObject    handle to batchmode3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
filepath = uigetdir('*.*','請選擇文件夾');
G25(filepath,3);