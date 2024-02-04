%% ...
%% Nfft        %% [integer scalar] Length of FFT.  The default is the length
%%             %%       of the "window" vector or has the same value as the
%%             %%       scalar "window" argument.  If Nfft is larger than the
%%             %%       segment length, "seg_len", the data segment is padded
%%             %%       with "Nfft-seg_len" zeros.  The default is no padding.
%%             %%       Nfft values smaller than the length of the data
%%             %%       segment (or window) are ignored silently.
%%
%% Fs          %% [real scalar] sampling frequency (Hertz); default=1.0
%%
%% minimum FFT length is seg_len
Nfft = max( Nfft, seg_len );
%% Mean square of window is required for normalising PSD amplitude.
win_meansq = (window.' * window) / seg_len;
%%
%% Set default or check overlap.
if ( isempty(overlap) )
	overlap = fix(seg_len /2);
elseif ( overlap >= seg_len )
	error( 'pwelch: arg (overlap=%d) too big. Must be <length(window)=%d',...
		overlap, seg_len );
end
%%
%% MAIN CALCULATIONS
%% ...
%% 
%% Calculate and accumulate periodograms
%%   xx and yy are padded data segments
%%   Pxx is periodogram sum
xx = zeros(Nfft,1);
Pxx = xx;
n_ffts = 0;
for start_seg = [1:seg_len-overlap:x_len-seg_len+1]
	end_seg = start_seg+seg_len-1;
	%% Don't truncate/remove the zero padding in xx and yy
	xx(1:seg_len) = window .* x(start_seg:end_seg);
	fft_x = fft(xx);
	%% force Pxx to be real; pgram = periodogram
	pgram = real(fft_x .* conj(fft_x));
	Pxx = Pxx + pgram;
	n_ffts = n_ffts +1;
end
psd_len = Nfft;
%% end MAIN CALCULATIONS
%%
%% SCALING AND OUTPUT
%%   Pxx is sum of periodogram, so "n_ffts"
%%   in the scale factor converts them into averages
spectra    = zeros(psd_len);
scale = n_ffts * seg_len * Fs * win_meansq;

spectra(:) = Pxx / scale;
freq = [0:psd_len-1].' * ( Fs / Nfft );
