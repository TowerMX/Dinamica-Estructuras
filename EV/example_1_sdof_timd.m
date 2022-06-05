clear
clc
%
% Response of SDOF Systems Under Harmonic Load
%            Time Domain Analysis
%
ms=100; % Structural Mass [kg]
ff=3; % Natural Frequency [Hz]
zetas=1/100; % Damping ratio [-]
%
ks=ms*(2*pi*ff)^2;
cs=2*ms*zetas*(2*pi*ff);
%
A = [0 1; -ks/ms -cs/ms];
B = [0 1/ms]';
C = [1 0];
D = [0];
%
sys = ss(A,B,C,D); % State-Space Model
%
% Time Domain (1st Option)
%
deltat=0.01; % Time Increment [s]
ttotal=20; % Total Time [s]
t=0:deltat:ttotal;
%
for i=1:length(t)
p(i)=ext_harm_load(t(i));
end
%
[y, tsim,z]=lsim(sys, p, t);
%
% Time Domain (2nd Option)
%
%
[tsim2, y2] = ode45(@dyn_sys_td,t,[0 0],[],A,B);
%
% Plot Results
%
figure(1)
plot(tsim,y,'-g')
title('Response of the structure (Time Domain-1st Option)'); 
xlabel('Time [s]')
ylabel('x(t) [m]')
%
figure(2)
plot(tsim2,y2(:,1),'-g')
title('Response of the structure (Time Domain-2nd Option)');
xlabel('Time [s]')
ylabel('x(t) [m]')