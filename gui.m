function varargout = gui(varargin)
% GUI MATLAB code for gui.fig
%      GUI, by itself, creates a new GUI or raises the existing
%      singleton*.
%
%      H = GUI returns the handle to a new GUI or the handle to
%      the existing singleton*.
%
%      GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI.M with the given input arguments.
%
%      GUI('Property','Value',...) creates a new GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui

% Last Modified by GUIDE v2.5 24-Mar-2018 23:08:58

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_OutputFcn, ...
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


% --- Executes just before gui is made visible.
function gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui (see VARARGIN)

% Choose default command line output for gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in selectImagePushButton.
function selectImagePushButton_Callback(hObject, eventdata, handles)
    % hObject    handle to selectImagePushButton (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    [filename, pathname] = uigetfile({'*.jpg;*.png;*.jpeg;*.tif;*.tiff', 'Images'},'Select an Image');
    
    imagePath = strcat(pathname, filename);
    
    handles.imagePath = imagePath;
    guidata(hObject, handles);
    
    axes(handles.imageAxes);
    imshow(imagePath);


% --- Executes on button press in searchImagePushButton.
function searchImagePushButton_Callback(hObject, eventdata, handles)
    % hObject    handle to searchImagePushButton (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    if ~isfield(handles, 'imagePath')
        warndlg('Please select an image!', 'Select Image');
        return;
    end
    
    if ~isfield(handles, 'threshold')
        warndlg('Please enter threshold value!', 'Enter Threshold');
        return;
    end
    
    subgui('searchresults', handles.imagePath, handles.threshold);
    
    
    
% --- Executes on button press in trainDatasetPushButton.
function trainDatasetPushButton_Callback(hObject, eventdata, handles)
% hObject    handle to trainDatasetPushButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function thresholdtext_Callback(hObject, eventdata, handles)
% hObject    handle to thresholdtext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of thresholdtext as text
%        str2double(get(hObject,'String')) returns contents of thresholdtext as a double

    threshold = str2double(get(handles.thresholdtext, 'String'));
    
    if isnan(threshold)
        warndlg('Thresold value must be numerical!', 'Thresold Value');
        return;
    end
    
    if threshold < 0 && threshold > 100
        warndlg('Thresold must be between 0 and 100', 'Thresold Value');
    end
    
    handles.threshold = threshold;
    guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function thresholdtext_CreateFcn(hObject, eventdata, handles)
% hObject    handle to thresholdtext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

handles.threshold = 0;
guidata(hObject, handles);
