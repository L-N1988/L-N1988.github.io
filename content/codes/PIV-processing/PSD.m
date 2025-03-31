% PSD.m
%
% This script processes velocity data to compute the Power Spectral Density (PSD)
% using Welch's method. It performs the following steps:
% 1. Clears the workspace, closes all figures, and clears the command window.
% 2. Loads velocity data from a specified file.
% 3. Computes the PSD for each spatial point in the velocity data using Welch's method.
% 4. Applies a 3x3 moving average filter to smooth the PSD data.
% 5. Saves the processed PSD data to a .mat file for further analysis.
%
% Key Variables:
% - casePath: Path to the case directory containing the input data.
% - Fs: Sampling frequency (Hz).
% - X, Y: Spatial coordinates of the velocity data.
% - xmesh, ymesh: Mesh grids for the spatial coordinates.
% - U_xt: Mean velocity over time.
% - u_pri: Primary velocity data (3D matrix).
% - window_length: Length of the window used in Welch's method.
% - nfft: Number of FFT points (next power of 2 of window_length).
% - fs: Frequency matrix (3D matrix).
% - pxxs: PSD matrix (3D matrix).
%
% Functions:
% - patch_moving_average_conv: Computes a moving average using convolution
%   with a specified kernel. Used to smooth the PSD data.
%
% Outputs:
% - Saves the processed PSD data (fs, pxxs) along with spatial coordinates
%   (X, Y, xmesh, ymesh) and mean velocity (U_xt) to 'pxxs.mat'.
%
% Notes:
% - The script uses a 3x3 moving average filter for smoothing.
% - Welch's method is applied to each spatial point in the velocity data.
% - The PSD is visualized on a log-log scale during computation.
% Clear workspace, close all figures, and clear command window
clc; clear; close all;

% Define the path to the case directory and sampling frequency
casePath = '..';
Fs = 1100; % Sampling frequency (Hz) edited by YZ

% Load the data from the specified file
data = load(fullfile(casePath, 'figure_data', 'u4pxx.mat'));
X = data.X; % X-coordinates
Y = data.Y; % Y-coordinates
xmesh = data.xmesh; % X-mesh grid
ymesh = data.ymesh; % Y-mesh grid
U_xt = mean(data.U_t, 2); % Mean velocity over time
u_pri = data.u_pri; % Primary velocity data

% Get the dimensions of the velocity data
[m, n, ~] = size(u_pri);

% Define the window length for Welch's method and calculate FFT parameters
window_length = 8000; % Length of the window for Welch's method
nfft = 2^nextpow2(window_length); % Next power of 2 for FFT
output_length = nfft/2 + 1; % Output length for real-valued input

% Initialize matrices to store frequency and power spectral density (PSD)
fs = zeros(m, n, output_length); % Frequency matrix
pxxs = zeros(m, n, output_length); % PSD matrix

% Loop through each spatial point to compute PSD using Welch's method
for ii = 1:m
    for jj = 1:n
        % Compute PSD and frequency using Welch's method
        [pxxs(ii, jj, :), fs(ii, jj, :)] = pwelch(squeeze(u_pri(ii, jj, :)), ...
            window_length, [], [], Fs);
        
        % Plot the PSD on a log-log scale for visualization
        loglog(squeeze(fs(ii, jj, :)), squeeze(pxxs(ii, jj, :)));
    end
end

% Define the window size for moving average (3x3)
window_size = 3;
kernel = ones(window_size, window_size); % 3x3 matrix of ones

% Apply a 3x3 moving average filter to smooth the PSD data
pxxs = patch_moving_average_conv(pxxs, kernel);

% Save the processed data to a .mat file
save(fullfile(casePath, 'figure_data', 'pxxs.mat'), 'X', 'xmesh', 'Y', 'ymesh', 'fs', 'pxxs', 'U_xt');

% Function to compute a moving average using convolution
function moving_avg_matrix = patch_moving_average_conv(matrix, kernel)
    % Input: matrix (e.g., 6x10), kernel (e.g., 3x3)
    % Output: moving_avg_matrix with the same size as input, containing averages
    
    % Perform convolution with 'same' to keep output size equal to input
    conv_result = convn(matrix, kernel, 'same');
    
    % Create a matrix to count how many elements contribute at each position
    contrib_count = convn(ones(size(matrix)), kernel, 'same');
    
    % Compute the moving average by dividing the sum by the number of contributing elements
    moving_avg_matrix = conv_result ./ contrib_count;
end
