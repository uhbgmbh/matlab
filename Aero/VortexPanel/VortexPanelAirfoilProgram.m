% 2D Vortex Panel Airfoil Program
clear all
%{
clear all
load NACA0012.mat;
c = 1;  % chord
QINF = 1;   % freestream airspeed
alphaINF = 0;   % freestream angle
UINF = QINF*cos(alphaINF);
WINF = QINF*sin(alphaINF);
% Normalized Airfoil Profile scaled by chord length
X = c*[NACA0012X;NACA0012X(end-1:-1:1)];
Z = c*[NACA0012Y;-NACA0012Y(end-1:-1:1)];
%}
X = [1 2 3 2 1]';
Z = [0 1 0 -1 0]';
c = 5;
plot(X,Z,'-ok');
axis(c*[-0.5 1.5 -0.5 0.5]);
hold on;
% Collocation Points
Xc = (X(1:end-1)+X(2:end))/2;
Zc = (Z(1:end-1)+Z(2:end))/2;
plot(Xc,Zc,'^g');
dX = diff(X); dZ = diff(Z);
alpha = atan2(dZ,dX);   % panel angles wrt the local x, moving CW
t = [dX,dZ];            % panel tangential vector based on moving CW
ds = sqrt(dX.^2+dZ.^2);   % magnitude of tangential vector   
t = t./[ds,ds];         % unit tangential vector
n = [-sin(alpha),cos(alpha)];   % unit panel normal vector
quiver(Xc,Zc,n(:,1),n(:,2),'b');    % plot the normals at the colloc points
quiver(Xc,Zc,t(:,1),t(:,2),'r');    % plot the tangents "               "

