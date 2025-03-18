
load(fullfile(casePath, 'figure_data', 'pxxs.mat'));

[ii_c, jj_c] = deal(round(size(fs, 1)/4), round(size(fs, 2)/4));
figure();
plot(reshape(fs(ii_c, jj_c, :), [], 1), reshape(pxxs(ii_c, jj_c, :), [], 1));
grid on; set(gca, 'XScale', 'log'); set(gca, 'YScale', 'log');
set(xlabel("$f$ (Hz)", "FontSize", 14), 'Interpreter', 'latex');
set(ylabel("$S_{uu}(f) (m^2/s)$", "FontSize", 14), 'Interpreter', 'latex');
set(title(sprintf("PSD at y = %.5f m", Y(jj_c)), FontSize=14), 'Interpreter', 'latex');

figure();
plot(reshape(fs(ii_c, jj_c, :), [], 1), reshape(fs(ii_c, jj_c, :) .* pxxs(ii_c, jj_c, :), [], 1));
grid on; set(gca, 'XScale', 'log');
set(xlabel("$f$ (Hz)", "FontSize", 14), ...
    'Interpreter', 'latex');
set(ylabel("$fS_{uu}(f) (m^2)$", "FontSize", 14), ...
    'Interpreter', 'latex');
set(title(sprintf("pre-multiplied PSD at y = %.5f m", Y(jj_c)), FontSize=14), ...
    'Interpreter', 'latex');

[ii_c, jj_c] = deal(round(size(fs, 1)/2), round(size(fs, 2)/2));
figure();
plot(reshape(fs(ii_c, jj_c, :), [], 1), reshape(pxxs(ii_c, jj_c, :), [], 1));
grid on; set(gca, 'XScale', 'log'); set(gca, 'YScale', 'log');
set(xlabel("$f$ (Hz)", "FontSize", 14), 'Interpreter', 'latex');
set(ylabel("$S_{uu}(f) (m^2/s)$", "FontSize", 14), 'Interpreter', 'latex');
set(title(sprintf("PSD at y = %.5f m", Y(jj_c)), FontSize=14), 'Interpreter', 'latex');

figure();
plot(reshape(fs(ii_c, jj_c, :), [], 1), reshape(fs(ii_c, jj_c, :) .* pxxs(ii_c, jj_c, :), [], 1));
grid on; set(gca, 'XScale', 'log');
set(xlabel("$f$ (Hz)", "FontSize", 14), ...
    'Interpreter', 'latex');
set(ylabel("$fS_{uu}(f) (m^2)$", "FontSize", 14), ...
    'Interpreter', 'latex');
set(title(sprintf("pre-multiplied PSD at y = %.5f m", Y(jj_c)), FontSize=14), ...
    'Interpreter', 'latex');

[ii_c, jj_c] = deal(round(size(fs, 1)*3/4), round(size(fs, 2)*3/4));
figure();
plot(reshape(fs(ii_c, jj_c, :), [], 1), reshape(pxxs(ii_c, jj_c, :), [], 1));
grid on; set(gca, 'XScale', 'log'); set(gca, 'YScale', 'log');
set(xlabel("$f$ (Hz)", "FontSize", 14), 'Interpreter', 'latex');
set(ylabel("$S_{uu}(f) (m^2/s)$", "FontSize", 14), 'Interpreter', 'latex');
set(title(sprintf("PSD at y = %.5f m", Y(jj_c)), FontSize=14), 'Interpreter', 'latex');

figure();
plot(reshape(fs(ii_c, jj_c, :), [], 1), reshape(fs(ii_c, jj_c, :) .* pxxs(ii_c, jj_c, :), [], 1));
grid on; set(gca, 'XScale', 'log');
set(xlabel("$f$ (Hz)", "FontSize", 14), ...
    'Interpreter', 'latex');
set(ylabel("$fS_{uu}(f) (m^2)$", "FontSize", 14), ...
    'Interpreter', 'latex');
set(title(sprintf("pre-multiplied PSD at y = %.5f m", Y(jj_c)), FontSize=14), ...
    'Interpreter', 'latex');

% Measuring points along vertical centre line
pxx_c = pxxs(:, round(size(pxxs, 2)/2), :);
f_c = fs(:, round(size(fs, 2)/2), :);
xv = f_c; yv = ymesh; vv = f_c .* pxx_c; % pre-PSD

[grid_row, grid_col] = deal(max(800, size(xv, 1)*10), min(2000, round(size(xv, 2)/100)));
xq = logspace(...
    log10(min(xv(:))), log10(max(xv(:))), ...
    grid_col);
yq = linspace(...
    min(yv(:)), max(yv(:)), ...
    grid_row);
[xq, yq] = meshgrid(xq, yq);

vq = griddata(xv, yv, vv, xq, yq);

contourf(xq, yq, vq, 20, 'LineStyle','none');
cset(gca, 'XScale', 'log'); set(gca, 'FontSize', 16); %set(gca, 'YScale', 'log');
set(xlabel("$f$ (Hz)"), 'Interpreter', 'latex');
set(ylabel("$z(\rm m)$"), 'Interpreter', 'latex');
set(ylabel(col,"$fS_{uu}(f) (\rm m^2/s^2)$"), 'Interpreter', 'latex');
