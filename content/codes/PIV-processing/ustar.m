clc; clear; close all;

% Define the path to the case data and load the velocity statistics
casePath = '..';
load(fullfile(casePath, 'figure_data', 'u_stat.mat'));

%% Log-law velocity profile analysis
% The log-law velocity profile satisfies the equation:
% U+ = 1/k * log(y+) + B
% where U+ = U/U_tau, y+ = y*U_tau/nu, k = 0.41, B = 5.2
% Perform linear regression to fit U and y in the semilog plot.

% Select the log layer region based on y values
log_index = Y > 0.015 & Y < 0.035;  % Define the log layer range
U_log = U_xt(log_index);           % Extract U values in the log layer
Y_log = log10(Y(log_index));       % Extract log10(y) values in the log layer

% Perform linear regression to find the slope and intercept
p = polyfit(Y_log, U_log, 1);

% Calculate friction velocity (u_tau) from the log-law fit
k = 0.41;                          % von Kármán constant
U_tau_log = k * p(1);              % Friction velocity from log-law fit
disp(['u_tau from log law fit: ', num2str(U_tau_log)]);

% Calculate kinematic viscosity based on water temperature
T = 13.4;                          % Temperature in degrees Celsius
nu = 1e-6 * (60/(T+40))^1.45;      % Kinematic viscosity (m^2/s)

% Compute dimensionless velocity (U+) and wall-normal distance (y+)
y_plus = Y * U_tau_log / nu;
U_plus = U_xt / U_tau_log;

% Plot U+ vs y+ in a semilog plot
figure(); 
scatter(U_plus, y_plus, 'o');      % Scatter plot of U+ vs y+
set(gca, 'YScale', 'log');         % Set y-axis to log scale
xlabel("$U^+$", "FontSize", 14, 'Interpreter', 'latex');
ylabel("$y^+$", "FontSize", 14, 'Interpreter', 'latex');
hold on;

% Plot the log-law velocity profile as a reference
y_plus_log = 10.^(Y_log) * U_tau_log / nu;
U_plus_log = (polyval(p, Y_log)) / U_tau_log;
plot(U_plus_log, y_plus_log, 'r--', 'LineWidth', 1.5); % Log-law fit
set(gca, 'FontSize', 10); % Adjust tick label size
legend('Data', 'Log law fit', 'Location', 'Best');

%% Friction velocity from channel slope
% Calculate friction velocity using the slope of the channel:
% u_tau = sqrt(g * R * S), where R is the hydraulic radius and S is the slope.

H = 0.1112;                        % Water depth (m)
W = 0.0867;                        % Channel width (m)
A = H * W;                         % Cross-sectional area (m^2)
P = 2 * H + W;                     % Wetted perimeter (m)
R = A / P;                         % Hydraulic radius (m)
S = 0.52 / 348.36;                 % Channel slope
u_tau_slope = sqrt(9.81 * R * S);  % Friction velocity from slope
disp(['u_tau from slope of channel: ', num2str(u_tau_slope)]);

%% Friction velocity from RSS linear depth profile
% Calculate friction velocity using the Reynolds shear stress (RSS):
% u_tau = sqrt(-slope of RSS profile).

figure();
scatter(RSS, Y, 'o');              % Scatter plot of RSS vs y
xlabel("$-\overline{u'v'}(\rm m^2/s^2)$", "FontSize", 14, 'Interpreter', 'latex');
ylabel("$y(\rm m)$", "FontSize", 14, 'Interpreter', 'latex');
hold on;

% Perform linear regression on the RSS profile in the selected range
RSS_index = Y > 0.03 & Y < 0.05;   % Define the range for linear fit
RSS_linear = RSS(RSS_index);       % Extract RSS values in the range
Y_linear = Y(RSS_index);           % Extract y values in the range
p_trans = polyfit(Y_linear, RSS_linear, 1); % Linear regression
u_tau_RSS = sqrt(p_trans(2));      % Friction velocity from RSS
disp(['u_tau from RSS linear depth profile: ', num2str(u_tau_RSS)]);

% Add the linear fit to the plot
p = polyfit(RSS_linear, Y_linear, 1);
plot(RSS_linear, polyval(p, RSS_linear), 'r--', 'LineWidth', 1.5); % Linear fit
set(gca, 'FontSize', 10); % Adjust tick label size
legend('Data', 'RSS linear fit', 'Location', 'Best');
