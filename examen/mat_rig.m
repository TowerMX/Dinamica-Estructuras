function K = mat_rig()
%calcular matriz de rigidez a partir de la de flexibilidad:

L=5; % m
I=13e-5; % m^4
E=70e9; % N/m^2 = Pa
l=L/3;
leq=[0 l 2*l 3*l];

x_11 = leq(1):0.0001:leq(2);
x_12 = x_11;
x_13 = x_11;

x_22 = leq(1):0.0001:leq(3);
x_23 = x_22;

x_33 = leq(1):0.0001:leq(4);


alpha_11 = (1/(E*I))*trapz(x_11, (leq(2)-x_11).^2);
alpha_12 = (1/(E*I))*trapz(x_12, (leq(2)-x_12).*(leq(3)-x_12));
alpha_13 = (1/(E*I))*trapz(x_13, (leq(2)-x_13).*(leq(4)-x_13));

alpha_22 = (1/(E*I))*trapz(x_22, (leq(3)-x_22).^2);
alpha_23 = (1/(E*I))*trapz(x_23, (leq(3)-x_23).*(leq(4)-x_23));

alpha_33 = (1/(E*I))*trapz(x_33, (leq(4)-x_33).^2);


Alpha = [alpha_11, alpha_12, alpha_13;...
         alpha_12, alpha_22, alpha_23;...
         alpha_13, alpha_23, alpha_33];

K = inv(Alpha);

end