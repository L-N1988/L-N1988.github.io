% This script processes `mat` from PIVLab toolbox 
% to calculate turbulence statistic parameters

function status = raw2data(casePath)
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

    data = load(fullfile(casePath, 'normalized_data', 'PIVlab.mat'));
    xmesh = data.x{1, 1}; X = xmesh(1, :);
    ymesh = data.y{1, 1}; Y = ymesh(:, 1);
    disp(sprintf(['Measure domain: \n'...
            'X from %.5f to %.5f, nX = %d, dX = %.5f.\n'...
            'Y from %.5f to %.5f, nY = %d, dY = %.5f.\n']), ...
            X(1), X(end), length(X), mean(diff(X)), Y(1), Y(end), length(Y), mean(diff(Y)));
    % 3d matrix
    u_original = data.u_original;
    v_original = data.v_original;

    if isempty(data.u_filtered{1}) && isempty(data.v_filtered{1})
        warning('Data not fileted in PIVLab. Mat file may contains some abnormal data.')
        u_filtered = u_original;
        v_filtered = v_original;
        typevector = data.typevector_original;
    else
        u_filtered = data.u_filtered;
        v_filtered = data.v_filtered;
        typevector = data.typevector_filtered;
    end

    [mRows, nCols] = size(u_filtered{1}); % FIXME
    nFrame = length(u_filtered); % snapshot number

    % Remove non-numerical and mask data
    % Ask Groq3 beta
    _results = cellfun(...
        @(u_frame, v_frame, validMask) ...
        {...
            u_frame(~validMask || isnan(u_frame) || isinf(u_frame)) = 0; u_frame, ...
            v_frame(~validMask || isnan(v_frame) || isinf(v_frame)) = 0; v_frame, ...
            }, u_filtered, v_filtered, typevector, ...
        'UniformOutput', false);
    u_filtered = cellfun(@(x) x{1}, _results, 'UniformOutput', false);
    v_filtered = cellfun(@(x) x{2}, _results, 'UniformOutput', false);
    % Sum cell array trick
    % https://www.mathworks.com/matlabcentral/answers/281640-sum-values-in-a-cell-array#answer_220006
    nValidFrame = sum([typevector{:}]);

    %% Statistic process
    % READ FIRST: https://www.mit.edu/course/1/1.061/www/dream/SEVEN/SEVENTHEORY.PDF

    % Time average velocity of each cell
    % Sum cell array trick
    U_t = sum([u_filtered{:}]) ./ nValidFrame;
    V_t = sum([v_filtered{:}]) ./ nValidFrame;

    % Double average velocity
    % Vector
    U_xt = mean(U_t, 2); % average in x/column direction
    V_xt = mean(V_t, 2); % average in x/column direction

    % Double average component
    % FIXME: this should be same as U_xt or V_xt, but not?
    % U_xt = sum(sum(u_filtered{:}]), 2) ./ sum(nValidFrame, 2);
    % V_xt = sum(sum(v_filtered{:}]), 2) ./ sum(nValidFrame, 2);

    % Turbulent velocity
    u_pri = cellfun(@(u_frame) u_frame - U_t, u_filtered); % u'
    v_pri = cellfun(@(v_frame) v_frame - V_t, v_filtered); % v'

    % Cross- or self- correlation, second moment
    uv = cellfun(@(u, v) u.*v, u_filtered, v_filtered); % u'v' Reynold shear stress
    uu = cellfun(@(u) u.^2, u_filtered); % u'u' TKE of u
    vv = cellfun(@(v) v.^2, v_filtered); % v'v' TKE of v
    % Third moment
    uuu = cellfun(@(u) u.^3, u_filtered);
    vvv = cellfun(@(v) v.^3, v_filtered);

    % Time average
    uv_t  = sum([uv{:}]) ./ nValidFrame;
    uu_t  = sum([uu{:}]) ./ nValidFrame;
    vv_t  = sum([vv{:}]) ./ nValidFrame;
    uuu_t = sum([uuu{:}])./ nValidFrame;
    vvv_t = sum([vvv{:}) ./ nValidFrame;

    % Double average: average in time direction then in x direction
    uv_xt  = mean(uv_t, 2); % u'v'
    RSS    = -1 * uv_xt; % Reynold shear stress
    uu_xt  = mean(uu_t, 2); % u'u' TKE of u
    vv_xt  = mean(vv_t, 2); % v'v' TKE of v
    uuu_xt = mean(uuu_t, 2); % u'u'u' third moment of u
    % rms means space average of stdandard deviation
    u_rms = mean(sqrt(uu_t), 2); % turbulence strength of u
    v_rms = mean(sqrt(vv_t), 2); % turbulence strength of v

    save(fullfile(casePath, 'figure_data', 'u_stat.mat'), 'xmesh', 'X', 'ymesh', 'Y', 'U_xt', 'V_xt', 'RSS', 'uu_xt', 'vv_xt', 'u_rms', 'v_rms');
    save(fullfile(casePath, 'figure_data', 'u4pxx.mat'), 'xmesh', 'X', 'ymesh', 'Y', 'U_t', 'V_t', 'u_pri', 'v_pri');

    prompt = "Do you want power spectral analysis? Y/N [N]: ";
    txt = input(prompt,"s");
    if isempty(txt)
        txt = 'N';
    end
    if txt == 'Y' || txt == 'y'
        Fs = input('PIV sampe frequency [fps]?');
        PSD(casePath, Fs);
    else
        ; % Place holder
    end
end

