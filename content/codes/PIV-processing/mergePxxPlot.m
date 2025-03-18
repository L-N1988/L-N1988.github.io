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
    set(title(sprintf("PSD at $z = %.2f$ m", mergeData.Y_merge(ii))), 'Interpreter', 'latex');
    saveas(gcf, fullfile(outputFolder, sprintf("merged_psd_z%.2f.png", mergeData.Y_merge(ii))));
end

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
