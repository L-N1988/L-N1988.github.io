%{
mergePxxPlot.m

This script processes and visualizes pre-multiplied power spectral density (PSD) data 
from a merged dataset. The script performs the following tasks:

1. **Load Data**:
    - Loads the merged PSD data from a `.mat` file (`merged_pxx.mat`).

2. **Preprocess Data**:
    - Extracts frequency (`f_merge`), vertical positions (`Y_merge`), and PSD values (`pxx_merge`).
    - Computes pre-multiplied PSD values (`f * S_uu(f)`).

3. **Generate Individual PSD Plots**:
    - Creates and saves individual PSD plots for each vertical position (`z`).
    - Saves the plots in a specified output folder (`mergePSD-figure`) as `.png` files.

4. **Generate Combined PSD Plot**:
    - Selects specific vertical positions (`z`) for visualization.
    - Normalizes the selected `z` values for color mapping.
    - Plots the selected PSD data with a color gradient based on vertical position.
    - Adds a colorbar to indicate the mapping of colors to `z` values.
    - Saves the combined plot as `.fig`, `.emf`, and high-resolution `.jpg` files.

5. **Interpolate Data**:
    - Interpolates the PSD data onto a finer grid for contour plotting.
    - Uses logarithmic spacing for frequency (`f`) and linear spacing for vertical positions (`z`).

6. **Generate Contour Plot**:
    - Creates a filled contour plot of the interpolated PSD data.
    - Configures axes, labels, and colorbar with LaTeX formatting.
    - Uses a custom colormap (`sky`) for visualization.

Dependencies:
- Requires the `merged_pxx.mat` file containing the following variables:
  - `f_merge`: Frequency data (Hz).
  - `Y_merge`: Vertical positions (m).
  - `pxx_merge`: PSD values.
- Requires the `sky` colormap function for custom color mapping.

Output:
- Individual PSD plots saved in the `mergePSD-figure` folder.
- Combined PSD plot saved as `.fig`, `.emf`, and `.jpg` files.
- Contour plot displayed with interpolated PSD data.

Notes:
- Ensure the `merged_pxx.mat` file is in the same directory as the script or provide the correct path.
- The `sky` colormap function must be available in the MATLAB path.

Author: L-N1988
Date: 2025-3-30
%}
clc; clear; close all;
mergeData = load('merged_pxx.mat');

% Measuring points along vertical centre line
xv = mergeData.f_merge; 
yv = repmat(double(mergeData.Y_merge), 1, size(xv, 2)); 
vv = xv .* mergeData.pxx_merge; % pre-PSD

% Plot and save the merged PSD
outputFolder = 'mergePSD-figure';
if ~exist(outputFolder, 'dir')
    mkdir(outputFolder);
end

for ii = 1:length(mergeData.Y_merge)
    figure;
    plot(xv(ii, :), vv(ii, :), 'LineWidth', 2);
    set(gca, 'XScale', 'log'); set(gca, 'YScale', 'log');
    set(gca, 'FontSize', 16);
    set(xlabel("$f$ (Hz)"), 'Interpreter', 'latex');
    set(ylabel("$fS_{uu}(f) (\rm m^2/s^2)$"), 'Interpreter', 'latex');
    set(title(sprintf("PSD at $z = %.3f$ m", mergeData.Y_merge(ii))), 'Interpreter', 'latex');
    saveas(gcf, fullfile(outputFolder, sprintf("merged_psd_z%.3f.png", mergeData.Y_merge(ii))));
end

%%
% Create a single figure
figure;

% Define the indices for the five data series
indices = 10:10:length(mergeData.Y_merge); % Select every 5th index

% Extract the corresponding z values for these indices
z_values = mergeData.Y_merge(indices); % Vertical positions for the selected indices

% Normalize the selected z values to [0, 1] for color mapping
z_min = min(z_values);
z_max = max(z_values);
z_normalized = (z_values - z_min) / (z_max - z_min); % Normalize to [0, 1]

% Define a colormap (e.g., 'jet') for the five selected series
cmap = sky(length(indices)); % Colormap with 5 colors (one for each selected series)

% Plot the selected data series with a color gradient
hold on;
for idx = 1:length(indices)
    ii = indices(idx); % Get the actual index
    % Get the color for this vertical position
    color_idx = round(z_normalized(idx) * (size(cmap, 1) - 1)) + 1; % Map to colormap index
    plot(xv(ii, :), vv(ii, :), 'LineWidth', 1.5, 'Color', cmap(color_idx, :));
end
hold off;

% Set the axes properties
set(gca, 'XScale', 'log');
set(gca, 'YScale', 'log');
set(gca, 'FontSize', 16);

% Set labels and title with LaTeX interpreter
set(xlabel('$f$ (Hz)'), 'Interpreter', 'latex', 'FontSize', 16);
set(ylabel('$fS_{uu}(f) (\rm m^2/s^2)$'), 'Interpreter', 'latex', 'FontSize', 16);
set(title('Pre-multiplied Power Spectral Density'), 'Interpreter', 'latex', 'FontSize', 16);

% Add a colorbar to show the mapping of colors to z values
colormap(cmap);
cbar = colorbar;
set(cbar, 'FontSize', 16);
set(get(cbar, 'Label'), 'String', '$z$ (m)', 'Interpreter', 'latex', 'FontSize', 16);
clim([z_min z_max]); % Set the colorbar limits to the range of selected z values

% Save the figure
base_filename = fullfile(outputFolder, 'merged_psd_selected');
% Save as MATLAB figure (.fig)
savefig(gcf, [base_filename '.fig']);

% Save as EMF (.emf)
print(gcf, [base_filename '.emf'], '-dmeta');

% Save as high-DPI JPEG using print (e.g., 500 DPI)
print(gcf, [base_filename '.jpg'], '-djpeg', '-r500');
%%

% Interpolate data
[grid_row, grid_col] = deal(max(400, size(yv, 1)*10), max(50, round(size(xv, 2)/100)));
xq = logspace(...
    log10(min(xv(xv > 0))), log10(max(xv(:))), ...
    grid_col);
yq = linspace(...
    min(yv(:)), max(yv(:)), ...
    grid_row);
[xq, yq] = meshgrid(xq, yq);

vq = griddata(xv, yv, vv, xq, yq);

%% Plot contour
contourf(xq, yq, vq, 10, 'LineStyle', '--');
set(gca, 'XScale', 'log'); set(gca, 'FontSize', 16); %set(gca, 'YScale', 'log');
set(xlabel("$f$ (Hz)"), 'Interpreter', 'latex');
set(ylabel("$z(\rm m)$"), 'Interpreter', 'latex');
colormap("sky");
col = colorbar();
set(ylabel(col,"$fS_{uu}(f) (\rm m^2/s^2)$"), 'Interpreter', 'latex');
