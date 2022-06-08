clear, clc, close all

% Input Parameters (EDITAR)
%
% Auxiliares
H=16; % m
I=1/12*0.3^4; % m^4
E=3*10^10; % N/m^2
h=H/4;
heq=[0 h 2*h 3*h 4*h];
%
m=30000; % kg
k=4*12*E*I/h^3; % N/m
%
%
% Estos son los que importan:
%
% Matriz de masas
%
M=[m 0 0 0; 0 m 0 0; 0 0 m 0; 0 0 0 m]; warning('Cambiar matriz de masas (línea 20)')
%
% Matriz de rigideces
%
K=[2*k -k 0 0; -k 2*k -k 0; 0 -k 2*k -k; 0 0 -k k]; warning('Cambiar matriz de rigideces (línea 24)')
%
% Amortiguamiento
zeta = 0.01;
%
% Duración de la simulación
ttol=50; % s
%
% Donde se aplica la carga (vector COLUMNA)
% (en verdad es un triple porque no sé si significa eso)
B0 = ones(length(M),1); % Por defecto se aplica en todas las masas
%
%
% Si quieres obtener:
% Desplazamientos, 0
% Velocidades, 1
% Aceleraciones, 2
quequieres = 0;






%
% Eigenvalues and Eigenvectors
%
[phi,lamda]=eig(K,M);
for i=1:length(phi)
w_str(i)=sqrt(lamda(i,i)); %#ok<SAGROW> % Angular Natural Frequencies [rad/s]
f_str(i)=w_str(i)/2/pi; %#ok<SAGROW> % Natural Frequencies [Hz]
end
%
vnod=zeros(1+length(phi),length(phi)); % Vibration modes
%
for i=1:length(phi)
    for j=2:(1+length(phi))
vmod(j,i)=phi(j-1,i)/max(abs(min(phi(:,i))),max(phi(:,i))); %#ok<SAGROW> 
    end
end

disp('Las frecuencias naturales en rad/s son:')
disp(w_str)
disp('Y en Hz:')
disp(f_str)

disp('Modos normalizados a la unidad')
disp(' ')


% Damping Matrix
%
%zeta=1/100; % Damping Ratio
%alfa=2*zeta/(w_str(1)+w_str(4));
%beta=2*zeta*w_str(1)*w_str(4)/(w_str(1)+w_str(4));
alfa=2*zeta/(w_str(1)+w_str(end));
beta=2*zeta*w_str(1)*w_str(end)/(w_str(1)+w_str(end));
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
%warning('Hay que cambiar el space state model en las líneas 66-74')
%B0=[1 1 1 1]'; % Applied Load
A=[zeros(size(M)) eye(size(M));-M\K -M\C]; % System Matrix
B=[zeros(length(M),1);-M\B0]; % Input Matrix

% Según qué se quiera obtener:

if quequieres == 0
    E = [eye(size(M)) zeros(size(M))];
else
    E = [zeros(size(M)) eye(size(M))];
end
%{
E=[1 0 0 0 0 0 0 0;
   0 1 0 0 0 0 0 0;
   0 0 1 0 0 0 0 0;
   0 0 0 1 0 0 0 0]; % Output Matrix
%}
D=[0]; %#ok<NBRAK2> % Avance Matrix
sys = ss(A,B,E,D); % Stste Space Model
%
% Numerical Integration
%
dt=0.001; % Time increment [sec]
%ttol=50; % Overall time [sec]
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

% Derivación numérica si se quieren aceleraciones
if quequieres == 2
    y_time = (y_time(2:end,:) - y_time(1:end-1,:)) ./ (t_sim(2:end) - t_sim(1:end-1));
    t_sim = t_sim(1:end-1);
end








% Showing Vibration Modes
%
figure(1)
for i=1:length(phi)
subplot(2,2,i)
plot(vmod(:,i),heq) 
title(['Vibration Mode ',sprintf('%d',i),' Freq ',sprintf('%4.2f',f_str(i)),' Hz '])
axis([-1 1 0 16])
ylabel('Position [m]')
end













% Response in Time Domain
%
figure(2)
%
subplot(2,2,1)
plot(t_sim,y_time(:,1),'-b')
title('Response of the Mass 1'); 
xlabel('Time [s]')
switch quequieres
    case 0
        ylabel('x(t) [m]')
    case 1
        ylabel('v(t) [m/s]')
    case 2
        ylabel('a(t) [m/s^2]')
    otherwise
        error('Melón te he dicho que pongas 0, 1 o 2')
end

%
subplot(2,2,2)
plot(t_sim,y_time(:,2),'-b')
title('Response of the Mass 2'); 
xlabel('Time [s]')
switch quequieres
    case 0
        ylabel('x(t) [m]')
    case 1
        ylabel('v(t) [m/s]')
    otherwise
        ylabel('a(t) [m/s^2]')
end
%
subplot(2,2,3)
plot(t_sim,y_time(:,3),'-b')
title('Response of the Mass 3'); 
xlabel('Time [s]')
switch quequieres
    case 0
        ylabel('x(t) [m]')
    case 1
        ylabel('v(t) [m/s]')
    otherwise
        ylabel('a(t) [m/s^2]')
end
%
subplot(2,2,4)
plot(t_sim,y_time(:,4),'-b')
title('Response of the Mass 4'); 
xlabel('Time [s]')
switch quequieres
    case 0
        ylabel('x(t) [m]')
    case 1
        ylabel('v(t) [m/s]')
    otherwise
        ylabel('a(t) [m/s^2]')
end
%
% Display Results
texto = {'displacement'; 'velocity'; 'acceleration'};
unidades = {'m'; 'm/s'; 'm/s^2'};
%
disp(['The maximum ' texto{quequieres+1} ' of the 1st mass is ', sprintf('%4.3f',max(y_time(:,1))),' ' unidades{quequieres+1}])
disp(['The maximum ' texto{quequieres+1} ' of the 2nd mass is ', sprintf('%4.3f',max(y_time(:,2))),' ' unidades{quequieres+1}])
disp(['The maximum ' texto{quequieres+1} ' of the 3rd mass is ', sprintf('%4.3f',max(y_time(:,3))),' ' unidades{quequieres+1}])
disp(['The maximum ' texto{quequieres+1} ' of the 4th mass is ', sprintf('%4.3f',max(y_time(:,4))),' ' unidades{quequieres+1}])