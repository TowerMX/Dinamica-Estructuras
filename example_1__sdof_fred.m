clear
clc
%
% Response of SDOF Systems Under Harmonic Load
%            Frequency Domain Analysis
%
ms=100; % Structural Mass [kg]
ff=3; % Natural Frequency [Hz]
zetas=1/100; % Damping ratio [-]
%
ks=ms*(2*pi*ff)^2;
cs=2*ms*zetas*(2*pi*ff);
%
% FFT of the External Load
%
deltat=0.01; % Time Increment [s]
ttotal=20; % Total Time [s]
t=0:deltat:ttotal;
%
for i=1:length(t)
p(i)=ext_harm_load(t(i));
end
%
nfft = length(p); % Length of FFT
fs=100; % Sampling Frequency
p_fft = fft(p,nfft); % FFT of Externa Load
f_fft=((0:1/nfft:1-1/nfft)*fs).'; % Frecuencies of FFT [Hz]
w_fft=2*pi*f_fft; % Frequencies of FFT [rad/s]
mag_p_fft=abs(p_fft); % Magnitude of External Force
%
figure(1)
plot(f_fft(1:length(f_fft)/2-1),mag_p_fft(1:length(f_fft)/2-1))
title('FFT External Load'); 
xlabel('Frequency [Hz]')
%
% FRF
%
j=sqrt(-1);
for i=1:length(f_fft)
%    
H_frf(i)=1/((ks-w_fft(i)^2*ms)+j*w_fft(i)*cs);
%
end
%
figure(2)
plot(f_fft(1:length(f_fft)/2-1),abs(H_frf(1:length(f_fft)/2-1)))
title('Frequency Response Function'); 
xlabel('Frequency [Hz]')
%
% Response in Frequency Domain
%
y_fft=H_frf.*p_fft;
y_time =ifft(y_fft,nfft,'symmetric');
%
figure(3)
plot(f_fft(1:length(f_fft)/2-1),abs(y_fft(1:length(f_fft)/2-1)))
title('FFT Response'); 
xlabel('Frequency [Hz]')
%
% Plot Results
%
figure(4)
plot(t,y_time,'-b')
title('Response of the structure (Frequency Domain)'); 
xlabel('Time [s]')
ylabel('x(t) [m]')