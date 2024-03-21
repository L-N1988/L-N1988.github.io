function Xfilted = fftfilter(X, Fs, baseFrequency)
% X: signal time serie. [array]
% Fs: sample frequency. [scalar]
% baseFrequency: frequency(ies) to be filted out. [scalar or array]

	L = length(X);
	Y = fft(X);
	% Convert to single-sided fft serie
	% See: https://ww2.mathworks.cn/help/matlab/ref/fft.html?lang=en#buuutyt-7
	P2 = abs(Y/L);
	Y = P2(1:L/2+1);
	Y(2:end-1) = 2*Y(2:end-1);
	f = Fs/L*(0:L/2);
	% Filter out energy of base frequency 
	valid = zeros(size(f));
	delta = max(diff(f));
	for i = 1:length(f)
		% Filter out left and right 10 signals around the base frequency
		valid(i) = min(abs(baseFrequency - f(i))) > 10*delta;
	end
	valid = logical(valid);
	Y = Y(valid);

	Y = Y'*L*2; % FIXME: why we need to multiply 2?
	% Reconstruct to double-sided fft serie
	% See: https://ww2.mathworks.cn/help/matlab/ref/ifft.html?lang=en#mw_b2ea0902-121e-40a5-b684-e3191898ea40
	Y2 = [Y(1) Y(2:end)/2 fliplr(conj(Y(2:end)))/2];
	Xfilted = ifft(Y2);
end
