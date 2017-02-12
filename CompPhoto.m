function varargout = CompPhoto(varargin)
% COMPPHOTO MATLAB code for CompPhoto.fig
%      COMPPHOTO, by itself, creates a new COMPPHOTO or raises the existing
%      singleton*.
%
%      H = COMPPHOTO returns the handle to a new COMPPHOTO or the handle to
%      the existing singleton*.
%
%      COMPPHOTO('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in COMPPHOTO.M with the given input arguments.
%
%      COMPPHOTO('Property','Value',...) creates a new COMPPHOTO or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before CompPhoto_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to CompPhoto_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help CompPhoto

% Last Modified by GUIDE v2.5 29-Apr-2016 11:21:51

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @CompPhoto_OpeningFcn, ...
                   'gui_OutputFcn',  @CompPhoto_OutputFcn, ...
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


% --- Executes just before CompPhoto is made visible.
function CompPhoto_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to CompPhoto (see VARARGIN)

% Choose default command line output for CompPhoto


% Update handles structure
guidata(hObject, handles);

% UIWAIT makes CompPhoto wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = CompPhoto_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in gray.
function gray_Callback(hObject, eventdata, handles)
% hObject    handle to gray (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.Gray_filename = uigetfile;
handles.output = hObject;
handles.state_xyz = 0;
handles.state_bard = 0;
handles.state_kries = 0;
handles.state_ratio = 0;
handles.state_average = 0;

guidata(hObject, handles);


% --- Executes on button press in noflash.
function noflash_Callback(hObject, eventdata, handles)
% hObject    handle to noflash (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.noflash_filename = uigetfile;
guidata(hObject, handles);


% --- Executes on button press in flash.
function flash_Callback(hObject, eventdata, handles)
% hObject    handle to flash (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.flash_filename = uigetfile;
guidata(hObject, handles);


% --- Executes on button press in XYZ.
function XYZ_Callback(hObject, eventdata, handles)
% hObject    handle to XYZ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of XYZ
handles.state_xyz = get(hObject,'Value');
guidata(hObject, handles);


% --- Executes on button press in Bardford.
function Bardford_Callback(hObject, eventdata, handles)
% hObject    handle to Bardford (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Bardford
handles.state_bard = get(hObject,'Value');
guidata(hObject, handles);


% --- Executes on button press in vonKries.
function vonKries_Callback(hObject, eventdata, handles)
% hObject    handle to vonKries (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of vonKries
handles.state_kries = get(hObject,'Value');
guidata(hObject, handles);


% --- Executes on button press in RUNprog.
function RUNprog_Callback(hObject, eventdata, handles)
% hObject    handle to RUNprog (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if (handles.state_kries == 1)
    state = 'vonKries';
elseif (handles.state_bard == 1)
    state = 'bradford';
else
    state = 'a';
end

if (handles.state_ratio == 1)
    mask = 'R';
else
    mask = 'A';
end
[finalimage, flashimage, noflashimage] = whiteBalance(handles.Gray_filename, handles.noflash_filename, handles.flash_filename, state, mask);
figure; imshow(flashimage); title('input image with flash');
figure; imshow(noflashimage); title('input image without flash');
figure; imshow(finalimage);title('White balanced image');
%imwrite(finalimage, 'balanced.jpg', 'Quality' , 100);
%imwrite(flashimage, 'flash.jpg', 'Quality' , 100);
%imwrite(noflashimage, 'noflash.jpg', 'Quality' , 100);


% --- Executes on button press in ratio.
function ratio_Callback(hObject, eventdata, handles)
% hObject    handle to ratio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ratio
handles.state_ratio = get(hObject,'Value');
guidata(hObject, handles);


% --- Executes on button press in average.
function average_Callback(hObject, eventdata, handles)
% hObject    handle to average (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of average
handles.state_average = get(hObject,'Value');
guidata(hObject, handles);
