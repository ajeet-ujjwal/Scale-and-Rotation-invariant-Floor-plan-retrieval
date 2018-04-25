function varargout = subgui(varargin)
% SUBGUI MATLAB code for subgui.fig
%      SUBGUI, by itself, creates a new SUBGUI or raises the existing
%      singleton*.
%
%      H = SUBGUI returns the handle to a new SUBGUI or the handle to
%      the existing singleton*.
%
%      SUBGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SUBGUI.M with the given input arguments.
%
%      SUBGUI('Property','Value',...) creates a new SUBGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before subgui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to subgui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help subgui

% Last Modified by GUIDE v2.5 25-Mar-2018 03:08:04

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @subgui_OpeningFcn, ...
                   'gui_OutputFcn',  @subgui_OutputFcn, ...
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


% --- Executes just before subgui is made visible.
function subgui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to subgui (see VARARGIN)
    
    if nargin < 4 + 1
        errordlg('No image is provided', 'Input Error');
        close('subgui');
        return;
    elseif nargin < 4 + 2
        errordlg('Thresold value is not provided', 'Input Error');
        close('subgui');
        return;
    end
    
    inputImagePath = varargin{2};
    threshold = varargin{3};
    
%     disp(inputImagePath);
%     disp(threshold);
%     disp(isnumeric(threshold));
    
    fprintf('Searching image...');
    if Utility.METHOD_IN_GUI == 1
        results = SearchImage(inputImagePath, threshold);
    else
        results = SearchImage2(inputImagePath, threshold);
    end
    fprintf('DONE\n');
    [m, ~] = size(results); % m - number of results
    
%     disp(results);
    
    if m == 0
        msgbox('No result found', 'Result');
        close('subgui');        
        return;
    end
    
    % Choose default command line output for subgui
    handles.output = hObject;

    % Update handles structure
    guidata(hObject, handles);

    % UIWAIT makes subgui wait for user response (see UIRESUME)
    % uiwait(handles.figure1);
    
    totalpages = floor(m/8);
    if mod(m, 8) ~= 0
        totalpages = totalpages + 1;
    end
    
    handles.results = results;
    handles.totalimages = m;
    handles.totalpages = totalpages;
    handles.currentpage = 1;
    guidata(hObject, handles);
    
    set(handles.resultspageindex, 'String', strcat('1/', num2str(totalpages)));
    if m > 8
        set(handles.resultsnextbutton, 'Enable', 'on');
    end
    
    for i = 1:min(m, 8)
        axes(handles.(strcat('resultsimage', num2str(i))));
        imshow(results{i, 1});
        [~, name, ~] = fileparts(results{i, 1});
        name = name(1:length(name) - 5);
        set(handles.(strcat('resultspanel', num2str(i))), 'visible', 'on');
        set(handles.(strcat('resultsdistance', num2str(i))), 'String', strcat('name: ', name,' | percent match:   ', num2str(results{i, 2}), '%'));
    end
%     axes(handles.resultsimage1)
%     imshow(inputImagePath)
%     set(handles.resultspanel1, 'visible', 'on');
%     set(handles.resultsdistance1, 'String', '95% match');

% --- Outputs from this function are returned to the command line.
function varargout = subgui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in resultsprevbutton.
function resultsprevbutton_Callback(hObject, eventdata, handles)
    % hObject    handle to resultsprevbutton (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    
    for i = 1:8
        set(handles.(strcat('resultspanel', num2str(i))), 'visible', 'off');
    end

    handles.currentpage = handles.currentpage - 1;
    set(handles.resultspageindex, 'String', strcat(num2str(handles.currentpage), '/', num2str(handles.totalpages)));
    set(handles.resultsnextbutton, 'Enable', 'on');
    if handles.currentpage == 1
        set(handles.resultsprevbutton, 'Enable', 'off');
    end
    
    margin = 8 * (handles.currentpage - 1);
    currentImages = handles.totalimages - margin;
    for i = 1:min(currentImages, 8)
        axes(handles.(strcat('resultsimage', num2str(i))));
        imshow(handles.results{i + margin, 1});
        [~, name, ~] = fileparts(handles.results{i + margin, 1});
        name = name(1:length(name) - 5);
        set(handles.(strcat('resultspanel', num2str(i))), 'visible', 'on');
        set(handles.(strcat('resultsdistance', num2str(i))), 'String', strcat('name: ', name,' | percent match:   ', num2str(handles.results{i + margin, 2}), '%'));
    end
    
    guidata(hObject, handles);

% --- Executes on button press in resultsnextbutton.
function resultsnextbutton_Callback(hObject, eventdata, handles)
    % hObject    handle to resultsnextbutton (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    
    for i = 1:8
        set(handles.(strcat('resultspanel', num2str(i))), 'visible', 'off');
    end

    handles.currentpage = handles.currentpage + 1;
    set(handles.resultspageindex, 'String', strcat(num2str(handles.currentpage), '/', num2str(handles.totalpages)));
    set(handles.resultsprevbutton, 'Enable', 'on');
    if handles.currentpage == handles.totalpages
        set(handles.resultsnextbutton, 'Enable', 'off');
    end
    
    margin = 8 * (handles.currentpage - 1);
    currentImages = handles.totalimages - margin;
    for i = 1:min(currentImages, 8)
        axes(handles.(strcat('resultsimage', num2str(i))));
        imshow(handles.results{i + margin, 1});
        [~, name, ~] = fileparts(handles.results{i + margin, 1});
        name = name(1:length(name) - 5);
        set(handles.(strcat('resultspanel', num2str(i))), 'visible', 'on');
        set(handles.(strcat('resultsdistance', num2str(i))), 'String', strcat('name: ', name,' | percent match:   ', num2str(handles.results{i + margin, 2}), '%'));
    end
    
    guidata(hObject, handles);
    
