%calcular matriz de rigidez a partir de la de flexibilidad:

L=16; % m
I=1/12*0.3^4; % m4
E=3*10^10; % N/m2
l=L/4;
leq=[0 l 2*l 3*l 4*l];

x_11 = [leq(1):0.01:leq(2)];
x_12 = x_11;
x_13 = x_11;
x_14 = x_11;

x_22 = [leq(1):0.01:leq(3)];
x_23 = x_22;
x_24 = x_22;

x_33 = [leq(1):0.01:leq(4)];
x_34 = x_33;

x_44 = [leq(1):0.01:leq(5)];

alpha_11 = (1/(E*I))*trapz(x_11, (leq(2)-x_11).^2);
alpha_12 = (1/(E*I))*trapz(x_12, (leq(2)-x_12).*(leq(3)-x_12));
alpha_13 = (1/(E*I))*trapz(x_13, (leq(2)-x_13).*(leq(4)-x_13));
alpha_14 = (1/(E*I))*trapz(x_14, (leq(2)-x_14).*(leq(5)-x_14));

alpha_22 = (1/(E*I))*trapz(x_22, (leq(3)-x_22).^2);
alpha_23 = (1/(E*I))*trapz(x_23, (leq(3)-x_23).*(leq(4)-x_23));
alpha_24 = (1/(E*I))*trapz(x_24, (leq(3)-x_24).*(leq(5)-x_24));

alpha_33 = (1/(E*I))*trapz(x_33, (leq(4)-x_33).^2);
alpha_34 = (1/(E*I))*trapz(x_34, (leq(4)-x_34).*(leq(5)-x_34));

alpha_44 = (1/(E*I))*trapz(x_44, (leq(5)-x_44).^2);


alpha = [alpha_11, alpha_12, alpha_13, alpha_14;...
         alpha_12, alpha_22, alpha_23, alpha_24;...
         alpha_13, alpha_23, alpha_33, alpha_34;...
         alpha_14, alpha_24, alpha_34, alpha_44]
k = alpha^-1