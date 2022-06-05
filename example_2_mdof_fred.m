clear
clc
%
% Response of MDOF Systems Under Dynamic Loads
%            Frequency Domain Analysis
%
%
% Imput Parameters
%
H=16; % m
I=1/12*0.3^4; % m4
E=3*10^10; % N/m2
h=H/4;
heq=[0 h 2*h 3*h 4*h];
%
m=30000; % kg
k=4*12*E*I/h^3; % [N/m]]
%
% Mass Matrix
%
M=[m 0 0 0; 0 m 0 0; 0 0 m 0; 0 0 0 m];
%
% Stiffness Matrix
%
K=[2*k -k 0 0; -k 2*k -k 0; 0 -k 2*k -k; 0 0 -k k];
%
% Eigenvalues and Eigenvectors
%
[phi,lamda]=eig(K,M);
%
for i=1:4
w_str(i)=sqrt(lamda(i,i)); % Angular Natural Frequencies [rad/s]
f_str(i)=w_str(i)/2/pi; % Natural Frequencies [Hz]
end
%
vnod=zeros(5,4); % Vibration modes
%
for i=1:4
    for j=2:5
vmod(j,i)=phi(j-1,i)/max(abs(min(phi(:,i))),max(phi(:,i)));
    end
end
%
% Showing Vibration Modes
%
figure(1)
for i=1:4
subplot(2,2,i)
plot(vmod(:,i),heq) 
title(['Vibration Mode ',sprintf('%d',i),' Freq ',sprintf('%4.2f',f_str(i)),' Hz '])
axis([-1 1 0 16])
ylabel('Height [m]')
end
%
% Damping Matrix
%
zeta=1/100; % Dampig Ratio
alfa=2*zeta/(w_str(1)+w_str(4));
beta=2*zeta*w_str(1)*w_str(4)/(w_str(1)+w_str(4));
C=alfa*K+beta*M;
%
% Modal Matrix
%
Mm=phi'*M*phi;
Cm=phi'*C*phi;
Km=phi'*K*phi;
%
% FFT of the Wind Load
%
deltat=0.01; % Time Increment [s]
ttotal=100; % Total Time [s]
t=0:deltat:ttotal;
%
for i=1:length(t)
p(i)=wind_load(t(i));
end
%
nfft = length(p); % Length of FFT
fs=100; % Sampling Frequency
p_fft = fft(p,nfft); % FFT of Externa Load
f_fft=((0:1/nfft:1-1/nfft)*fs).'; % Frecuencies of FFT [Hz]
w_fft=2*pi*f_fft; % Frequencies of FFT [rad/s]
mag_p_fft=abs(p_fft); % Magnitude of External Force
%
figure(2)
plot(f_fft(1:length(f_fft)/2-1),mag_p_fft(1:length(f_fft)/2-1))
title('FFT Wind Load'); 
xlabel('Frequency [Hz]')
%
% FRF
%
j=sqrt(-1);
for i=1:length(f_fft)
%    
H_FRF(:,:,i)=inv((K-w_fft(i)^2*M)+j*w_fft(i)*C);
%
end
%
figure(3)
%
for i=1:1:length(f_fft)/2-1
mag_H1_FRF(i)=abs(H_FRF(1,1,i));
mag_H2_FRF(i)=abs(H_FRF(2,2,i));
mag_H3_FRF(i)=abs(H_FRF(3,3,i));
mag_H4_FRF(i)=abs(H_FRF(4,4,i));
end
%
subplot(2,2,1)
plot(f_fft(1:length(f_fft)/2-1),mag_H1_FRF)
title('Frequency Response Function-11'); 
xlabel('Frequency [Hz]')
%
subplot(2,2,2)
plot(f_fft(1:length(f_fft)/2-1),mag_H2_FRF)
title('Frequency Response Function-22'); 
xlabel('Frequency [Hz]')
%
subplot(2,2,3)
plot(f_fft(1:length(f_fft)/2-1),mag_H3_FRF)
title('Frequency Response Function-33'); 
xlabel('Frequency [Hz]')
%
subplot(2,2,4)
plot(f_fft(1:length(f_fft)/2-1),mag_H4_FRF)
title('Frequency Response Function-44'); 
xlabel('Frequency [Hz]')
%
% Response in Frequency Domain
%
for i=1:1:length(f_fft)
y_fft(:,i)=H_FRF(:,:,i)*[1 1 1 1]'*p_fft(i);
end
%
figure(4)
%
subplot(2,2,1)
plot(f_fft(1:length(f_fft)/2-1),abs(y_fft(1,1:length(f_fft)/2-1)))
title('FFT Response 1'); 
xlabel('Frequency [Hz]')
subplot(2,2,2)
plot(f_fft(1:length(f_fft)/2-1),abs(y_fft(2,1:length(f_fft)/2-1)))
title('FFT Response 2'); 
xlabel('Frequency [Hz]')
subplot(2,2,3)
plot(f_fft(1:length(f_fft)/2-1),abs(y_fft(3,1:length(f_fft)/2-1)))
title('FFT Response 3'); 
xlabel('Frequency [Hz]')
subplot(2,2,4)
plot(f_fft(1:length(f_fft)/2-1),abs(y_fft(4,1:length(f_fft)/2-1)))
title('FFT Response 4'); 
xlabel('Frequency [Hz]')
%
% Time Response in Frequency Domain
%
y1_time =ifft(y_fft(1,:),nfft,'symmetric');
y2_time =ifft(y_fft(2,:),nfft,'symmetric');
y3_time =ifft(y_fft(3,:),nfft,'symmetric');
y4_time =ifft(y_fft(4,:),nfft,'symmetric');
%
figure(5)
%
subplot(2,2,1)
plot(t,y1_time,'-b')
title('Response of the Floor 1'); 
xlabel('Time [s]')
ylabel('x(t) [m]')
%
subplot(2,2,2)
plot(t,y2_time,'-b')
title('Response of the Floor 2'); 
xlabel('Time [s]')
%
subplot(2,2,3)
plot(t,y3_time,'-b')
title('Response of the Floor 3'); 
xlabel('Time [s]')
ylabel('x(t) [m]')
%
subplot(2,2,4)
plot(t,y4_time,'-b')
title('Response of the Floor 4'); 
xlabel('Time [s]')
%
% Display Results
%
disp(['El mazimum displacement of the 1st floor is ', sprintf('%4.3f',max(y1_time)),' m'])
disp(['El mazimum displacement of the 2nd floor is ', sprintf('%4.3f',max(y2_time)),' m'])
disp(['El mazimum displacement of the 3rd floor is ', sprintf('%4.3f',max(y3_time)),' m'])
disp(['El mazimum displacement of the 4th floor is ', sprintf('%4.3f',max(y4_time)),' m'])