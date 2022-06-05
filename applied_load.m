function L = applied_load(t)

% Editar con la carga aplicada en función del tiempo

%L = 50 + 10*sin(t); % Ejemplo

%
% Wind Load
%
rhoa=1.2; % Density of air [kg/m3]
Cd=2.2; % Drag coefficient
bv=5; % Effective width [m]
hv=16/4; % Effective height [m]
fv=1.2437; % Vortex sheddubg frequency [Hz]
Deq=5; % Equivalent diameter [m] 
U=fv*Deq/0.21; % Mean velocty of the wind [m/s]
%
L=1/2*rhoa*U^2*Cd*bv*hv*sin(2*pi*fv*t);
%

end

