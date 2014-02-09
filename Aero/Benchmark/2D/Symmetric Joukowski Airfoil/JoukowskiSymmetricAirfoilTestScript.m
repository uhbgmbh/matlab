% Symmetric Joukowski Airfoil Test Script
% - Part of 2D panel method benchmarking
% Lawrence Stratton
% 1/30/2014
% Reference: Low Speed Aerodynamics, 2nd Edition by Katz & Plotkin

%%
% Joukowski Transformation Parameters
eps = 0.1;                          % Thickness parameter
chord = 0.25;                       % Airfoil chord in meters
C = 4*chord/(3+2*eps+1/(1+2*eps));  % Transformation parameter
a = C/4*(1+eps);                    % Transformation parameter
ThicknessRatio = eps*1.299;         % Thickness Ratio
beta = 0;                           % Angle
mu = -eps*C/4;                      % Transformation Circle
Qinf = 10;                          % Freestream Velocity, m/s
alpha_deg = 6;                      % Angle of Attack, degrees
alpha = alpha_deg*pi/180;           % Angle of Attack, radians
rho = 1.225;                        % Fluid Density, kg/m^3

%%
% Airfoil coordinates
NumCoord = 100;
theta = (2*pi/(NumCoord+1):2*pi/(NumCoord+1):2*pi-2*pi/(NumCoord+1))';
Y = -eps*C/4+C/4*(1+eps).*exp(1i*theta)+...
    C^2/16./(-eps*C/4+(C/4)*(1+eps).*exp(1i*theta));
X = real(Y);
Z = imag(Y);

%%
% Transformation,Complex Velocity, and Coefficient of Pressure
f = mu+a*exp(1i*theta);
W_f = 2*1i*Qinf*(sin(alpha+beta)-sin(alpha-theta)).*exp(-1i*theta);
W_Y = W_f./(1-C^2./(16*f.^2));
usymjou = real(W_Y);
wsymjou = -imag(W_Y);
Cp = 1-(usymjou.^2+wsymjou.^2)./Qinf^2;
Gamma = 4*pi*a*Qinf*sin(alpha+beta);
L = rho*Qinf*Gamma

%%
% Plotting
figure; hold on;
hAxis = 2.5;
axisMax = hAxis*chord;
plot(X/chord,Z/chord,'k.');
axis([-axisMax axisMax -chord chord]);
quiver(X/chord,Z/chord,usymjou,wsymjou,'b');
title('Exact Results for Symmetric Joukowski Airfoil');
xlabel('Normalized Horizontal Chord Location');
ylabel('Normalized Vertical Chord Location');
legend(['Angle of Attack(deg): ' num2str(alpha_deg)]);

figure;
plot(X(1:NumCoord/2)/chord,Cp(1:NumCoord/2),'b-o',...
     X(NumCoord/2+1:NumCoord)/chord,Cp(NumCoord/2+1:NumCoord),'r-^');
axis([-2.1*chord 2.1*chord min(Cp) max(Cp)]); 
legend('Upper Surface Cp','Lower Surface Cp');
xlabel('Normalized Horizontal Chord Location');
ylabel('Coefficient of Pressure (Normalized)');
title('Exact Results for Symmetric Joukowski Airfoil');








