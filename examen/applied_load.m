function L = applied_load(vc,t)

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

6. Explosión normalizada de amplitud máxima A que empieza en T1 y acaba en T2 (de 0 a 0.08s ?)

L = heaviside(t-T1).*(2*A/((T1+T2)/2-T1)*(t-T1).*(1-heaviside(t-(T1+(T1+T2)/2)/2))+(2*A-2*A/((T1+T2)/2-T1)*(t-T1)).*heaviside(t-(T1+(T1+T2)/2)/2)).*(1-heaviside(t-(T1+T2)/2)) ...
  + heaviside(t-(3*T1+T2)/4).*(2*0.4*A/((T1+3*T2)/4-(3*T1+T2)/4)*(t-(3*T1+T2)/4).*(1-heaviside(t-((3*T1+T2)/4+(T1+3*T2)/4)/2))+(2*0.4*A-2*0.4*A/((T1+3*T2)/4-(3*T1+T2)/4)*(t-(3*T1+T2)/4)).*heaviside(t-((3*T1+T2)/4+(T1+3*T2)/4)/2)).*(1-heaviside(t-(T1+3*T2)/4)) ...
  + heaviside(t-(T1+T2)/2).*(2*0.1*A/(T2-(T1+T2)/2)*(t-(T1+T2)/2).*(1-heaviside(t-((T1+T2)/2+T2)/2))+(2*0.1*A-2*0.1*A/(T2-(T1+T2)/2)*(t-(T1+T2)/2)).*heaviside(t-((T1+T2)/2+T2)/2)).*(1-heaviside(t-T2));


AVISO IMPORTANTE: No usar el ejemplo 3 en caso de que T1 sea 0, usar el 2.
Si se hace habrá un pequeño error en el instante inicial.

Nota: Sumando M (una constante) a cualquiera de las funciones
anteriores se pueden obtener impulsos más complejos

%}



% Parámetros editables
C = 1;
C_L = 0.6;
ro_a = 1.2;

M = 0;
A = 10;
T1 = 0;
T2 = 20*C;


% Ahora copia y pega un ejemplo de arriba, o haz uno propio
u = @(x) heaviside(x-T1).*(A*sin(pi/(T2-T1)*(x-T1))).*(1-heaviside(x-T2));
p = 1/2*C_L*ro_a*u(vc*t).^2;
L = 5*1*2*p;

end