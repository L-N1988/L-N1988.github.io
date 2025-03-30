
clc; clear; close all; % Clear command window, workspace, and close all figures
casePath = '..'; % Define the relative path to the case directory
load(fullfile(casePath, 'figure_data', 'u_stat.mat')); % Load statistical data for plotting

%% Plot lines
% Plot 1: Double average velocity (U) along the vertical line
figure(1); scatter(U_xt, Y); % Scatter plot of U_xt vs Y
set(xlabel("$U(\rm m/s)$", "FontSize", 14), 'Interpreter', 'latex'); % Set x-axis label with LaTeX formatting
set(ylabel("$y(\rm m)$", "FontSize", 14), 'Interpreter', 'latex'); % Set y-axis label with LaTeX formatting
set(gca, 'YScale', 'log'); % Set y-axis to logarithmic scale
print(gcf, fullfile('..', 'analysis_figures', 'U_vs_Y.emf'), '-dmeta', '-r300'); % Save plot as .emf
saveas(gcf, fullfile('..', 'analysis_figures', 'U_vs_Y.fig')); % Save plot as .fig
saveas(gcf, fullfile('..', 'analysis_figures', 'U_vs_Y.svg')); % Save plot as .svg
print(gcf, fullfile('..', 'analysis_figures', 'U_vs_Y.jpg'), '-djpeg', '-r300'); % Save plot as .jpg

% Plot 2: Double average velocity (V) along the vertical line
figure(2); scatter(V_xt, Y); % Scatter plot of V_xt vs Y
set(xlabel("$V(\rm m/s)$", "FontSize", 14), 'Interpreter', 'latex'); % Set x-axis label with LaTeX formatting
set(ylabel("$y(\rm m)$", "FontSize", 14), 'Interpreter', 'latex'); % Set y-axis label with LaTeX formatting
print(gcf, fullfile('..', 'analysis_figures', 'V_vs_Y.emf'), '-dmeta', '-r300'); % Save plot as .emf
saveas(gcf, fullfile('..', 'analysis_figures', 'V_vs_Y.fig')); % Save plot as .fig
saveas(gcf, fullfile('..', 'analysis_figures', 'V_vs_Y.svg')); % Save plot as .svg
print(gcf, fullfile('..', 'analysis_figures', 'V_vs_Y.jpg'), '-djpeg', '-r300'); % Save plot as .jpg

% Plot 3: Reynolds shear stress (RSS) along the vertical line
figure(3); scatter(RSS, Y); % Scatter plot of RSS vs Y
set(xlabel("$-\overline{u'v'}(\rm m^2/s^2)$", "FontSize", 14), 'Interpreter', 'latex'); % Set x-axis label with LaTeX formatting
set(ylabel("$y(\rm m)$", "FontSize", 14), 'Interpreter', 'latex'); % Set y-axis label with LaTeX formatting
print(gcf, fullfile('..', 'analysis_figures', 'RSS_vs_Y.emf'), '-dmeta', '-r300'); % Save plot as .emf
saveas(gcf, fullfile('..', 'analysis_figures', 'RSS_vs_Y.fig')); % Save plot as .fig
saveas(gcf, fullfile('..', 'analysis_figures', 'RSS_vs_Y.svg')); % Save plot as .svg
print(gcf, fullfile('..', 'analysis_figures', 'RSS_vs_Y.jpg'), '-djpeg', '-r300'); % Save plot as .jpg

% Plot 4: Turbulent normal stress (uu) along the vertical line
figure(4); scatter(uu_xt, Y); % Scatter plot of uu_xt vs Y
set(xlabel("$\overline{u'u'}(\rm m^2/s^2)$", "FontSize", 14), 'Interpreter', 'latex'); % Set x-axis label with LaTeX formatting
set(ylabel("$y(\rm m)$", "FontSize", 14), 'Interpreter', 'latex'); % Set y-axis label with LaTeX formatting
print(gcf, fullfile('..', 'analysis_figures', 'uu_vs_Y.emf'), '-dmeta', '-r300'); % Save plot as .emf
saveas(gcf, fullfile('..', 'analysis_figures', 'uu_vs_Y.fig')); % Save plot as .fig
saveas(gcf, fullfile('..', 'analysis_figures', 'uu_vs_Y.svg')); % Save plot as .svg
print(gcf, fullfile('..', 'analysis_figures', 'uu_vs_Y.jpg'), '-djpeg', '-r300'); % Save plot as .jpg

% Plot 5: Turbulent normal stress (vv) along the vertical line
figure(5); scatter(vv_xt, Y); % Scatter plot of vv_xt vs Y
set(xlabel("$\overline{v'v'}(\rm m^2/s^2)$", "FontSize", 14), 'Interpreter', 'latex'); % Set x-axis label with LaTeX formatting
set(ylabel("$y(\rm m)$", "FontSize", 14), 'Interpreter', 'latex'); % Set y-axis label with LaTeX formatting
print(gcf, fullfile('..', 'analysis_figures', 'vv_vs_Y.emf'), '-dmeta', '-r300'); % Save plot as .emf
saveas(gcf, fullfile('..', 'analysis_figures', 'vv_vs_Y.fig')); % Save plot as .fig
saveas(gcf, fullfile('..', 'analysis_figures', 'vv_vs_Y.svg')); % Save plot as .svg
print(gcf, fullfile('..', 'analysis_figures', 'vv_vs_Y.jpg'), '-djpeg', '-r300'); % Save plot as .jpg

% Plot 6: Root mean square of velocity fluctuations (u_rms) along the vertical line
figure(6); scatter(u_rms, Y); % Scatter plot of u_rms vs Y
set(xlabel("$u_{rms}(\rm m/s)$", "FontSize", 14), 'Interpreter', 'latex'); % Set x-axis label with LaTeX formatting
set(ylabel("$y(\rm m)$", "FontSize", 14), 'Interpreter', 'latex'); % Set y-axis label with LaTeX formatting
print(gcf, fullfile('..', 'analysis_figures', 'u_rms_vs_Y.emf'), '-dmeta', '-r300'); % Save plot as .emf
saveas(gcf, fullfile('..', 'analysis_figures', 'u_rms_vs_Y.fig')); % Save plot as .fig
saveas(gcf, fullfile('..', 'analysis_figures', 'u_rms_vs_Y.svg')); % Save plot as .svg
print(gcf, fullfile('..', 'analysis_figures', 'u_rms_vs_Y.jpg'), '-djpeg', '-r300'); % Save plot as .jpg

% Plot 7: Root mean square of velocity fluctuations (v_rms) along the vertical line
figure(7); scatter(v_rms, Y); % Scatter plot of v_rms vs Y
set(xlabel("$v_{rms}(\rm m/s)$", "FontSize", 14), 'Interpreter', 'latex'); % Set x-axis label with LaTeX formatting
set(ylabel("$y(\rm m)$", "FontSize", 14), 'Interpreter', 'latex'); % Set y-axis label with LaTeX formatting
print(gcf, fullfile('..', 'analysis_figures', 'v_rms_vs_Y.emf'), '-dmeta', '-r300'); % Save plot as .emf
saveas(gcf, fullfile('..', 'analysis_figures', 'v_rms_vs_Y.fig')); % Save plot as .fig
saveas(gcf, fullfile('..', 'analysis_figures', 'v_rms_vs_Y.svg')); % Save plot as .svg
print(gcf, fullfile('..', 'analysis_figures', 'v_rms_vs_Y.jpg'), '-djpeg', '-r300'); % Save plot as .jpg
saveas(gcf, fullfile('..', 'analysis_figures', 'v_rms_vs_Y.svg')); % Save plot as .svg

% %% Plot fields (commented out)
% 
% figure(8)
% imagesc(X,Y, U_t); % Plot 2D field of U_t
% set(gca,'YDir','normal'); % Set y-axis direction to normal
% set(xlabel("$x/\rm m$","FontSize", 14), 'Interpreter', 'latex'); % Set x-axis label with LaTeX formatting
% set(ylabel("$y/\rm m$","FontSize", 14), 'Interpreter', 'latex'); % Set y-axis label with LaTeX formatting
% c = colorbar; % Add colorbar
% c.Label.String = '$\overline{U}/\rm m/s$'; % Set colorbar label
% c.Label.Interpreter = 'latex'; % Use LaTeX formatting for colorbar label
% c.Label.FontSize = 14; % Set font size for colorbar label
% % hold on;
% % h1 = quiver(data.x{1, 1}, flip(data.y{1, 1}), flip(U_t), zeros(size(V_t))); % Add quiver plot (commented out)
% % set(h1, 'AutoScale', 'on', 'AutoScaleFactor', 5); % Configure quiver plot scaling
% 
% figure(9)
% imagesc(X,Y,V_t); % Plot 2D field of V_t
% set(gca,'YDir','normal'); % Set y-axis direction to normal
% set(xlabel("$x/\rm m$","FontSize", 14), 'Interpreter', 'latex'); % Set x-axis label with LaTeX formatting
% set(ylabel("$y/\rm m$","FontSize", 14), 'Interpreter', 'latex'); % Set y-axis label with LaTeX formatting
% c = colorbar; % Add colorbar
% c.Label.String = '$\overline{V}/\rm m/s$'; % Set colorbar label
% c.Label.Interpreter = 'latex'; % Use LaTeX formatting for colorbar label
% c.Label.FontSize = 14; % Set font size for colorbar label
% 
% figure(10)
% imagesc(X,Y, V_t); % Plot 2D field of V_t (duplicate of figure 9)
% set(gca,'YDir','normal'); % Set y-axis direction to normal
% set(xlabel("$x/\rm m$","FontSize", 14), 'Interpreter', 'latex'); % Set x-axis label with LaTeX formatting
% set(ylabel("$y/\rm m$","FontSize", 14), 'Interpreter', 'latex'); % Set y-axis label with LaTeX formatting
% c = colorbar; % Add colorbar
% c.Label.String = '$\overline{V}/\rm m/s$'; % Set colorbar label
% c.Label.Interpreter = 'latex'; % Use LaTeX formatting for colorbar label
% c.Label.FontSize = 14; % Set font size for colorbar label
% 
% figure(11)
% imagesc(X,Y,sqrt(U_t.*U_t + V_t.*V_t)); % Plot 2D field of velocity magnitude
% set(gca,'YDir','normal'); % Set y-axis direction to normal
% set(xlabel("$x/\rm m$","FontSize", 14), 'Interpreter', 'latex'); % Set x-axis label with LaTeX formatting
% set(ylabel("$y/\rm m$","FontSize", 14), 'Interpreter', 'latex'); % Set y-axis label with LaTeX formatting
% c = colorbar; % Add colorbar
% c.Label.String = '$\sqrt{\overline{U}^2+\overline{V}^2}/\rm m/s$'; % Set colorbar label
% c.Label.Interpreter = 'latex'; % Use LaTeX formatting for colorbar label
% c.Label.FontSize = 14; % Set font size for colorbar label

