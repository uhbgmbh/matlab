% 2D Vortex Panel Airfoil Program
clear all
load NACA0012.mat;
c = 1;  % chord
% Normalized Airfoil Profile scaled by chord length
X = c*[NACA0012X;NACA0012X(end-1:-1:1)];
Z = c*[NACA0012Y;-NACA0012Y(end-1:-1:1)];
QINF = 1;   % freestream airspeed
alphaINF = 0*pi/180;   % freestream angle
UINF = QINF*cos(alphaINF);
WINF = QINF*sin(alphaINF);
rho = 1;
%X = [1 2 3 2 1]';
%Z = [0 1 0 -1 0]';
plot(X,Z,'-ok');
axis(c*[-0.5 1.5 -0.5 0.5]);
%axis([1 3 -1 1])
%axis square;
hold on;
% Collocation Points
Xc = (X(1:end-1)+X(2:end))/2;
Zc = (Z(1:end-1)+Z(2:end))/2;
plot(Xc,Zc,'^g');
dX = diff(X); dZ = diff(Z);
alpha = atan2(dZ,dX);   % panel angles wrt the local x, moving CW
t = [dX,dZ];            % panel tangential vector based on moving CW
ds = sqrt(dX.^2+dZ.^2);         % magnitude of tangential vector   
t = t./[ds,ds];                 % unit tangential vector
n = [-sin(alpha),cos(alpha)];   % unit panel normal vector
quiver(Xc,Zc,n(:,1),n(:,2),'b');    % plot the normals at the colloc points
quiver(Xc,Zc,t(:,1),t(:,2),'r');    % plot the tangents "               "

Npanels = length(X)-1;              % Number of vortex panels
Ncol = Npanels;                     % Number of collocation points
a = zeros(Npanels+1,Npanels+1);     % Influence coefficients
RHS = zeros(Npanels+1,1);           % Right Hand Side Vector
RHS(1:Npanels,1) = -n*[UINF,WINF]';
RHS(end) = 0;
tic
for i = 1:Ncol
    for j = 1:Npanels
       rel_P1j_to_Mi_in_G = [Xc(i)-X(j),Zc(i)-Z(j)]';
       Rot = [cos(alpha(j)), sin(alpha(j)); -sin(alpha(j)), cos(alpha(j))];
       rel_P1j_to_Mi_in_Pj = Rot*rel_P1j_to_Mi_in_G;
       xcp = rel_P1j_to_Mi_in_Pj(1);
       zcp = rel_P1j_to_Mi_in_Pj(2);
       [~,~,Upa,Upb,Wpa,Wpb] = VOR2DLv2(1,1,xcp,zcp,X(j),Z(j),X(j+1),Z(j+1));
       K = [Upa Upb; Wpa Wpb];
       dalpha = alpha(i)-alpha(j);
       nR = [-sin(dalpha),cos(dalpha)];
       Vn = nR*K;
       a(i,j:j+1) = a(i,j:j+1) + Vn;
    end
end
toc
a(end,1) = 1; a(end,end) = 1;
gamma = a\RHS;
gammaave = gamma(1:end-1)+gamma(2:end);
Qt = zeros(Npanels,1);
Qt = t*[UINF,WINF]'+gammaave/4
Cp = 1 - Qt.^2./QINF.^2
dL = rho*QINF*gammaave/2.*ds
L = sum(dL)






