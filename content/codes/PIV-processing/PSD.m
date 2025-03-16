function status = PSD(casePath, Fs)
    data = load(fullfile(casePath, 'figure_data', 'u4pxx.mat'));
    X = data.X;
    Y = data.Y;
    xmesh = data.xmesh;
    ymesh = data.ymesh;
    U_xt = mean(data.U_t, 2);
    u_pri = cell2mat(data.u_pri);

    [m, n, l] = size(u_pri);

    fs = zeros(size(u_pri));
    pxxs = zeros(size(u_pri));

    parfor ii=1:m
        parfor jj=1:n
            % Default window length = 10000 for maintain accuracy and reduce uncertainty
            [fs(ii, jj), pxxs(ii, jj)] = pwelch(u_pri(ii, jj, :), 10000, [], [], Fs);
        end
    end

    % Define the window size (3x3)
    window_size = 3;
    kernel = ones(window_size, window_size); % 3x3 matrix of ones
    % Move average with 3x3 filter window
    pxxs = patch_moving_average_conv(pxxs, kernel);

    save(fullfile(casePath, 'figure_data', 'pxxs.mat'), 'X', 'xmesh', 'Y', 'ymesh', 'fs', 'pxxs', 'U_xt');
end

function moving_avg_matrix = patch_moving_average_conv(matrix, kernel)
    % Input: matrix (e.g., 6x10), kernel
    % Output: moving_avg_matrix with same size as input, containing averages
    
    % Perform convolution with 'same' to keep output size equal to input
    % Sum of elements in each 3x3 patch
    % Conv2 with 'same' assumes zero-padding outside the matrix boundaries.
    % See: https://stackoverflow.com/a/29973613/18736354
    conv_result = convn(matrix, kernel, 'same');
    
    % Create a matrix to count how many elements contribute at each position
    contrib_count = convn(ones(size(matrix)), kernel, 'same');
    
    % Compute the moving average by dividing sum by number of contributing elements
    moving_avg_matrix = conv_result ./ contrib_count;
end

