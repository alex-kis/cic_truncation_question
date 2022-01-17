%% Sine Wave
Fs = 112.5e+6; Fc = 200e+3;
bw_s = 16;
s = round(cos(2*pi * (0:2^20 - 1)' * (Fc/Fs)) * (2^(bw_s - 1) - 1));

%% CIC Params
N = 6; R = 20;
set = [41 37 33 30 27 24 23 22 21 20 20 19 16]';

%% CIC Filter
data_int = zeros( size(s, 1), N );
for i = 1:N
    if i == 1
        data_int(:, i) = int_comb( s, set(i), set(i + 1), 0);
    else
        data_int(:, i) = int_comb( data_int(:, i - 1), set(i), set(i + 1), 0);
    end
end

data_dec = data_int(1:R:end, end);

data_comb= zeros( size(data_dec, 1), N );
for i = 1:N
    if i == 1
        data_comb(:, i) = int_comb( data_dec(:, end), set(N + i), set(N + i + 1), 1);
    else
        data_comb(:, i) = int_comb( data_comb(:, i - 1), set(N + i), set(N + i + 1), 1);
    end
end

%% Plot Spectrum
data = data_comb(:, end).*blackmanharris(size(data_comb, 1));

N_FFT = 2^nextpow2(size(data, 1));
xfft = fftshift(fft( data, N_FFT ));
xfft = 20*log10(abs(xfft));
xfft = xfft - max(xfft, [], 1);

Fs = Fs/R;
freq = ((0:N_FFT - 1) - (N_FFT / 2))'*(Fs/N_FFT);
plot(freq, xfft); grid minor;
xlim([freq(1, 1) freq(end, 1)]); ylim([-140 5])