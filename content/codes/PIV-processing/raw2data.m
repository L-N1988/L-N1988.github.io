% PIVLab frame data format
% This section describes the 3D data structure used in PIVLab, where the data is organized as a 3D matrix
% with dimensions corresponding to rows (mRows), columns (nCols), and frames (nFrame).

% Clear workspace, close figures, and initialize
clc; clear; close all;

% Load PIVLab data from a specified file
casePath = '..';
data = load(fullfile(casePath, 'normalized_data', 'PIVlab.mat'));

% Extract spatial mesh grids and display measurement domain information
xmesh = data.x{1, 1}; X = xmesh(1, :);
ymesh = data.y{1, 1}; Y = ymesh(:, 1);
fprintf(['Measure domain: \n'...
    'X from %.5f to %.5f, nX = %d, dX = %.5f.\n'...
    'Y from %.5f to %.5f, nY = %d, dY = %.5f.\n'], ...
    X(1), X(end), length(X), mean(diff(X)), Y(end), Y(1), length(Y), mean(abs(diff(Y))));

% Check if filtered data is available; otherwise, use original data
if isempty(data.u_filtered{1}) && isempty(data.v_filtered{1})
    warning('Data not filtered in PIVLab. Mat file may contain abnormal data.')
    u_filtered = data.u_original;
    v_filtered = data.v_original;
    typevector = data.typevector_original;
else
    u_filtered = data.u_filtered;
    v_filtered = data.v_filtered;
    typevector = data.typevector_filtered;
end

% Convert cell arrays to 3D matrices for further processing
u_filtered = cat(3, u_filtered{:});
v_filtered = cat(3, v_filtered{:});
typevector = cat(3, typevector{:});

% Remove invalid, NaN, and infinite data based on typevector
% Valid vectors are identified by typevector values (0: masked, 1: valid, 2: erroneous)
validVector = (typevector ~= 0);
u_filtered = u_filtered .* validVector .* (~isnan(u_filtered)) .* (~isinf(u_filtered));
v_filtered = v_filtered .* validVector .* (~isnan(v_filtered)) .* (~isinf(v_filtered));
nValidFrame = sum(validVector, 3); % Count valid frames for each cell

% Statistical processing
% Compute time-averaged velocity for each cell
U_t = sum(u_filtered, 3) ./ nValidFrame;
V_t = sum(v_filtered, 3) ./ nValidFrame;

% Compute double-averaged velocity (spatial average in x-direction)
U_xt = mean(U_t, 2);
V_xt = mean(V_t, 2);

% Compute turbulent velocity components (fluctuations)
u_pri = u_filtered - U_t; % u'
v_pri = v_filtered - V_t; % v'

% Compute second moments (Reynolds shear stress and turbulent kinetic energy)
uv = u_pri .* v_pri; % u'v'
uu = u_pri.^2; % u'u'
vv = v_pri.^2; % v'v'

% Compute third moments (skewness-related terms)
uuu = u_pri.^3;
vvv = v_pri.^3;

% Compute time-averaged second and third moments
uv_t  = sum(uv, 3) ./ nValidFrame;
uu_t  = sum(uu, 3) ./ nValidFrame;
vv_t  = sum(vv, 3) ./ nValidFrame;
uuu_t = sum(uuu, 3) ./ nValidFrame;
vvv_t = sum(vvv, 3) ./ nValidFrame;

% Compute double-averaged second and third moments (spatial average in x-direction)
uv_xt  = mean(uv_t, 2); % u'v'
RSS    = -1 * uv_xt; % Reynolds shear stress
uu_xt  = mean(uu_t, 2); % u'u'
vv_xt  = mean(vv_t, 2); % v'v'
uuu_xt = mean(uuu_t, 2); % u'u'u'
vvv_xt = mean(vvv_t, 2);

% Compute root mean square (RMS) values for turbulence strength
u_rms = mean(sqrt(uu_t), 2); % RMS of u
v_rms = mean(sqrt(vv_t), 2); % RMS of v

% Save statistical results to files
save(fullfile(casePath, 'figure_data', 'u_stat.mat'), 'xmesh', 'X', 'ymesh', 'Y', 'U_xt', 'V_xt', 'RSS', 'uu_xt', 'vv_xt', 'u_rms', 'v_rms', 'uuu_xt', 'vvv_xt');
save(fullfile(casePath, 'figure_data', 'u4pxx.mat'), '-v7.3', 'xmesh', 'X', 'ymesh', 'Y', 'U_t', 'V_t', 'u_pri', 'v_pri');

% Prompt user for power spectral analysis
prompt = "Do you want power spectral analysis? Y/N [N]: ";
txt = input(prompt, "s");
if isempty(txt)
    txt = 'N';
end
if txt == 'Y' || txt == 'y'
    % Perform power spectral density (PSD) analysis if user opts in
    Fs = input('PIV sample frequency [fps]?');
    PSD(casePath, Fs);
else
    % Placeholder for no action
end
