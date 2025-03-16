function status = pivPlot(casePath)
    %% Plot lines
    load(fullfile(casePath, 'figure_data', 'u_stat.mat'));

    % Double average velocity along vertical line
    figure(1); scatter(U_xt, Y);
    set(xlabel("$U(\rm m/s)$", "FontSize", 14), 'Interpreter', 'latex'); 
    set(ylabel("$y(\rm m)$", "FontSize", 14), 'Interpreter', 'latex');
    sec(gca, 'XScale', 'log');

    figure(2); scatter(V_xt, Y);
    set(xlabel("$V(\rm m/s)$", "FontSize", 14), 'Interpreter', 'latex'); 
    set(ylabel("$y(\rm m)$", "FontSize", 14), 'Interpreter', 'latex');

    figure(3); scatter(RSS, Y);
    set(xlabel("$-\overline{u'v'}(\rm m^2/s^2)$", "FontSize", 14), 'Interpreter', 'latex'); 
    set(ylabel("$y(\rm m)$", "FontSize", 14), 'Interpreter', 'latex');

    figure(4); scatter(uu_xt, Y);
    set(xlabel("$\overline{u'u'}(\rm m^2/s^2)$", "FontSize", 14), 'Interpreter', 'latex'); 
    set(ylabel("$y(\rm m)$", "FontSize", 14), 'Interpreter', 'latex');

    figure(5); scatter(vv_xt, Y);
    set(xlabel("$\overline{v'v'}(\rm m^2/s^2)$", "FontSize", 14), 'Interpreter', 'latex'); 
    set(ylabel("$y(\rm m)$", "FontSize", 14), 'Interpreter', 'latex');

    figure(6); scatter(u_rms, Y);
    set(xlabel("$u_{rms}(\rm m/s)$", "FontSize", 14), 'Interpreter', 'latex'); 
    set(ylabel("$y(\rm m)$", "FontSize", 14), 'Interpreter', 'latex');

    figure(7); scatter(v_rms, Y);
    set(xlabel("$v_{rms}(\rm m/s)$", "FontSize", 14), 'Interpreter', 'latex'); 
    set(ylabel("$y(\rm m)$", "FontSize", 14), 'Interpreter', 'latex');

    %% Plot fields

    figure(8)
    imagesc(X,Y, U_t);
    set(gca,'YDir','normal');
    set(xlabel("$x/\rm m$","FontSize", 14), 'Interpreter', 'latex');
    set(ylabel("$y/\rm m$","FontSize", 14), 'Interpreter', 'latex');
    c = colorbar;
    c.Label.String = '$\overline{U}/\rm m/s$';
    c.Label.Interpreter = 'latex';
    c.Label.FontSize = 14;
    % hold on;
    % h1 = quiver(data.x{1, 1}, flip(data.y{1, 1}), flip(U_t), zeros(size(V_t)));
    % set(h1, 'AutoScale', 'on', 'AutoScaleFactor', 5);

    figure(9)
    imagesc(X,Y,V_t);
    set(gca,'YDir','normal');
    set(xlabel("$x/\rm m$","FontSize", 14), 'Interpreter', 'latex');
    set(ylabel("$y/\rm m$","FontSize", 14), 'Interpreter', 'latex');
    c = colorbar;
    c.Label.String = '$\overline{V}/\rm m/s$';
    c.Label.Interpreter = 'latex';
    c.Label.FontSize = 14;

    figure(10)
    imagesc(X,Y, V_t);
    set(gca,'YDir','normal');
    set(xlabel("$x/\rm m$","FontSize", 14), 'Interpreter', 'latex');
    set(ylabel("$y/\rm m$","FontSize", 14), 'Interpreter', 'latex');
    c = colorbar;
    c.Label.String = '$\overline{V}/\rm m/s$';
    c.Label.Interpreter = 'latex';
    c.Label.FontSize = 14;

    figure(11)
    imagesc(X,Y,sqrt(U_t.*U_t + V_t.*V_t));
    set(gca,'YDir','normal');
    set(xlabel("$x/\rm m$","FontSize", 14), 'Interpreter', 'latex');
    set(ylabel("$y/\rm m$","FontSize", 14), 'Interpreter', 'latex');
    c = colorbar;
    c.Label.String = '$\sqrt{\overline{U}^2+\overline{V}^2}/\rm m/s$';
    c.Label.Interpreter = 'latex';
    c.Label.FontSize = 14;
end
