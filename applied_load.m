function L = applied_load(t)

% Editar con la carga aplicada en función del tiempo

%{

EJEMPLOS:

1. Senoidal de amplitud A alrededor de M
L = M + A*sin(t);

Impulsos:

2. Rectangular de amplitud A y duración T2 (que empieza en t=0)
L = A*(1-heaviside(t-T2));

3. Rectangular de amplitud A que empieza en T1 y acaba en T2
L = A*heaviside(t-T1).*(1-heaviside(t-T2));

4. Triangular de amplitud A que empieza en T1 y acaba en T2
L = heaviside(t-T1).*(2*A/(T2-T1)*(t-T1).*(1-heaviside(t-(T1+T2)/2))+(2*A-2*A/(T2-T1)*(t-T1)).*heaviside(t-(T1+T2)/2)).*(1-heaviside(t-T2));

5. Un semiperiodo de senoidal de amplitud A que empieza en T1 y acaba en T2
L = heaviside(t-T1).*(A*sin(pi/(T2-T1)*(t-T1))).*(1-heaviside(t-T2));

6. Explosión normalizada de amplitud A que empieza en T1 y acaba en T2 (de 0 a 0.08s ?)

L = heaviside(t-T1).*(2*A/((T1+T2)/2-T1)*(t-T1).*(1-heaviside(t-(T1+(T1+T2)/2)/2))+(2*A-2*A/((T1+T2)/2-T1)*(t-T1)).*heaviside(t-(T1+(T1+T2)/2)/2)).*(1-heaviside(t-(T1+T2)/2)) ...
  + heaviside(t-(3*T1+T2)/4).*(2*0.4*A/((T1+3*T2)/4-(3*T1+T2)/4)*(t-(3*T1+T2)/4).*(1-heaviside(t-((3*T1+T2)/4+(T1+3*T2)/4)/2))+(2*0.4*A-2*0.4*A/((T1+3*T2)/4-(3*T1+T2)/4)*(t-(3*T1+T2)/4)).*heaviside(t-((3*T1+T2)/4+(T1+3*T2)/4)/2)).*(1-heaviside(t-(T1+3*T2)/4)) ...
  + heaviside(t-(T1+T2)/2).*(2*0.1*A/(T2-(T1+T2)/2)*(t-(T1+T2)/2).*(1-heaviside(t-((T1+T2)/2+T2)/2))+(2*0.1*A-2*0.1*A/(T2-(T1+T2)/2)*(t-(T1+T2)/2)).*heaviside(t-((T1+T2)/2+T2)/2)).*(1-heaviside(t-T2));



AVISO IMPORTANTE: No usar el ejemplo 3 en caso de que T1 sea 0, usar el 2.
Si se hace habrá un pequeño error en el instante inicial.

Nota: Sumando M (una constante) a cualquiera de las funciones
anteriores se pueden obtener impulsos más complejos

%}

M = 0;
A = 40;
T1 = 0;
T2 = 0.08;


L = heaviside(t-T1).*(2*A/((T1+T2)/2-T1)*(t-T1).*(1-heaviside(t-(T1+(T1+T2)/2)/2))+(2*A-2*A/((T1+T2)/2-T1)*(t-T1)).*heaviside(t-(T1+(T1+T2)/2)/2)).*(1-heaviside(t-(T1+T2)/2)) ...
  + heaviside(t-(3*T1+T2)/4).*(2*0.4*A/((T1+3*T2)/4-(3*T1+T2)/4)*(t-(3*T1+T2)/4).*(1-heaviside(t-((3*T1+T2)/4+(T1+3*T2)/4)/2))+(2*0.4*A-2*0.4*A/((T1+3*T2)/4-(3*T1+T2)/4)*(t-(3*T1+T2)/4)).*heaviside(t-((3*T1+T2)/4+(T1+3*T2)/4)/2)).*(1-heaviside(t-(T1+3*T2)/4)) ...
  + heaviside(t-(T1+T2)/2).*(2*0.1*A/(T2-(T1+T2)/2)*(t-(T1+T2)/2).*(1-heaviside(t-((T1+T2)/2+T2)/2))+(2*0.1*A-2*0.1*A/(T2-(T1+T2)/2)*(t-(T1+T2)/2)).*heaviside(t-((T1+T2)/2+T2)/2)).*(1-heaviside(t-T2));



% %
% % Wind Load
% %
% rhoa=1.2; % Density of air [kg/m3]
% Cd=2.2; % Drag coefficient
% bv=5; % Effective width [m]
% hv=16/4; % Effective height [m]
% fv=1.2437; % Vortex sheddubg frequency [Hz]
% Deq=5; % Equivalent diameter [m] 
% U=fv*Deq/0.21; % Mean velocty of the wind [m/s]
% %
% L=1/2*rhoa*U^2*Cd*bv*hv*sin(2*pi*fv*t);
% %

end

