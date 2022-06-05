clear, clc, close all

% Input Parameters (EDITAR)
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
for i=1:4
w_str(i)=sqrt(lamda(i,i)); %#ok<SAGROW> % Angular Natural Frequencies [rad/s]
f_str(i)=w_str(i)/2/pi; %#ok<SAGROW> % Natural Frequencies [Hz]
end
%
vnod=zeros(5,4); % Vibration modes
%
for i=1:4
    for j=2:5
vmod(j,i)=phi(j-1,i)/max(abs(min(phi(:,i))),max(phi(:,i))); %#ok<SAGROW> 
    end
end





% Damping Matrix
%
zeta=1/100; % Damping Ratio
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
% State Space Model
%
B0=[1 1 1 1]'; % Applied Load
A=[zeros(4,4) eye(4,4);-M\K -M\C]; % System Matrix
B=[zeros(4,1);M\B0]; % Input Matrix
E=[1 0 0 0 0 0 0 0;
   0 1 0 0 0 0 0 0;
   0 0 1 0 0 0 0 0;
   0 0 0 1 0 0 0 0]; % Output Matrix
D=[0]; %#ok<NBRAK2> % Avance Matrix
sys = ss(A,B,E,D); % Stste Space Model
%
% Numerical Integration
%
dt=0.01; % Time increment [sec]
ttol=50; % Overall time [sec]
t = 0:dt:ttol; % Time vector
u=zeros(1,length(t)); % External Load Matriz
%
% Applied Load
%
for i=1:length(t)
u(i)=applied_load(t(i));    
end
%
[y_time,t_sim, z]=lsim(sys, u, t);
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













% Response in Time Domain
%
figure(2)
%
subplot(2,2,1)
plot(t_sim,y_time(:,1),'-b')
title('Response of the Floor 1'); 
xlabel('Time [s]')
ylabel('x(t) [m]')
%
subplot(2,2,2)
plot(t_sim,y_time(:,2),'-b')
title('Response of the Floor 2'); 
xlabel('Time [s]')
ylabel('x(t) [m]')
%
subplot(2,2,3)
plot(t_sim,y_time(:,3),'-b')
title('Response of the Floor 3'); 
xlabel('Time [s]')
ylabel('x(t) [m]')
%
subplot(2,2,4)
plot(t_sim,y_time(:,4),'-b')
title('Response of the Floor 4'); 
xlabel('Time [s]')
ylabel('x(t) [m]')
%
% Display Results
%
disp(['El mazimum displacement of the 1st floor is ', sprintf('%4.3f',max(y_time(:,1))),' m'])
disp(['El mazimum displacement of the 2nd floor is ', sprintf('%4.3f',max(y_time(:,2))),' m'])
disp(['El mazimum displacement of the 3rd floor is ', sprintf('%4.3f',max(y_time(:,3))),' m'])
disp(['El mazimum displacement of the 4th floor is ', sprintf('%4.3f',max(y_time(:,4))),' m'])