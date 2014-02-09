% 2D Vortex Panel Airfoil Program
clear all

% Input Airfoil Properties
load NACA0012.mat;
c = 1;  % chord
% Normalized Airfoil Profile scaled by chord length
[NACA0012X,NACA0012Y] = AddPoints(NACA0012X,NACA0012Y,2);
X = c*[NACA0012X;NACA0012X(end-1:-1:1)];
Z = c*[NACA0012Y;-NACA0012Y(end-1:-1:1)];

% Airstream Properties
QINF = 1;                   % freestream airspeed
alphaINF = -2*pi/180;        % freestream angle
UINF = QINF*cos(alphaINF);  % freestream x velocity
WINF = QINF*sin(alphaINF);  % freestream z velocity
rho = 1;                    % freestream density

%X = [1 2 3 2 1]';          % Toy Example X Coordinates
%Z = [0 1 0 -1 0]';         % Toy Example Z Coordinates    

% Collocation Points
Xc = (X(1:end-1)+X(2:end))/2;
Zc = (Z(1:end-1)+Z(2:end))/2;
dX = diff(X); dZ = diff(Z);
alpha = atan2(dZ,dX);   % panel angles wrt the global x coord, moving CW
ds = sqrt(dX.^2+dZ.^2); % magnitude of tangential vector   
t = [dX,dZ];            % panel tangential vector based on moving CW
t = t./[ds,ds];                 % unit tangential vector
n = [-sin(alpha),cos(alpha)];   % unit panel normal vector

% Solution Parameters
Npanels = length(X)-1;              % Number of vortex panels
Ncol = Npanels;                     % Number of collocation points
a = zeros(Npanels+1,Npanels+1);     % Influence coefficients matrix, Vn
b = zeros(Npanels+1,Npanels+1);     % Influence coefficients matrix, Vt
RHS = zeros(Npanels+1,1);           % Right Hand Side Vector

% Solve for Influence Coefficients
tic
for i = 1:Ncol
    for j = 1:Npanels
       rel_P1j_to_Mi_in_G = [Xc(i)-X(j),Zc(i)-Z(j)]';
       Rot = [cos(alpha(j)), sin(alpha(j)); -sin(alpha(j)), cos(alpha(j))];
       rel_P1j_to_Mi_in_Pj = Rot*rel_P1j_to_Mi_in_G;
       xcp = rel_P1j_to_Mi_in_Pj(1);
       zcp = rel_P1j_to_Mi_in_Pj(2);
       x1p = 0; z1p = 0;
       x2p = ds(j); z2p = 0;
       [~,~,Upa,Upb,Wpa,Wpb] = VOR2DLv4(1,1,xcp,zcp,x1p,z1p,x2p,z2p);
       K = [Upa Upb; Wpa Wpb];
       %dalpha = alpha(i)-alpha(j);
       %nR = [-sin(dalpha),cos(dalpha)];
       V = Rot'*K;       
       Vn = n(i,:)*V;
       Vt = t(i,:)*V;
       a(i,j:j+1) = a(i,j:j+1) + Vn;
       b(i,j:j+1) = b(i,j:j+1) + Vt;       
    end
end
toc
a(end,1) = 1; a(end,end) = 1;       % Kutta Condition

% Solve for RHS Vector
RHS(1:Npanels,1) = -n*[UINF,WINF]'; % Normal component of the freestream
RHS(end) = 0;                       % Kutta Condition

% Solve for Unknown Vortex Strengths, gamma
gamma = a\RHS;

% Compute tangential velocity, coefficient of pressure/lift
gammaave = gamma(1:end-1)+gamma(2:end);
Qt = t*[UINF,WINF]'+gammaave/4;
Cp = 1 - Qt.^2;
Cl = gammaave.*ds/2;
Cl = sum(Cl)


% Airfoil Plotting
plot(X,Z,'-ok');                    % Panel Coordinates
axis(c*[-0.5 1.5 -0.5 0.5]);
hold on;
grid on;
plot(Xc,Zc,'^g');                   % Collocation points
quiver(Xc,Zc,n(:,1),n(:,2),'b');    % plot the normals at the col points
quiver(Xc,Zc,t(:,1),t(:,2),'r');    % plot the tangents "               "




