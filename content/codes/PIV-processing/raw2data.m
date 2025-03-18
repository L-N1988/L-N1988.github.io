%{
    raw2data.m
    ----------------------------
    This script processes PIVLab-exported `.mat` files to calculate turbulence 
    statistical parameters. It performs the following steps:

    1. **Load Data**:
       - Loads the PIVLab `.mat` file containing velocity field data.
       - Extracts the spatial grid (X, Y) and validates the data.

    2. **Data Validation**:
       - Filters out invalid, non-numerical, or masked data based on the 
         `typevector` field from PIVLab.

    3. **Statistical Processing**:
       - Computes time-averaged velocity components (U_t, V_t).
       - Calculates double-averaged velocity components (U_xt, V_xt).
       - Derives turbulent velocity components (u', v').
       - Computes second-order moments (Reynolds shear stress, TKE).
       - Computes third-order moments (skewness-related terms).
       - Calculates root-mean-square (RMS) turbulence strengths.

    4. **Save Results**:
       - Saves processed statistical data (e.g., U_xt, V_xt, RSS, TKE, RMS) 
         to a `.mat` file for further analysis or visualization.

    5. **Optional Power Spectral Analysis**:
       - Prompts the user to perform power spectral analysis if desired.
       - If selected, calls the `PSD` function with the sampling frequency.

    Input:
    - PIVLab `.mat` file containing velocity field data.

    Output:
    - Processed statistical data saved as `.mat` files in the `figure_data` folder.

    Notes:
    - Ensure the PIVLab `.mat` file is correctly exported and placed in the 
      `normalized_data` folder relative to the script's path.
    - The script assumes a specific data structure from PIVLab exports.

    References:
    - PIVLab Toolbox: https://pivlab.blogspot.com/
    - Turbulence Theory: https://www.mit.edu/course/1/1.061/www/dream/SEVEN/SEVENTHEORY.PDF
    - PIVLab Google Group: https://groups.google.com/g/PIVlab/c/VzAyrOt-Gvw?pli=1
%}

% PIVLab frame data format
%         o--------o
%        /        /|
%       /        / |
%      o--------o  |
%      |        |  o
% mRows|        | /
%      |        |/ nFrame
%      o--------o
%         nCols
%%
clc; clear; close all;
casePath = '..';
data = load(fullfile(casePath, 'normalized_data', 'PIVlab.mat'));
%%
xmesh = data.x{1, 1}; X = xmesh(1, :);
ymesh = data.y{1, 1}; Y = ymesh(:, 1);
fprintf(['Measure domain: \n'...
    'X from %.5f to %.5f, nX = %d, dX = %.5f.\n'...
    'Y from %.5f to %.5f, nY = %d, dY = %.5f.\n'], ...
    X(1), X(end), length(X), mean(diff(X)), Y(end), Y(1), length(Y), mean(abs(diff(Y))));

if isempty(data.u_filtered{1}) && isempty(data.v_filtered{1})
    warning('Data not fileted in PIVLab. Mat file may contains some abnormal data.')
    u_filtered = data.u_original;
    v_filtered = data.v_original;
    typevector = data.typevector_original;
else
    u_filtered = data.u_filtered;
    v_filtered = data.v_filtered;
    typevector = data.typevector_filtered;
end

% Convert cell array to 3d matrix
u_filtered = cat(3, u_filtered{:});
v_filtered = cat(3, v_filtered{:});
typevector = cat(3, typevector{:});

% Remove non-numerical and mask data
% Ask Groq3 beta and correct by deepseek
% https://groups.google.com/g/PIVlab/c/VzAyrOt-Gvw?pli=1
% 0: The vector is masked and excluded from analysis.​
% 1: The vector is valid and included in the analysis.​
% 2: The vector has been identified as erroneous and filtered out during the validation process.
validVector = (typevector ~= 0);
u_filtered = u_filtered .* validVector .* (~isnan(u_filtered)) .* (~isinf(u_filtered));
v_filtered = v_filtered .* validVector .* (~isnan(v_filtered)) .* (~isinf(v_filtered));
nValidFrame = sum(validVector, 3);

%% Statistic process
% READ FIRST: https://www.mit.edu/course/1/1.061/www/dream/SEVEN/SEVENTHEORY.PDF

% Time average velocity of each cell
U_t = sum(u_filtered, 3) ./ nValidFrame;
V_t = sum(v_filtered, 3) ./ nValidFrame;

% Double average velocity
% Vector
U_xt = mean(U_t, 2); % average in x/column direction
V_xt = mean(V_t, 2); % average in x/column direction

% Double average component
% FIXME: this should be same as U_xt or V_xt, but not?
% U_xt = sum(sum(u_filtered{:}]), 2) ./ sum(nValidFrame, 2);
% V_xt = sum(sum(v_filtered{:}]), 2) ./ sum(nValidFrame, 2);

% Turbulent velocity
u_pri = u_filtered - U_t; % u'
v_pri = v_filtered - V_t; % v'

% Cross- or self- correlation, second moment
uv = u_pri .* v_pri; % u'v' Reynold shear stress
uu = u_pri.^2; % u'u' TKE of u
vv = v_pri.^2; % v'v' TKE of v

% Third moment
uuu = u_pri.^3;
vvv = v_pri.^3;

% Time average
uv_t  = sum(uv, 3) ./ nValidFrame;
uu_t  = sum(uu, 3) ./ nValidFrame;
vv_t  = sum(vv, 3) ./ nValidFrame;
uuu_t = sum(uuu, 3)./ nValidFrame;
vvv_t = sum(vvv, 3) ./ nValidFrame;

% Double average: average in time direction then in x direction
uv_xt  = mean(uv_t, 2); % u'v'
RSS    = -1 * uv_xt; % Reynold shear stress
uu_xt  = mean(uu_t, 2); % u'u' TKE of u
vv_xt  = mean(vv_t, 2); % v'v' TKE of v
uuu_xt = mean(uuu_t, 2); % u'u'u' third moment of u
vvv_xt = mean(vvv_t, 2);
% rms means space average of stdandard deviation
u_rms = mean(sqrt(uu_t), 2); % turbulence strength of u
v_rms = mean(sqrt(vv_t), 2); % turbulence strength of v

save(fullfile(casePath, 'figure_data', 'u_stat.mat'), 'xmesh', 'X', 'ymesh', 'Y', 'U_xt', 'V_xt', 'RSS', 'uu_xt', 'vv_xt', 'u_rms', 'v_rms', 'uuu_xt', 'vvv_xt');
save(fullfile(casePath, 'figure_data', 'u4pxx.mat'), '-v7.3', 'xmesh', 'X', 'ymesh', 'Y', 'U_t', 'V_t', 'u_pri', 'v_pri');

%%
prompt = "Do you want power spectral analysis? Y/N [N]: ";
txt = input(prompt,"s");
if isempty(txt)
    txt = 'N';
end
if txt == 'Y' || txt == 'y'
    Fs = input('PIV sampe frequency [fps]?');
    PSD(casePath, Fs);
else
    % Place holder
end

