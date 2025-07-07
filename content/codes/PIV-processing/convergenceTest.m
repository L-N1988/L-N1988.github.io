% PIVLab frame data format
% This section describes the 3D data structure used in PIVLab, where the data is organized as a 3D matrix
% with dimensions corresponding to rows (mRows), columns (nCols), and frames (nFrame).

% Clear workspace, close figures, and initialize
clc; clear; close all;

% Load PIVLab data from a specified file
casePath = "F:\Sediment_transport_rate\S0p001_H21mm\";
data = load(fullfile(casePath, 'PIVlab.mat'));

%%
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

%% 修改后的并行计算部分
totalFrames = size(u_filtered, 3);
step = 500;  % 设置帧数分段步长（示例值，根据需求调整）
nSegs = floor(totalFrames / step);  % 计算分段数量

% 预分配结果数组
nFrames = zeros(nSegs, 1);
Us = zeros(nSegs, size(u_filtered, 1));
Vs = zeros(nSegs, size(u_filtered, 1));
us_rms = zeros(nSegs, size(u_filtered, 1));
vs_rms = zeros(nSegs, size(u_filtered, 1));
uvs = zeros(nSegs, size(u_filtered, 1));

parfor k = 1:nSegs
    currentFrame = k * step;  % 当前处理的总帧数
    
    % 切片当前帧范围的数据
    u_part = u_filtered(:, :, 1:currentFrame);
    v_part = v_filtered(:, :, 1:currentFrame);
    
    % 计算时间平均速度场（忽略NaN）
    U_t = mean(u_part, 3, 'omitnan');
    V_t = mean(v_part, 3, 'omitnan');
    
    % 计算空间平均速度（仅有效点）
    U = mean(U_t, 2, 'omitnan');
    V = mean(V_t, 2, 'omitnan');
    
    % 计算脉动速度分量
    u_prime = u_part - U_t;
    v_prime = v_part - V_t;
    
    % 计算二阶矩（忽略无效点）
    uu = u_prime .* u_prime;
    vv = v_prime .* v_prime;
    uv = u_prime .* v_prime;
    
    % 时间平均二阶矩
    uu_t = mean(uu, 3, 'omitnan');
    vv_t = mean(vv, 3, 'omitnan');
    uv_t = mean(uv, 3, 'omitnan');
    
    % 空间平均二阶矩
    uu_region = mean(uu_t, 2, 'omitnan');
    vv_region = mean(vv_t, 2, 'omitnan');
    uv_region = mean(uv_t, 2, 'omitnan');
    
    % 计算统计量
    us_rms(k, :) = sqrt(uu_region);
    vs_rms(k, :) = sqrt(vv_region);
    
    % 存储结果
    nFrames(k, :) = currentFrame;
    Us(k, :) = U;
    Vs(k, :) = V;
    uvs(k, :) = uv_region;
end
%%
Npts = int16(5);
objStep = idivide(int16(size(u_filtered, 1)), Npts)
indexs = (1:Npts) * objStep

for ii = 1:length(indexs)
    index = indexs(ii);
    fig = figure();
    scatter(nFrames, Us(:, index), 50,  "filled", "o");
    hold on;
    xlabel('Number of frames');
    ylabel('Statistical results');
    scatter(nFrames, Vs(:, index), 50,  "filled", '+');
    scatter(nFrames, us_rms(:, index), 50,  "filled", 's');
    scatter(nFrames, vs_rms(:, index), 50, "filled", 'd');
    scatter(nFrames, -1 * uvs(:, index), 50, "filled", 'x');
    hl = legend('$U$', '$V$', '$u_rms$', '$v_rms$', 'RSS');
    set(hl, 'Interpreter', 'latex')
    set(gca, 'FontSize', 14);
    grid on;
    title(strcat('Statistical results of PIVLab data at y =', num2str(Y(index)*1000), ' mm'));

    % Save the statistical figure (in format svg and as a MATLAB figure)
    saveas(fig, fullfile(casePath, strcat('convergenceTest_y=', num2str(Y(index)*1000), '.svg')));
    saveas(fig, fullfile(casePath, strcat('convergenceTest_y=', num2str(Y(index)*1000), '.fig')));
end
