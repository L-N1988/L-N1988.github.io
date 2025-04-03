% This script processes and visualizes Power Spectral Density (PSD) data 
% from a given dataset. It generates multiple plots to analyze the PSD 
% and pre-multiplied PSD at different vertical positions in the dataset. 
% Additionally, it creates a contour plot to visualize the variation of 
% pre-multiplied PSD along the vertical centerline.

% The script performs the following steps:
% 1. Loads PSD data (`pxxs`) and frequency data (`fs`) from a specified file.
% 2. Extracts data at specific vertical positions (1/4, 1/2, and 3/4 of the 
%    vertical range) and plots:
%    - PSD vs frequency on a log-log scale.
%    - Pre-multiplied PSD (`f * PSD`) vs frequency on a log scale.
% 3. Extracts PSD data along the vertical centerline and interpolates it 
%    onto a finer grid for visualization.
% 4. Generates a contour plot of the pre-multiplied PSD along the vertical 
%    centerline, with frequency on the x-axis and vertical position on the 
%    y-axis.

% Key variables:
% - `fs`: Frequency data (Hz).
% - `pxxs`: PSD data (m^2/s).
% - `Y`: Vertical positions (m).
% - `ymesh`: Vertical grid positions (m).
% - `xv`, `yv`, `vv`: Data for interpolation (frequency, vertical position, 
%   and pre-multiplied PSD, respectively).
% - `xq`, `yq`, `vq`: Interpolated grid data for contour plotting.

% Notes:
% - The script uses logarithmic scaling for frequency and PSD axes to 
%   better visualize data spanning multiple orders of magnitude.
% - The contour plot provides a detailed view of how the pre-multiplied 
%   PSD varies with frequency and vertical position.
% - Ensure that the required data files are available in the specified 
%   `casePath` directory before running the script.

load(fullfile(casePath, 'figure_data', 'pxxs.mat'));

[ii_c, jj_c] = deal(round(size(fs, 1)/4), round(size(fs, 2)/4));
figure();
plot(squeeze(fs(ii_c, jj_c, :)), squeeze(pxxs(ii_c, jj_c, :)));
grid on; set(gca, 'XScale', 'log'); set(gca, 'YScale', 'log');
set(xlabel("$f$ (Hz)", "FontSize", 14), 'Interpreter', 'latex');
set(ylabel("$S_{uu}(f) (m^2/s)$", "FontSize", 14), 'Interpreter', 'latex');
set(title(sprintf("PSD at y = %.5f m", Y(jj_c)), FontSize=14), 'Interpreter', 'latex');

figure();
plot(squeeze(fs(ii_c, jj_c, :)), squeeze(fs(ii_c, jj_c, :) .* pxxs(ii_c, jj_c, :)));
grid on; set(gca, 'XScale', 'log');
set(xlabel("$f$ (Hz)", "FontSize", 14), ...
    'Interpreter', 'latex');
set(ylabel("$fS_{uu}(f) (m^2)$", "FontSize", 14), ...
    'Interpreter', 'latex');
set(title(sprintf("pre-multiplied PSD at y = %.5f m", Y(jj_c)), FontSize=14), ...
    'Interpreter', 'latex');

[ii_c, jj_c] = deal(round(size(fs, 1)/2), round(size(fs, 2)/2));
figure();
plot(squeeze(fs(ii_c, jj_c, :)), squeeze(pxxs(ii_c, jj_c, :)));
grid on; set(gca, 'XScale', 'log'); set(gca, 'YScale', 'log');
set(xlabel("$f$ (Hz)", "FontSize", 14), 'Interpreter', 'latex');
set(ylabel("$S_{uu}(f) (m^2/s)$", "FontSize", 14), 'Interpreter', 'latex');
set(title(sprintf("PSD at y = %.5f m", Y(jj_c)), FontSize=14), 'Interpreter', 'latex');

figure();
plot(squeeze(fs(ii_c, jj_c, :)), squeeze(fs(ii_c, jj_c, :) .* pxxs(ii_c, jj_c, :)));
grid on; set(gca, 'XScale', 'log');
set(xlabel("$f$ (Hz)", "FontSize", 14), ...
    'Interpreter', 'latex');
set(ylabel("$fS_{uu}(f) (m^2)$", "FontSize", 14), ...
    'Interpreter', 'latex');
set(title(sprintf("pre-multiplied PSD at y = %.5f m", Y(jj_c)), FontSize=14), ...
    'Interpreter', 'latex');

[ii_c, jj_c] = deal(round(size(fs, 1)*3/4), round(size(fs, 2)*3/4));
figure();
plot(squeeze(fs(ii_c, jj_c, :)), squeeze(pxxs(ii_c, jj_c, :)));
grid on; set(gca, 'XScale', 'log'); set(gca, 'YScale', 'log');
set(xlabel("$f$ (Hz)", "FontSize", 14), 'Interpreter', 'latex');
set(ylabel("$S_{uu}(f) (m^2/s)$", "FontSize", 14), 'Interpreter', 'latex');
set(title(sprintf("PSD at y = %.5f m", Y(jj_c)), FontSize=14), 'Interpreter', 'latex');

figure();
plot(squeeze(fs(ii_c, jj_c, :)), squeeze(fs(ii_c, jj_c, :) .* pxxs(ii_c, jj_c, :)));
grid on; set(gca, 'XScale', 'log');
set(xlabel("$f$ (Hz)", "FontSize", 14), ...
    'Interpreter', 'latex');
set(ylabel("$fS_{uu}(f) (m^2)$", "FontSize", 14), ...
    'Interpreter', 'latex');
set(title(sprintf("pre-multiplied PSD at y = %.5f m", Y(jj_c)), FontSize=14), ...
    'Interpreter', 'latex');

