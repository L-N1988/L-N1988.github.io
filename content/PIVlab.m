% This script processes `mat` from PIVLab toolbox to calculate turbulence statistic parameters
clc; clear;

%------------------------------------------------------------------------%
% read data
%------------------------------------------------------------------------%

% before running, add mat file path here!!!
matPath = 'Edit here';
data = load(matPath);
% vector, 2d plane coordinate values
Y = data.y{1, 1}(:, 1);
X = data.x{1, 1}(1, :);
% 3d matrix
u_original = data.u_original;
v_original = data.v_original;
u_filtered = data.u_filtered;
v_filtered = data.v_filtered;
plane_nomask = data.typevector_original{1, 1};
%    o--------o
%   /        /|
%  /        / |
% o--------o  |
% |        |  o
% |     ny | /
% |        |/ lt
% o--------o
%     mx
% scalar, 3d matrix dimension length
[mx, ny] = size(u_original{1});
lt = length(u_original); % snapshot number

tCnt = zeros(mx, ny); % valid cell numbers in snapshots
uSum = zeros(mx, ny);
vSum = zeros(mx, ny);

%------------------------------------------------------------------------%
% clean data
%------------------------------------------------------------------------%

for k = 1:lt
	for i = 1:mx
		for j = 1:ny
			if plane_nomask(i, j)
				tCnt(i, j) = tCnt(i, j) + 1; % snapshot numbers of each valid cell
			else
				% remove masked cells
				u_filtered{k}(i, j) = 0;
				v_filtered{k}(i, j) = 0;
			end
		end
	end
end

%------------------------------------------------------------------------%
% statistic process
% READ FIRST: https://www.mit.edu/course/1/1.061/www/dream/SEVEN/SEVENTHEORY.PDF
%------------------------------------------------------------------------%

for k = 1:lt
	uSum = uSum + u_filtered{k};
	vSum = vSum + v_filtered{k};
end

% time average velocity of each cell
% 2d matrix
U_t = uSum ./ tCnt;
V_t = vSum ./ tCnt;

% double average velocity
% vector
U_xt = mean(U_t, 2); % average in x direction
V_xt = mean(V_t, 2); % average in x direction

% double average component
% FIXME: this should be same as U_xt or V_xt, but not?
% U_xt = sum(uSum, 2) ./ sum(tCnt, 2);
% V_xt = sum(vSum, 2) ./ sum(tCnt, 2);

% turbulent velocity
u_pri = cell(lt, 1); % u'
v_pri = cell(lt, 1); % v'
% cross- or self- correlation, second moment
uv = zeros(mx, ny); % u'v' Reynold shear stress
uu = zeros(mx, ny); % u'u' TKE of u
vv = zeros(mx, ny); % v'v' TKE of v
% third moment
uuu = zeros(mx, ny); % u'u'u'

for k = 1:lt
	u_pri{k} = u_filtered{k} - U_t;
	v_pri{k} = v_filtered{k} - V_t;
	for i = 1:mx
		for j = 1:ny
			if plane_nomask(i, j) == 0
				u_pri{k}(i, j) = 0;
				v_pri{k}(i, j) = 0;
			end
		end
	end
	uv = uv + u_pri{k} .* v_pri{k};
	uu = uu + u_pri{k}.^2;
	vv = vv + v_pri{k}.^2;
	uuu = uuu + u_pri{k}.^3;
end

% double average: average in time direction then in x direction
uv_xt = mean(uv ./ tCnt, 2); % u'v' Reynold shear stress
uu_xt = mean(uu ./ tCnt, 2); % u'u' TKE of u
vv_xt = mean(vv ./ tCnt, 2); % v'v' TKE of v
% rms means space average of stdandard deviation
u_rms = mean(sqrt(uu ./ tCnt), 2); % turbulence strength of u
v_rms = mean(sqrt(vv ./ tCnt), 2); % turbulence strength of v
uuu_xt = mean(uuu ./ tCnt, 2); % u'u'u' third moment of u

%------------------------------------------------------------------------%
% spectrum analysis
%------------------------------------------------------------------------%
center = [floor(mx / 2) + 1, floor(ny / 2) + 1];
eps = max(1, min(floor(mx / 10), floor(ny / 10)));
% time serie of turbulent velocity
u_pri_t = zeros(lt, 1);
for i = 1:lt
    u_pri_t(i) = mean(u_pri{i}(center(1)-eps:center(1)+eps, ...
								center(2)-eps:center(2)+eps),...
								[1, 2]);
end

% PSD by FFT
% https://ww2.mathworks.cn/help/signal/ug/power-spectral-density-estimates-using-fft.html
x = u_pri_t; fs = 24;
N = length(x);
xdft = fft(x);
xdft = xdft(1:N/2+1);
psdx = (1/(fs*N)) * abs(xdft).^2;
psdx(2:end-1) = 2*psdx(2:end-1);
freq = 0:fs/length(x):fs/2;

figure(1);
subplot(4,1,1);
plot(freq,psdx)
grid on
set(gca, 'XScale', 'log'); set(gca, 'YScale', 'log');
title("PSD Using FFT")
xlabel("Frequency (Hz)")
ylabel("Power/Frequency (J/Hz)")

% PSD by Periodogram
% https://ww2.mathworks.cn/help/signal/ug/power-spectral-density-estimates-using-fft.html
subplot(4,1,2);
periodogram(x,rectwin(N),N,fs)
grid on
set(gca, 'XScale', 'log'); set(gca, 'YScale', 'log');
title("PSD Using Periodogram")
xlabel("Frequency (Hz)")
ylabel("Power/Frequency (J/Hz)")
% mxerr = max(max(psdx'-periodogram(x,rectwin(N),N,fs)))

% PSD by pwelch
% https://ww2.mathworks.cn/matlabcentral/answers/1788420-finding-psd-from-autocorrelation-fft-periodogram-and-pwelch
subplot(4,1,3);
pwelch(u_pri_t, rectwin(N))
grid on
set(gca, 'XScale', 'log');
title("PSD Using pwelch")
xlabel("Frequency (Hz)")
ylabel("Power/Frequency (J/Hz)")

% PSD by auto-correlation
% Read: page 10 and 11 in https://l-n1988.github.io/SpectrumAnalysis.pdf
acf = ifft(fft(x).*fft(x));			% circular correlation
acf = circshift(acf,1);				% put zero lag value at the beginning of the array
S = real(fft(acf));					% remove small nuisance imaginary part 
S = (1/(fs*N))*S;              	    % factor that's needed 
S = S(1:(N/2)+1);
S(2:end-1) = 2*S(2:end-1);

subplot(4,1,4);
plot(freq,S)
grid on
set(gca, 'XScale', 'log'); set(gca, 'YScale', 'log');
title('PSD using auto-correlation')
xlabel('Frequency (Hz)')
ylabel("Power/Frequency (J/Hz)")

%------------------------------------------------------------------------%
% plot lines
%------------------------------------------------------------------------%

% double average velocity along vertical line
figure(1); scatter(U_xt, Y);
set(xlabel("$U(\rm m/s)$", "FontSize", 14), 'Interpreter', 'latex'); 
set(ylabel("$y(\rm m)$", "FontSize", 14), 'Interpreter', 'latex');
figure(2); scatter(V_xt, Y);
set(xlabel("$V(\rm m/s)$", "FontSize", 14), 'Interpreter', 'latex'); 
set(ylabel("$y(\rm m)$", "FontSize", 14), 'Interpreter', 'latex');

figure(3); scatter(-1 * uv_xt, Y);
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

figure(8); scatter(uuu_xt, Y);
set(xlabel("$\overline{u'u'u'}(\rm m^3/s^3)$", "FontSize", 14), 'Interpreter', 'latex'); 
set(ylabel("$y(\rm m)$", "FontSize", 14), 'Interpreter', 'latex');

%------------------------------------------------------------------------%
% plot fields
%------------------------------------------------------------------------%

figure(4)
imagesc(X,flip(Y),flip(U_t));
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

figure(5)
imagesc(X,flip(Y),flip(V_t));
set(gca,'YDir','normal');
set(xlabel("$x/\rm m$","FontSize", 14), 'Interpreter', 'latex');
set(ylabel("$y/\rm m$","FontSize", 14), 'Interpreter', 'latex');
c = colorbar;
c.Label.String = '$\overline{V}/\rm m/s$';
c.Label.Interpreter = 'latex';
c.Label.FontSize = 14;

figure(5)
imagesc(X,flip(Y), flip(V_t));
set(gca,'YDir','normal');
set(xlabel("$x/\rm m$","FontSize", 14), 'Interpreter', 'latex');
set(ylabel("$y/\rm m$","FontSize", 14), 'Interpreter', 'latex');
c = colorbar;
c.Label.String = '$\overline{V}/\rm m/s$';
c.Label.Interpreter = 'latex';
c.Label.FontSize = 14;
hold on;
h1 = quiver(data.x{1, 1}, flip(data.y{1, 1}), zeros(size(U_t)), flip(V_t));
set(h1, 'AutoScale', 'on', 'AutoScaleFactor', 5);

figure(6)
imagesc(X,flip(Y),flip(sqrt(U_t.*U_t + V_t.*V_t)));
set(gca,'YDir','normal');
set(xlabel("$x/\rm m$","FontSize", 14), 'Interpreter', 'latex');
set(ylabel("$y/\rm m$","FontSize", 14), 'Interpreter', 'latex');
c = colorbar;
c.Label.String = '$\sqrt{\overline{U}^2+\overline{V}^2}/\rm m/s$';
c.Label.Interpreter = 'latex';
c.Label.FontSize = 14;
hold on;
sv = 6;
ny = flip(data.y{1, 1});
nU = flip(U_t);
nV = flip(V_t);
% h1 = quiver(data.x{1, 1}(1:sv:end), ny(1:sv:end), nU(1:sv:end), nV(1:sv:end), 'w');
% set(h1, 'AutoScale', 'on', 'AutoScaleFactor', .5);
% verts1 = stream2(data.x{1, 1}, flip(data.y{1, 1}), flip(U_t), flip(V_t), zeros(20, 1) + 0.011, linspace(0, 0.08, 20));
% streamline(verts1);
% verts2 = stream2(data.x{1, 1}, flip(data.y{1, 1}), flip(U_t), flip(V_t), zeros(10, 1) + 0.025, linspace(-0.08, 0, 10));
% streamline(verts2);
% verts3 = stream2(data.x{1, 1}, flip(data.y{1, 1}), flip(U_t), flip(V_t), zeros(10, 1) + 0.022, linspace(-0.08, 0, 10));
% streamline(verts3, 'w');
% colormap jet;

figure(7)
[startX,startY] = meshgrid(0.01,-0.08:0.02:0.08);
contourf(data.x{1, 1}, flip(data.y{1, 1}), flip(sqrt(U_t.*U_t + V_t.*V_t)), 20);
hold on;
quiver(data.x{1, 1}, flip(data.y{1, 1}), flip(U_t), flip(V_t));
% verts = stream2(data.x{1, 1}, flip(data.y{1, 1}), flip(U_t), flip(V_t), startX, startY);
% lineobj = streamline(data.x{1, 1}, flip(data.y{1, 1}), flip(U_t), flip(V_t), startX, startY);

