function varargout = scara(varargin)
% SCARA MATLAB code for scara.fig
%      SCARA, by itself, creates a new SCARA or raises the existing
%      singleton*.
%
%      H = SCARA returns the handle to a new SCARA or the handle to
%      the existing singleton*.
%
%      SCARA('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SCARA.M with the given input arguments.
%
%      SCARA('Property','Value',...) creates a new SCARA or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before scara_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to scara_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help scara

% Last Modified by GUIDE v2.5 05-Dec-2023 21:33:10

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @scara_OpeningFcn, ...
                   'gui_OutputFcn',  @scara_OutputFcn, ...
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


% --- Executes just before scara is made visible.
function scara_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to scara (see VARARGIN)

% Choose default command line output for scara
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes scara wait for user response (see UIRESUME)
% uiwait(handles.figure1);
global scara
a     = [0 2 3 0 0];
alpha = [0 0 180 0 0];
d     = [2.51 0 0 0 0.875];
theta = [0 0 -90 0 0];
type = ['b', 'r', 'r', 'p', 'r'];
base = [0; 0; 0];
scara = ArmScara(a, alpha, d, theta, type, base);
% scara = scara.set_joint_variable(2, pi/2 + deg2rad(get(handles.q1_slider, 'Value')));
% scara = scara.set_joint_variable(3, deg2rad(get(handles.q2_slider, 'Value')));
% scara = scara.set_joint_variable(4, get(handles.q3_slider, 'Value'));
% scara = scara.set_joint_variable(5, deg2rad(get(handles.q4_slider, 'Value')));
scara = scara.update();
set_ee_params(scara, handles);
scara.plot(handles.axes1, get(handles.coords,'Value'), get(handles.workspace,'Value'));


% --- Outputs from this function are returned to the command line.
function varargout = scara_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on slider movement.
%%
function q2_slider_Callback(hObject, eventdata, handles)
% hObject    handle to q2_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global scara
x = deg2rad(get(handles.q2_slider, 'Value'));
q2value = get(handles.q2_slider, 'Value');
set(handles.q2value, 'String', num2str(q2value));
denta_x = (x - scara.theta(3))/50;
for i = 1:50
 scara.theta(3)= scara.theta(3) + denta_x;
scara = scara.update();
set_ee_params(scara, handles);
scara.plot(handles.axes1, get(handles.coords,'Value'), get(handles.workspace,'Value'));
end

% --- Executes during object creation, after setting all properties.
function q2_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to q2_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

%%
% --- Executes on button press in workspace.
function workspace_Callback(hObject, eventdata, handles)
% hObject    handle to workspace (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of workspace
global scara
scara.plot(handles.axes1, get(handles.coords,'Value'), get(handles.workspace,'Value'));

% --- Executes on button press in coords.
function coords_Callback(hObject, eventdata, handles)
% hObject    handle to coords (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of coords
global scara
scara.plot(handles.axes1, get(handles.coords,'Value'), get(handles.workspace,'Value'));

%%
% --- Executes on slider movement.
function q3_slider_Callback(hObject, eventdata, handles)
% hObject    handle to q3_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global scara
x = get(handles.q3_slider, 'Value');
q3value = get(handles.q3_slider, 'Value');
set(handles.q3value, 'String', num2str(q3value));
denta_x = (x - scara.d(4))/20;
for i = 1:20
scara.d(4)= scara.d(4) + denta_x;
scara = scara.update();
set_ee_params(scara, handles);
scara.plot(handles.axes1, get(handles.coords,'Value'), get(handles.workspace,'Value'));
end

% --- Executes during object creation, after setting all properties.
function q3_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to q3_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
%%

% --- Executes on slider movement.
function q4_slider_Callback(hObject, eventdata, handles)
% hObject    handle to q4_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global scara
x = deg2rad(get(handles.q4_slider, 'Value'));
q4value = get(handles.q4_slider, 'Value');
set(handles.q4value, 'String', num2str(q4value));
denta_x = (x - scara.theta(5))/50;
for i = 1:50
 scara.theta(5)= scara.theta(5) + denta_x;
scara = scara.update();
set_ee_params(scara, handles);
scara.plot(handles.axes1, get(handles.coords,'Value'), get(handles.workspace,'Value'));
end
% --- Executes during object creation, after setting all properties.
function q4_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to q4_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

%%
% --- Executes on slider movement.
function q1_slider_Callback(hObject, eventdata, handles)
% hObject    handle to q1_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global scara
x = deg2rad(get(handles.q1_slider, 'Value'));
q1value = get(handles.q1_slider, 'Value');
set(handles.q1value, 'String', num2str(q1value));
denta_x = (x - scara.theta(2))/50;
for i = 1:50
 scara.theta(2)= scara.theta(2) + denta_x;
scara = scara.update();
set_ee_params(scara, handles);
scara.plot(handles.axes1, get(handles.coords,'Value'), get(handles.workspace,'Value'));
end
% --- Executes during object creation, after setting all properties.
function q1_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to q1_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
%%
function q1value_Callback(hObject, eventdata, handles)
% hObject    handle to q1value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of q1value as text
%        str2double(get(hObject,'String')) returns contents of q1value as a double


% --- Executes during object creation, after setting all properties.
function q1value_CreateFcn(hObject, eventdata, handles)
% hObject    handle to q1value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function q3value_Callback(hObject, eventdata, handles)
% hObject    handle to q3value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of q3value as text
%        str2double(get(hObject,'String')) returns contents of q3value as a double

% --- Executes during object creation, after setting all properties.
function q3value_CreateFcn(hObject, eventdata, handles)
% hObject    handle to q3value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function q4value_Callback(hObject, eventdata, handles)
% hObject    handle to q4value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of q4value as text
%        str2double(get(hObject,'String')) returns contents of q4value as a double


% --- Executes during object creation, after setting all properties.
function q4value_CreateFcn(hObject, eventdata, handles)
% hObject    handle to q4value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function q2value_Callback(hObject, eventdata, handles)
% hObject    handle to q2value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of q2value as text
%        str2double(get(hObject,'String')) returns contents of q2value as a double


% --- Executes during object creation, after setting all properties.
function q2value_CreateFcn(hObject, eventdata, handles)
% hObject    handle to q2value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function x_start_Callback(hObject, eventdata, handles)
% hObject    handle to x_start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of x_start as text
%        str2double(get(hObject,'String')) returns contents of x_start as a double


% --- Executes during object creation, after setting all properties.
function x_start_CreateFcn(hObject, eventdata, handles)
% hObject    handle to x_start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function y_start_Callback(hObject, eventdata, handles)
% hObject    handle to y_start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of y_start as text
%        str2double(get(hObject,'String')) returns contents of y_start as a double


% --- Executes during object creation, after setting all properties.
function y_start_CreateFcn(hObject, eventdata, handles)
% hObject    handle to y_start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function z_start_Callback(hObject, eventdata, handles)
% hObject    handle to z_start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of z_start as text
%        str2double(get(hObject,'String')) returns contents of z_start as a double


% --- Executes during object creation, after setting all properties.
function z_start_CreateFcn(hObject, eventdata, handles)
% hObject    handle to z_start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function roll_start_Callback(hObject, eventdata, handles)
% hObject    handle to roll_start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of roll_start as text
%        str2double(get(hObject,'String')) returns contents of roll_start as a double


% --- Executes during object creation, after setting all properties.
function roll_start_CreateFcn(hObject, eventdata, handles)
% hObject    handle to roll_start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function pitch_start_Callback(hObject, eventdata, handles)
% hObject    handle to pitch_start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of pitch_start as text
%        str2double(get(hObject,'String')) returns contents of pitch_start as a double


% --- Executes during object creation, after setting all properties.
function pitch_start_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pitch_start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function yaw_start_Callback(hObject, eventdata, handles)
% hObject    handle to yaw_start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of yaw_start as text
%        str2double(get(hObject,'String')) returns contents of yaw_start as a double


% --- Executes during object creation, after setting all properties.
function yaw_start_CreateFcn(hObject, eventdata, handles)
% hObject    handle to yaw_start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function x_end_Callback(hObject, eventdata, handles)
% hObject    handle to x_end (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of x_end as text
%        str2double(get(hObject,'String')) returns contents of x_end as a double


% --- Executes during object creation, after setting all properties.
function x_end_CreateFcn(hObject, eventdata, handles)
% hObject    handle to x_end (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function y_end_Callback(hObject, eventdata, handles)
% hObject    handle to y_end (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of y_end as text
%        str2double(get(hObject,'String')) returns contents of y_end as a double


% --- Executes during object creation, after setting all properties.
function y_end_CreateFcn(hObject, eventdata, handles)
% hObject    handle to y_end (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function z_end_Callback(hObject, eventdata, handles)
% hObject    handle to z_end (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of z_end as text
%        str2double(get(hObject,'String')) returns contents of z_end as a double


% --- Executes during object creation, after setting all properties.
function z_end_CreateFcn(hObject, eventdata, handles)
% hObject    handle to z_end (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function roll_end_Callback(hObject, eventdata, handles)
% hObject    handle to roll_end (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of roll_end as text
%        str2double(get(hObject,'String')) returns contents of roll_end as a double


% --- Executes during object creation, after setting all properties.
function roll_end_CreateFcn(hObject, eventdata, handles)
% hObject    handle to roll_end (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function pitch_end_Callback(hObject, eventdata, handles)
% hObject    handle to pitch_end (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of pitch_end as text
%        str2double(get(hObject,'String')) returns contents of pitch_end as a double


% --- Executes during object creation, after setting all properties.
function pitch_end_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pitch_end (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function yaw_end_Callback(hObject, eventdata, handles)
% hObject    handle to yaw_end (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of yaw_end as text
%        str2double(get(hObject,'String')) returns contents of yaw_end as a double


% --- Executes during object creation, after setting all properties.
function yaw_end_CreateFcn(hObject, eventdata, handles)
% hObject    handle to yaw_end (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
%%

% --- Executes on button press in motion_btn.
function motion_btn_Callback(hObject, eventdata, handles)
% hObject    handle to motion_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global scara
p0 = zeros(1, 6);
p0(1) = str2double(get(handles.x_start, 'String'));
p0(2) = str2double(get(handles.y_start, 'String'));
p0(3) = str2double(get(handles.z_start, 'String'));
p0(4) = deg2rad(str2double(get(handles.roll_start, 'String')));
p0(5) = deg2rad(str2double(get(handles.pitch_start, 'String')));
p0(6) = deg2rad(str2double(get(handles.yaw_start, 'String')));

pf = zeros(1, 6);
pf(1) = str2double(get(handles.x_end, 'String'));
pf(2) = str2double(get(handles.y_end, 'String'));
pf(3) = str2double(get(handles.z_end, 'String'));
pf(4) = deg2rad(str2double(get(handles.roll_end, 'String')));
pf(5) = deg2rad(str2double(get(handles.pitch_end, 'String')));
pf(6) = deg2rad(str2double(get(handles.yaw_end, 'String')));
% p2 = [0 6.5 2.5 180 0 0];

v_max = str2double(get(handles.v_max, 'String'));
a_max = str2double(get(handles.a_max, 'String'));
t_max = str2double(get(handles.t_max, 'String'));
q_max = sqrt((pf(1) - p0(1))^2 + (pf(2) - p0(2))^2 + (pf(3) - p0(3))^2);

contents = cellstr(get(handles.profile, 'String'));
profile = contents{get(handles.profile, 'Value')};

%joint = inverse_kinematics(scara.a, scara.alpha, scara.d, scara.theta, p0);
%scara.theta(2) = joint(1);
%scara.theta(3) = joint(2);
%scara.theta(5) = joint(4);
%scara.d(4) = joint(3);
%scara = scara.update();
%scara.plot(handles.axes1, get(handles.coords,'Value'), get(handles.workspace,'Value'));

 if strcmp(profile, 'LSPB')
    [t, q, qdot, q2dot] = LSPB_trajectory(q_max, v_max, a_max);
elseif strcmp(profile, 'Quintic')
    [t, q, qdot, q2dot] = quintic_trajectory(0, t_max, 0, 0, 0, q_max, 0, 0);
 elseif strcmp(profile, 'Scurve')
    [t, q, qdot, q2dot] = Scurve_trajectory(q_max, v_max, a_max)
 end

   [t, p, pdot, p2dot] = linear_interpolation(p0, pf, t, q, qdot, q2dot);
   %%

    
    theta1 = zeros(2, length(t));
    theta2 = zeros(2, length(t));
    d3 = zeros(2, length(t));
    theta4 = zeros(2, length(t));
   %%

for i = 1:length(t)
    point = [p(1,i), p(2,i), p(3,i), 0, 0, wrapToPi(p(6,i))];
    joint = inverse_kinematics(scara.a, scara.alpha, scara.d, scara.theta, point);

    theta1(1,i) = i;
    theta2(1,i) = i;
    d3(1,i) = i;
    theta4(1,i) = i;

    theta1(2,i) = joint(1);
    theta2(2,i) = joint(2);
    d3(2,i) = joint(3);
    theta4(2,i) = joint(4);

    save('theta1.mat', 'theta1','-v7.3');
    save('theta2.mat', 'theta2','-v7.3');
    save('d3.mat', 'd3','-v7.3');
    save('theta4.mat', 'theta4','-v7.3');

    scara.theta(2) = joint(1);
    scara.theta(3) = joint(2);
    scara.theta(5) = joint(4);
    scara.d(4) = joint(3);
    scara = scara.update();

    jointdot(:,i) = pinv(scara.J)*pdot(:,i);

    set_joints_params(scara, handles);
    set_ee_params(scara, handles);
    scara.plot(handles.axes1, get(handles.coords,'Value'), get(handles.workspace,'Value'));

%     %%
     plot(handles.pxplot, t(1:i), p(1,1:i), 'b-');
     plot(handles.pyplot, t(1:i), p(2,1:i), 'b-');
     plot(handles.pzplot, t(1:i), p(3,1:i), 'b-');
    %%
      plot(handles.joint1dot, t(1:i), jointdot(2,1:i), 'b-');
      plot(handles.joint2dot, t(1:i), jointdot(3,1:i), 'b-');
      plot(handles.joint3dot, t(1:i), jointdot(4,1:i), 'b-');
      plot(handles.joint4dot, t(1:i), jointdot(5,1:i), 'b-');
    %%
     plot(handles.qaxes, t(1:i), q(1:i), 'b-');
     plot(handles.vaxes, t(1:i), qdot(1:i), 'b-');
     plot(handles.aaxes, t(1:i), q2dot(1:i), 'b-');
    %%
     plot3(handles.axes1, p(1,1:i), p(2,1:i), p(3,1:i), 'LineWidth', 2, 'Color', [0.8500 0.3250 0.0980]);
     pause(t(100)/100)
   
end
    
   
    

 

%%
% --- Executes on selection change in profile.
function profile_Callback(hObject, eventdata, handles)
% hObject    handle to profile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns profile contents as cell array
%        contents{get(hObject,'Value')} returns selected item from profile


% --- Executes during object creation, after setting all properties.
function profile_CreateFcn(hObject, eventdata, handles)
% hObject    handle to profile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function v_max_Callback(hObject, eventdata, handles)
% hObject    handle to v_max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of v_max as text
%        str2double(get(hObject,'String')) returns contents of v_max as a double


% --- Executes during object creation, after setting all properties.
function v_max_CreateFcn(hObject, eventdata, handles)
% hObject    handle to v_max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function a_max_Callback(hObject, eventdata, handles)
% hObject    handle to a_max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of a_max as text
%        str2double(get(hObject,'String')) returns contents of a_max as a double


% --- Executes during object creation, after setting all properties.
function a_max_CreateFcn(hObject, eventdata, handles)
% hObject    handle to a_max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function t_max_Callback(hObject, eventdata, handles)
% hObject    handle to t_max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of t_max as text
%        str2double(get(hObject,'String')) returns contents of t_max as a double


% --- Executes during object creation, after setting all properties.
function t_max_CreateFcn(hObject, eventdata, handles)
% hObject    handle to t_max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in plot_type.
function plot_type_Callback(hObject, eventdata, handles)
% hObject    handle to plot_type (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns plot_type contents as cell array
%        contents{get(hObject,'Value')} returns selected item from plot_type
contents = cellstr(get(handles.plot_type, 'String'));
plot_type = contents{get(handles.plot_type, 'Value')};

if strcmp(plot_type, 'Task Space')
    set(handles.plot_task, 'Visible', 'on');
    set(handles.plot_jointdot, 'Visible', 'off');
    set(handles.plot_trajectory, 'Visible', 'off');
elseif strcmp(plot_type, 'Joint Space')
    set(handles.plot_jointdot, 'Visible', 'on');
    set(handles.plot_task, 'Visible', 'off');
    set(handles.plot_trajectory, 'Visible', 'off');
elseif strcmp(plot_type, 'Trajectory')
    set(handles.plot_trajectory, 'Visible', 'on');
    set(handles.plot_task, 'Visible', 'off');
    set(handles.plot_jointdot, 'Visible', 'off');
end

% --- Executes during object creation, after setting all properties.
function plot_type_CreateFcn(hObject, eventdata, handles)
% hObject    handle to plot_type (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pid_button.
function pid_button_Callback(hObject, eventdata, handles)
% hObject    handle to pid_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    [t1out, t2out, d3out, t4out, tout]= run_simulink(t);  
    outt = tout';   
    out1 = t1out;
    save('theta1out.mat', 'out1','-v7.3');
for i = 1:length(out1)

    scara.theta(2) = t1out(i);
    scara.theta(3) = t2out(i);
    scara.theta(5) = d3out(i);
    scara.d(4) = t4out(i);
    scara = scara.update();

  %  jointdot(:,i) = pinv(scara.J)*pdot(:,i);

    set_joints_params(scara, handles);
    set_ee_params(scara, handles);
    scara.plot(handles.axes1, get(handles.coords,'Value'), get(handles.workspace,'Value'));

%     %%
%      plot(handles.pxplot, t(1:i), p(1,1:i), 'b-');
%      plot(handles.pyplot, t(1:i), p(2,1:i), 'b-');
%      plot(handles.pzplot, t(1:i), p(3,1:i), 'b-');
%     %%
%       plot(handles.joint1dot, t(1:i), jointdot(2,1:i), 'b-');
%       plot(handles.joint2dot, t(1:i), jointdot(3,1:i), 'b-');
%       plot(handles.joint3dot, t(1:i), jointdot(4,1:i), 'b-');
%       plot(handles.joint4dot, t(1:i), jointdot(5,1:i), 'b-');
%     %%
%      plot(handles.qaxes, t(1:i), q(1:i), 'b-');
%      plot(handles.vaxes, t(1:i), qdot(1:i), 'b-');
%      plot(handles.aaxes, t(1:i), q2dot(1:i), 'b-');
%     %%
%      plot3(handles.axes1, p(1,1:i), p(2,1:i), p(3,1:i), 'LineWidth', 2, 'Color', [0.8500 0.3250 0.0980]);
%      pause(t(100)/100);    
     
 end
