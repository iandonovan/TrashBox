%Michael Siegel
%4/9/12


gain = 100;

Fs = 20;
t = 0:(1/Fs):2; %2 sec
NFFT = 512; %FFT size
F = 1; %1 Hz fundamental

x = sin(2*pi*F*t); %generate sine wave



%LUT Here

if(gain ~= 'bypass') x = atan(x*gain); end

subplot(1,2,1);
plot(x,'r'); title('Waveform, gain=15'); hold on; 

xWin = x.*hanning(length(x))';%apply window for sidelobes


X = fft(xWin,NFFT);
subplot(1,2,2); plot(linspace(0,Fs/2,NFFT/2+1),abs(X(1:NFFT/2 + 1)));
title('Harmonic display, gain=15');
